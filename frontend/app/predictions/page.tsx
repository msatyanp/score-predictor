import { PredictionsDashboard } from "@/components/predictions/predictions-dashboard";
import { PageShell } from "@/components/ui/page-shell";

const PredictionsPage = () => {
  return (
    <PageShell
      eyebrow="Predictions"
      subtitle="Submit scores, cards, kickoff team, and game duration before the lock window closes."
      title="Prediction Board"
    >
      <PredictionsDashboard />
    </PageShell>
  );
};

export default PredictionsPage;
