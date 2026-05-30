export type LeaderboardEntryResponse = {
  first_scoring_team_points: number;
  goal_difference_points: number;
  match_duration_points: number;
  name: string;
  kick_off_team_points: number;
  predicted_matches: number;
  rank: number;
  red_card_points: number;
  score_points: number;
  scored_in_first_half_points: number;
  total_points: number;
  user_id: number;
  yellow_card_points: number;
};

export type LeaderboardRaceUserResponse = {
  match_points: number;
  name: string;
  rank: number;
  total_points: number;
  user_id: number;
};

export type LeaderboardRaceFrameResponse = {
  frame: number;
  label: string;
  match_day: number | null;
  match_id: number | null;
  standings: LeaderboardRaceUserResponse[];
};

export type LeaderboardResponse = {
  completed_matches: number;
  items: LeaderboardEntryResponse[];
  limit: number;
  offset: number;
  race_frames: LeaderboardRaceFrameResponse[];
  total: number;
};

export type ListLeaderboardParams = {
  limit?: number;
  offset?: number;
};
