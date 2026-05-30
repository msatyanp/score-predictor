export {
  createMatch,
  deleteMatch,
  listAdminMatches,
  listMatches,
  listUpcomingMatches,
  matchService,
  updateMatch,
} from "@/lib/matches/match-service";
export { match_durations, match_stages } from "@/lib/matches/types";
export type {
  GameDuration,
  MatchStage,
  ListMatchesParams,
  ListUpcomingMatchesParams,
  MatchCreate,
  MatchFields,
  MatchListResponse,
  MatchResponse,
  MatchUpdate,
} from "@/lib/matches/types";
