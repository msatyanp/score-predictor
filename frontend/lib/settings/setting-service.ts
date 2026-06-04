import { apiFetch } from "@/lib/api";
import { authenticatedApiFetch } from "@/lib/auth";
import type {
  ListSettingsParams,
  SettingCreate,
  SettingListResponse,
  SettingResponse,
  SettingUpdate,
  GameRulesResponse,
} from "@/lib/settings/types";

const toQueryString = (params: ListSettingsParams): string => {
  const searchParams = new URLSearchParams();

  if (params.offset !== undefined) {
    searchParams.set("offset", String(params.offset));
  }

  if (params.limit !== undefined) {
    searchParams.set("limit", String(params.limit));
  }

  if (params.search !== undefined) {
    searchParams.set("search", params.search);
  }

  return searchParams.toString();
};

export const listSetting = async (
  params: ListSettingsParams = {},
): Promise<SettingListResponse> => {
  const queryString = toQueryString(params);
  const path = queryString ? `/admin/settings?${queryString}` : "/admin/settings";

  return authenticatedApiFetch<SettingListResponse>(path, {
    method: "GET",
  });
};

export const listRules = async (
  params: ListSettingsParams = {},
): Promise<GameRulesResponse> => {
  const queryString = toQueryString(params);
  const path = queryString ? `/rules?${queryString}` : "/rules";

  return apiFetch<GameRulesResponse>(path, {
    method: "GET",
  });
};

export const createSetting = async (data: SettingCreate): Promise<SettingResponse> => {
  return authenticatedApiFetch<SettingResponse, SettingCreate>("/admin/settings", {
    body: data,
    method: "POST",
  });
};

export const updateSetting = async (
  settingId: number,
  data: SettingUpdate,
): Promise<SettingResponse> => {
  return authenticatedApiFetch<SettingResponse, SettingUpdate>(
    `/admin/settings/${settingId}`,
    {
      body: data,
      method: "PUT",
    },
  );
};

export const deleteSetting = async (settingId: number): Promise<void> => {
  await authenticatedApiFetch<null>(`/admin/settings/${settingId}`, {
    method: "DELETE",
  });
};

export const listSettings = async (): Promise<SettingListResponse> => {
  return apiFetch<SettingListResponse>("/settings", {
    method: "GET",
  });
};

export const settingService = {
  createSetting,
  deleteSetting,
  listSetting,
  listSettings,
  updateSetting,
};
