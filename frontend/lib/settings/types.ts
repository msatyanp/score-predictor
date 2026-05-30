export type SettingResponse = {
  created_at: string;
  id: number;
  name: string;
  friendly_name: string;
  updated_at: string;
  value: string;
};

export type SettingListResponse = {
  items: SettingResponse[];
  limit: number;
  offset: number;
  total: number;
};

export type SettingCreate = {
  name: string;
  friendly_name: string;
  value: string;
};

export type SettingUpdate = Partial<SettingCreate>;

export type ListSettingsParams = {
  limit?: number;
  offset?: number;
  search?: string;
};
