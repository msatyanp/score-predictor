"use client";

import {
  type PointerEvent,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";

import { StatusPill } from "@/components/ui/status-pill";
import { getErrorMessage } from "@/lib/forms/error-message";
import { listMatches } from "@/lib/matches";
import type { MatchResponse } from "@/lib/matches";
import type { PillTone } from "@/lib/matches/types";
import { getMatchLabelWithFlag, MatchVenue } from "../ui/match-card";

type StageConfig = {
  expectedMatches: number;
  fallbackStage?: string;
  label: string;
  queryStage: string;
};

type BracketRound = {
  config: StageConfig;
  matches: MatchResponse[];
  queryStage: string;
};

type BracketSlot = {
  height: number;
  id: string;
  match: MatchResponse | null;
  roundIndex: number;
  slotIndex: number;
  width: number;
  x: number;
  y: number;
};

type Connector = {
  endX: number;
  endY: number;
  midX: number;
  startX: number;
  startY: number;
};

type BracketLayout = {
  connectors: Connector[];
  height: number;
  slots: BracketSlot[];
  slotsByRound: BracketSlot[][];
  width: number;
};

const STAGES: StageConfig[] = [
  {
    expectedMatches: 16,
    label: "Round of 32",
    queryStage: "R32",
  },
  {
    expectedMatches: 8,
    label: "Round of 16",
    queryStage: "R16",
  },
  {
    expectedMatches: 4,
    fallbackStage: "QF",
    label: "Quarterfinals",
    queryStage: "quarterfinals",
  },
  {
    expectedMatches: 2,
    fallbackStage: "SF",
    label: "Semifinals",
    queryStage: "semifinals",
  },
  {
    expectedMatches: 1,
    label: "F",
    queryStage: "F",
  },
];

const CANVAS_PADDING_X = 32;
const CANVAS_PADDING_TOP = 82;
const CANVAS_PADDING_BOTTOM = 54;
const CARD_WIDTH = 230;
const CARD_HEIGHT = 90;
const COLUMN_GAP = 78;
const SLOT_PITCH = 100;
const CARD_RADIUS = 8;

const emptyRounds = (): BracketRound[] =>
  STAGES.map((config) => ({
    config,
    matches: [],
    queryStage: config.queryStage,
  }));

const getSlotId = (roundIndex: number, slotIndex: number): string =>
  `${roundIndex}:${slotIndex}`;

const sortMatches = (matches: MatchResponse[]): MatchResponse[] => {
  return [...matches].sort((left, right) => {
    const leftTime = new Date(`${left.match_datetime}Z`).getTime();
    const rightTime = new Date(`${right.match_datetime}Z`).getTime();

    if (Number.isFinite(leftTime) && Number.isFinite(rightTime)) {
      return leftTime - rightTime || left.id - right.id;
    }

    return left.id - right.id;
  });
};

const fetchStageMatches = async (
  config: StageConfig,
): Promise<Pick<BracketRound, "matches" | "queryStage">> => {
  const primaryResponse = await listMatches({
    limit: 64,
    matchStage: config.queryStage,
  });

  if (config.queryStage === "F" && primaryResponse.items.length > 1) {
    return {
      matches: [primaryResponse.items[1]],
      queryStage: config.queryStage,
    };
  }

  if (primaryResponse.items.length > 0 || !config.fallbackStage) {
    return {
      matches: sortMatches(primaryResponse.items),
      queryStage: config.queryStage,
    };
  }

  const fallbackResponse = await listMatches({
    limit: 64,
    matchStage: config.fallbackStage,
  });

  return {
    matches: sortMatches(fallbackResponse.items),
    queryStage: config.fallbackStage,
  };
};

const getFirstRoundSlotCount = (rounds: BracketRound[]): number => {
  return rounds.reduce((maximum, round, roundIndex) => {
    const slotCount = Math.max(
      round.config.expectedMatches,
      round.matches.length,
    );
    return Math.max(maximum, slotCount * 2 ** roundIndex);
  }, STAGES[0].expectedMatches);
};

const createBracketLayout = (rounds: BracketRound[]): BracketLayout => {
  const firstRoundSlotCount = getFirstRoundSlotCount(rounds);
  const width =
    CANVAS_PADDING_X * 2 +
    STAGES.length * CARD_WIDTH +
    (STAGES.length - 1) * COLUMN_GAP;
  const height =
    CANVAS_PADDING_TOP +
    firstRoundSlotCount * SLOT_PITCH +
    CANVAS_PADDING_BOTTOM;

  const slotsByRound = rounds.map((round, roundIndex) => {
    const slotCount = Math.max(
      round.config.expectedMatches,
      round.matches.length,
    );
    const slotSpan = firstRoundSlotCount / slotCount;
    const x = CANVAS_PADDING_X + roundIndex * (CARD_WIDTH + COLUMN_GAP);

    return Array.from({ length: slotCount }, (_, slotIndex) => {
      const centerSlot = (slotIndex + 0.5) * slotSpan - 0.5;
      const centerY = CANVAS_PADDING_TOP + centerSlot * SLOT_PITCH + SLOT_PITCH / 2;

      return {
        height: CARD_HEIGHT,
        id: getSlotId(roundIndex, slotIndex),
        match: round.matches[slotIndex] ?? null,
        roundIndex,
        slotIndex,
        width: CARD_WIDTH,
        x,
        y: centerY - CARD_HEIGHT / 2,
      };
    });
  });

  const connectors: Connector[] = [];
  for (let roundIndex = 0; roundIndex < slotsByRound.length - 1; roundIndex += 1) {
    const currentSlots = slotsByRound[roundIndex];
    const nextSlots = slotsByRound[roundIndex + 1];

    nextSlots.forEach((nextSlot, nextIndex) => {
      const upperSlot = currentSlots[nextIndex * 2];
      const lowerSlot = currentSlots[nextIndex * 2 + 1];

      if (!upperSlot || !lowerSlot) {
        return;
      }

      const startX = upperSlot.x + upperSlot.width;
      const midX = startX + COLUMN_GAP / 2;
      const endX = nextSlot.x;
      const endY = nextSlot.y + nextSlot.height / 2;

      connectors.push({
        endX,
        endY,
        midX,
        startX,
        startY: upperSlot.y + upperSlot.height / 2,
      });
      connectors.push({
        endX,
        endY,
        midX,
        startX,
        startY: lowerSlot.y + lowerSlot.height / 2,
      });
    });
  }

  return {
    connectors,
    height,
    slots: slotsByRound.flat(),
    slotsByRound,
    width,
  };
};

const findSlot = (
  rounds: BracketRound[],
  slotId: string | null,
): BracketSlot | null => {
  if (!slotId) {
    return null;
  }

  const [roundIndexValue, slotIndexValue] = slotId.split(":");
  const roundIndex = Number(roundIndexValue);
  const slotIndex = Number(slotIndexValue);

  if (!Number.isInteger(roundIndex) || !Number.isInteger(slotIndex)) {
    return null;
  }

  const round = rounds[roundIndex];
  if (!round) {
    return null;
  }

  return {
    height: CARD_HEIGHT,
    id: slotId,
    match: round.matches[slotIndex] ?? null,
    roundIndex,
    slotIndex,
    width: CARD_WIDTH,
    x: 0,
    y: 0,
  };
};

const findFirstMatchSlotId = (rounds: BracketRound[]): string | null => {
  for (let roundIndex = 0; roundIndex < rounds.length; roundIndex += 1) {
    const slotIndex = rounds[roundIndex].matches.findIndex(Boolean);

    if (slotIndex !== -1) {
      return getSlotId(roundIndex, slotIndex);
    }
  }

  return null;
};

const getMatchStatus = (
  match: MatchResponse | null,
): { label: string; tone: PillTone } => {
  if (!match) {
    return { label: "Pending", tone: "zinc" };
  }

  if (match.team1_score !== null && match.team2_score !== null) {
    return { label: "Completed", tone: "green" };
  }

  if (match.match_locked) {
    return { label: "Locked", tone: "red" };
  }

  return { label: "Scheduled", tone: "blue" };
};

const formatDateTime = (value: string): string => {
  const date = new Date(`${value}Z`);

  if (Number.isNaN(date.getTime())) {
    return value;
  }

  return new Intl.DateTimeFormat("en", {
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
    month: "short",
    timeZone: "Asia/Kathmandu",
  }).format(date);
};

const getWinnerSide = (match: MatchResponse): "team1" | "team2" | null => {
  if (match.team1_score === null || match.team2_score === null) {
    return null;
  }

  if (match.team1_score > match.team2_score) {
    return "team1";
  }

  if (match.team2_score > match.team1_score) {
    return "team2";
  }

  return null;
};

const truncateText = (
  context: CanvasRenderingContext2D,
  text: string,
  maxWidth: number,
): string => {
  if (context.measureText(text).width <= maxWidth) {
    return text;
  }

  let nextText = text;
  while (nextText.length > 1 && context.measureText(`${nextText}...`).width > maxWidth) {
    nextText = nextText.slice(0, -1);
  }

  return `${nextText}...`;
};

const drawRoundedRectangle = (
  context: CanvasRenderingContext2D,
  x: number,
  y: number,
  width: number,
  height: number,
  radius: number,
): void => {
  const nextRadius = Math.min(radius, width / 2, height / 2);

  context.beginPath();
  context.moveTo(x + nextRadius, y);
  context.lineTo(x + width - nextRadius, y);
  context.quadraticCurveTo(x + width, y, x + width, y + nextRadius);
  context.lineTo(x + width, y + height - nextRadius);
  context.quadraticCurveTo(
    x + width,
    y + height,
    x + width - nextRadius,
    y + height,
  );
  context.lineTo(x + nextRadius, y + height);
  context.quadraticCurveTo(x, y + height, x, y + height - nextRadius);
  context.lineTo(x, y + nextRadius);
  context.quadraticCurveTo(x, y, x + nextRadius, y);
  context.closePath();
};

const drawConnector = (
  context: CanvasRenderingContext2D,
  connector: Connector,
): void => {
  context.beginPath();
  context.moveTo(connector.startX, connector.startY);
  context.lineTo(connector.midX, connector.startY);
  context.lineTo(connector.midX, connector.endY);
  context.lineTo(connector.endX, connector.endY);
  context.stroke();
};

const loadImage = async (url: string): Promise<HTMLImageElement | null> => {
  return new Promise((resolve) => {
    if (!url) return resolve(null);
    const img = new Image();
    img.crossOrigin = "anonymous";
    img.src = url;
    img.onload = () => resolve(img);
    img.onerror = () => resolve(null);
  });
}

const drawSlot = async (
  context: CanvasRenderingContext2D,
  slot: BracketSlot,
  selectedSlotId: string | null,
  hoveredSlotId: string | null,
): Promise<void> => {
  const match = slot.match;
  const isSelected = selectedSlotId === slot.id;
  const isHovered = hoveredSlotId === slot.id;
  const winnerSide = match ? getWinnerSide(match) : null;

  context.save();
  context.shadowColor = "rgba(15, 23, 42, 0.08)";
  context.shadowBlur = isHovered || isSelected ? 12 : 6;
  context.shadowOffsetY = isHovered || isSelected ? 5 : 2;
  drawRoundedRectangle(
    context,
    slot.x,
    slot.y,
    slot.width,
    slot.height,
    CARD_RADIUS,
  );
  context.fillStyle = "#ffffff";
  if (!match) {
    context.fillStyle = "#f8fafc";
  }
  context.fill();
  context.restore();

  drawRoundedRectangle(
    context,
    slot.x,
    slot.y,
    slot.width,
    slot.height,
    CARD_RADIUS,
  );
  context.strokeStyle = isSelected ? "#047857" : isHovered ? "#d97706" : "#d4d4d8";
  context.lineWidth = isSelected ? 1.5 : 1;
  context.stroke();

  context.fillStyle = isSelected ? "#047857" : "#64748b";

  context.font =
    "600 13px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
  context.textBaseline = "middle";

  if (!match) {
    context.fillStyle = "#71717a";
    context.fillText("TBD", slot.x + 14, slot.y + 27);
    context.fillText("TBD", slot.x + 14, slot.y + 50);
    context.font =
      "500 11px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
    return;
  }

  const teamTextWidth = slot.width - 72;
  const maxWidth = 26;
  const maxHeight = 26;

  if (match.team1_flag_url) {
    const flagSrc = await loadImage(match.team1_flag_url)
    if (flagSrc) {
      const scale = Math.min(maxWidth / flagSrc.width, maxHeight / flagSrc.height, 1);
      context.drawImage(flagSrc, slot.x + 10, slot.y + 25 / 2, flagSrc.width * scale, flagSrc.height * scale);
    }
  }
  context.fillStyle = winnerSide === "team1" ? "#047857" : "#18181b";
  context.fillText(
    truncateText(context, match.team1_name, teamTextWidth),
    slot.x + 30,
    slot.y + 25,
  );

  if (match.team2_flag_url) {
    const flagSrc = await loadImage(match.team2_flag_url)
    if (flagSrc) {
      const scale = Math.min(maxWidth / flagSrc.width, maxHeight / flagSrc.height, 1);
      context.drawImage(flagSrc, slot.x + 10, slot.y + 55 - 25 / 2, flagSrc.width * scale, flagSrc.height * scale);
    }
  }
  context.fillStyle = winnerSide === "team2" ? "#047857" : "#18181b";
  context.fillText(
    truncateText(context, match.team2_name, teamTextWidth),
    slot.x + 30,
    slot.y + 55,
  );

  context.font =
    "700 13px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
  context.textAlign = "right";
  context.fillStyle = "#334155";
  context.textAlign = "left";

  context.font =
    "500 10px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
  context.fillStyle = "#71717a";
  context.fillText(
    truncateText(context, formatDateTime(match.match_datetime), teamTextWidth),
    slot.x + 30,
    slot.y + 75,
  );

  if (match.match_stage === "F") {
    const trophySrc = await loadImage("/images/trophy.png")
    if (trophySrc) {
      const scale = Math.min(150 / trophySrc.width, 150 / trophySrc.height, 1);
      context.drawImage(trophySrc, slot.x + 160, slot.y - 45, trophySrc.width * scale, trophySrc.height * scale);
    }
  }
};

const drawBracket = async (
  canvas: HTMLCanvasElement,
  rounds: BracketRound[],
  selectedSlotId: string | null,
  hoveredSlotId: string | null,
): Promise<BracketLayout | null> => {
  const context = canvas.getContext("2d");
  if (!context) {
    return null;
  }

  const layout = createBracketLayout(rounds);
  const ratio = window.devicePixelRatio || 1;

  canvas.width = layout.width * ratio;
  canvas.height = layout.height * ratio;
  canvas.style.width = `${layout.width}px`;
  canvas.style.height = `${layout.height}px`;

  context.setTransform(ratio, 0, 0, ratio, 0, 0);
  context.clearRect(0, 0, layout.width, layout.height);
  context.fillStyle = "#f8fafc";
  context.fillRect(0, 0, layout.width, layout.height);

  context.strokeStyle = "#cbd5e1";
  context.lineWidth = 2;
  layout.connectors.forEach((connector) => drawConnector(context, connector));

  context.textBaseline = "middle";
  context.font =
    "700 12px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
  context.fillStyle = "#475569";
  STAGES.forEach((stage, roundIndex) => {
    const x = CANVAS_PADDING_X + roundIndex * (CARD_WIDTH + COLUMN_GAP);
    context.fillText(stage.label.toUpperCase(), x, 34);
    context.fillStyle = "#94a3b8";
    context.font =
      "500 11px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
    const loadedCount = rounds[roundIndex]?.matches.length ?? 0;
    context.fillText(`${loadedCount}/${stage.expectedMatches} matches`, x, 54);
    context.font =
      "700 12px ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif";
    context.fillStyle = "#475569";
  });

  for (const slot of layout.slots) {
    await drawSlot(context, slot, selectedSlotId, hoveredSlotId);
  }

  return layout;
};

const getCanvasPoint = (
  canvas: HTMLCanvasElement,
  event: PointerEvent<HTMLCanvasElement>,
): { x: number; y: number } => {
  const rect = canvas.getBoundingClientRect();

  return {
    x: event.clientX - rect.left,
    y: event.clientY - rect.top,
  };
};

const hitTestSlot = (
  slots: BracketSlot[],
  point: { x: number; y: number },
): BracketSlot | null => {
  return (
    slots.find(
      (slot) =>
        point.x >= slot.x &&
        point.x <= slot.x + slot.width &&
        point.y >= slot.y &&
        point.y <= slot.y + slot.height,
    ) ?? null
  );
};

export function BracketCanvas() {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const layoutRef = useRef<BracketLayout | null>(null);
  const [hoveredSlotId, setHoveredSlotId] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [rounds, setRounds] = useState<BracketRound[]>(emptyRounds);
  const [selectedSlotId, setSelectedSlotId] = useState<string | null>(null);

  const loadBracket = useCallback(async () => {
    setIsLoading(true);
    setLoadError(null);

    try {
      const nextRounds = await Promise.all(
        STAGES.map(async (config) => {
          const stageMatches = await fetchStageMatches(config);
          return {
            config,
            matches: stageMatches.matches,
            queryStage: stageMatches.queryStage,
          };
        }),
      );

      setRounds(nextRounds);
      setSelectedSlotId((currentSlotId) => {
        if (findSlot(nextRounds, currentSlotId)) {
          return currentSlotId;
        }

        return findFirstMatchSlotId(nextRounds);
      });
    } catch (error) {
      setLoadError(getErrorMessage(error, "Unable to load bracket matches."));
      setRounds(emptyRounds());
      setSelectedSlotId(null);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    const timeoutId = window.setTimeout(() => {
      void loadBracket();
    }, 0);

    return () => {
      window.clearTimeout(timeoutId);
    };
  }, [loadBracket]);

  useEffect(() => {
    (async () => {
      const canvas = canvasRef.current;
      if (!canvas) {
        return;
      }

      layoutRef.current = await drawBracket(
        canvas,
        rounds,
        selectedSlotId,
        hoveredSlotId,
      );
    })();
  }, [hoveredSlotId, rounds, selectedSlotId]);

  const selectedSlot = useMemo(
    () => findSlot(rounds, selectedSlotId),
    [rounds, selectedSlotId],
  );
  const selectedMatch = selectedSlot?.match ?? null;
  const selectedRound =
    selectedSlot !== null ? rounds[selectedSlot.roundIndex] : null;
  const selectedStatus = getMatchStatus(selectedMatch);
  const loadedMatchCount = rounds.reduce(
    (total, round) => total + round.matches.length,
    0,
  );

  const handlePointerMove = (event: PointerEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    const layout = layoutRef.current;

    if (!canvas || !layout) {
      return;
    }

    const slot = hitTestSlot(layout.slots, getCanvasPoint(canvas, event));
    setHoveredSlotId(slot?.id ?? null);
    canvas.style.cursor = slot ? "pointer" : "default";
  };

  const handlePointerLeave = () => {
    setHoveredSlotId(null);
    if (canvasRef.current) {
      canvasRef.current.style.cursor = "default";
    }
  };

  const handleCanvasClick = (event: PointerEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    const layout = layoutRef.current;

    if (!canvas || !layout) {
      return;
    }

    const slot = hitTestSlot(layout.slots, getCanvasPoint(canvas, event));
    if (slot) {
      setSelectedSlotId(slot.id);
    }
  };

  return (
    <div className="grid gap-4">
      {loadError ? (
        <div className="rounded-md border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800">
          {loadError}
        </div>
      ) : null}

      <div className="flex flex-wrap items-center justify-between gap-3 rounded-md border border-zinc-200 bg-white px-4 py-3 shadow-sm">
        <div>
          <h2 className="text-lg font-semibold text-zinc-950">
            Knockout bracket
          </h2>
          <p className="mt-1 text-sm text-zinc-500">
            {isLoading
              ? "Loading matches..."
              : `${loadedMatchCount} knockout matches loaded`}
          </p>
        </div>
        <button
          type="button"
          onClick={() => void loadBracket()}
          disabled={isLoading}
          className="inline-flex h-10 items-center cursor-pointer justify-center rounded-md border border-zinc-200 bg-white px-4 text-sm font-semibold text-zinc-700 transition hover:border-zinc-300 hover:bg-zinc-50 disabled:cursor-not-allowed disabled:text-zinc-400"
        >
          {isLoading ? "Loading..." : "Refresh"}
        </button>
      </div>

      <section className="grid gap-4 xl:grid-cols-[minmax(0,1fr)_20rem]">
        <div className="overflow-auto rounded-md border border-zinc-200 bg-slate-50 shadow-sm">
          <canvas
            ref={canvasRef}
            aria-label="Interactive knockout bracket chart"
            role="img"
            onClick={handleCanvasClick}
            onPointerLeave={handlePointerLeave}
            onPointerMove={handlePointerMove}
          />
        </div>

        <aside className="rounded-md border border-zinc-200 bg-white p-4 shadow-sm">
          <div className="flex items-center justify-between gap-3">
            <h2 className="text-lg font-semibold text-zinc-950">
              Match Detail
            </h2>
            <StatusPill tone={selectedStatus.tone}>
              {selectedStatus.label}
            </StatusPill>
          </div>

          {selectedMatch ? (
            <div className="mt-5 grid gap-4 text-sm">
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.12em] text-zinc-500">
                  {selectedRound?.config.label ?? "Knockout"}
                </p>
                <div className="flex w-[30%] my-4">{getMatchLabelWithFlag(selectedMatch, "w-auto")}</div>
                <p className="mt-1 text-zinc-500">
                  {formatDateTime(selectedMatch.match_datetime)}
                </p>
              </div>

              <dl className="grid gap-3">
                <div className="rounded-md bg-zinc-50 px-3 py-2">
                  <dt className="text-xs font-medium text-zinc-500">Score</dt>
                  <dd className="mt-1 font-semibold text-zinc-950 flex">
                    {StatusPill({ children: selectedMatch.team1_score || "-", tone: (selectedMatch?.team1_score || 0) > (selectedMatch?.team2_score || 0) ? "green" : "zinc" })}
                    <span className="mx-2">vs</span>
                    {StatusPill({ children: selectedMatch.team2_score || "-", tone: (selectedMatch?.team2_score || 0) > (selectedMatch?.team1_score || 0) ? "green" : "zinc" })}
                  </dd>
                </div>
                <div className="rounded-md bg-zinc-50 px-3 py-2">
                  <dt className="text-xs font-medium text-zinc-500">Venue</dt>
                  <div className="flex w-[30%] my-4">{MatchVenue(selectedMatch)} </div>
                </div>
                <div className="rounded-md bg-zinc-50 px-3 py-2">
                  <dt className="text-xs font-medium text-zinc-500">Match day</dt>
                  <dd className="mt-1 font-semibold text-zinc-950">
                    {selectedMatch.match_day}
                  </dd>
                </div>
              </dl>
            </div>
          ) : (
            <div className="mt-5 rounded-md bg-zinc-50 px-3 py-8 text-center text-sm text-zinc-500">
              No knockout match selected.
            </div>)}
        </aside>
      </section>
    </div>
  );
}
