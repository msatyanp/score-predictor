import { LeaderboardDashboard } from "@/components/leaderboard/leaderboard-dashboard";
import { PageShell } from "@/components/ui/page-shell";

const LeaderboardPage = () => {
  return (
    <PageShell
      eyebrow="Leaderboard"
      subtitle="Rankings combine exact scores, goal difference, duration, kickoff team, and card predictions."
      title="Tournament Rankings"
    >
      <LeaderboardDashboard />
    </PageShell>
  );
};

export default LeaderboardPage;
