import { authenticatedApiFetch } from "@/lib/auth";
import type {
  ListCurrentUserPredictionsParams,
  PredictionCreate,
  PredictionListResponse,
  PredictionResponse,
  PredictionUpdate,
} from "@/lib/predictions/types";

const toQueryString = (params: ListCurrentUserPredictionsParams): string => {
  const searchParams = new URLSearchParams();

  if (params.offset !== undefined) {
    searchParams.set("offset", String(params.offset));
  }

  if (params.limit !== undefined) {
    searchParams.set("limit", String(params.limit));
  }

  if (params.matchId !== undefined) {
    searchParams.set("match_id", String(params.matchId));
  }

  return searchParams.toString();
};

export const listCurrentUserPredictions = async (
  params: ListCurrentUserPredictionsParams = {},
): Promise<PredictionListResponse> => {
  const queryString = toQueryString(params);
  const path = queryString ? `/predictions/me?${queryString}` : "/predictions/me";

  return authenticatedApiFetch<PredictionListResponse>(path, {
    method: "GET",
  });
};

export const createPrediction = async (
  data: PredictionCreate,
): Promise<PredictionResponse> => {
  return authenticatedApiFetch<PredictionResponse, PredictionCreate>(
    "/predictions",
    {
      body: data,
      method: "POST",
    },
  );
};

export const updatePrediction = async (
  predictionId: number,
  data: PredictionUpdate,
): Promise<PredictionResponse> => {
  return authenticatedApiFetch<PredictionResponse, PredictionUpdate>(
    `/predictions/${predictionId}`,
    {
      body: data,
      method: "PUT",
    },
  );
};

export const predictionService = {
  createPrediction,
  listCurrentUserPredictions,
  updatePrediction,
};
