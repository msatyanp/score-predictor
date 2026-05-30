import { apiFetch } from "@/lib/api";
import type { GroupTableListResponse } from "@/lib/groups/types";

export const listGroupTables = async (): Promise<GroupTableListResponse> => {
  return apiFetch<GroupTableListResponse>("/teams/groups", {
    method: "GET",
  });
};

export const groupService = {
  listGroupTables,
};
