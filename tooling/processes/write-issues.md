# GitHub Issue Creation

## Approach

Using business driven development best practices:

- Explicitly outcome- and value-oriented.
- Focuses on why the capability matters to the business and what behavior is required.
- Designed to align delivery with measurable business outcomes.
- Still uses the user story template, but the business benefit is explicit and testable.
- Acceptance criteria are written as behavioral scenarios.
- Scenarios describe observable system behavior from a stakeholder perspective.
- Acceptance criteria:
  - Define executable specifications
  - Are unambiguous and shared by business, QA, and engineering

## 1. The Essentials (Apply to All)

- [ ] **Actionable Title:** Use a "Type: Description" format (e.g.,
      `Fix: Login button alignment` or `Feat: Add dark mode toggle`).
- [ ] **The "Why":** Briefly explain the value of this issue. Who does it help
      and why is it necessary now?
- [ ] **Clear Description:** A 2–3 sentence overview of the task or problem.
- [ ] **Cross-Links:** Link to related issues or previous Pull Requests using `#issue-number`.

## 2. For Bug Reports (The "Evidence")

- [ ] **Reproduction Steps:** Provide a numbered list of exactly how to trigger
      the bug.
- [ ] **Expected vs. Actual:** Clearly state what _should_ have happened versus
      what _did_ happen.
- [ ] **Visual Aids:** Include screenshots, GIFs, or video recordings.
- [ ] **Environment Info:** List the OS, browser version, and branch/environment
      (e.g., `staging` vs `production`).
- [ ] **Logs/Traces:** Paste relevant error logs or stack traces inside code
      blocks (```).

## 3. For Feature Requests (The "Blueprint")

- [ ] **User Story:** Use the format: "As a [user type], I want to [action], so
      that [benefit]."
- [ ] **Acceptance Criteria:** A checklist of "Definition of Done" (e.g., "Must
      support mobile view," "Must include unit tests").
- [ ] **Implementation Suggestions:** Optional technical notes on which
      components or API endpoints might be affected.
- [ ] **Design Assets:** Link to Figma files, wireframes, or UI mockups.

## 4. Final Polish

- [ ] **Scannability:** Use **bolding** for emphasis and bullet points for lists.

---

> The Golden Rule: If a developer who has never seen this project before can't
> understand the goal within 60 seconds, the issue needs more clarity.
