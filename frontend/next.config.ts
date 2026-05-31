import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  images: {
    remotePatterns: [
      {
        hostname: "api.fifa.com",
        protocol: "https",
      },
    ],
  },
};

export default nextConfig;
