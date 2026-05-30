import { BracketCanvas } from "@/components/brackets/bracket-canvas";
import { PageShell } from "@/components/ui/page-shell";

const BracketsPage = () => {
  return (
    <PageShell
      eyebrow="Brackets"
      subtitle="Knockout paths from the round of 32 through the final."
      title="Tournament Bracket"
    >
      <BracketCanvas />
    </PageShell>
  );
};

export default BracketsPage;
