import { ApiError } from "@/lib/api";
import { MissingAuthTokenError } from "@/lib/auth";

export const getErrorMessage = (error: unknown, fallback: string): string => {
  if (error instanceof MissingAuthTokenError) {
    return "Please log in before continuing.";
  }

  if (error instanceof ApiError) {
    return error.message;
  }

  if (error instanceof Error && error.message.trim()) {
    return error.message;
  }

  return fallback;
};
