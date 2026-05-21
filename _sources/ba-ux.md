# BA/UX Designer Process

> Source material. Off-framework vocabulary intentional — see `_sources/README.md`. Do not reconcile against `_registry.md`.

Detailed tasks and phases for the BA/UX Designer role.

---

## 1. Discovery & Research

- Understand business goals and product vision
- Identify target users and create user personas
- Conduct stakeholder interviews to gather requirements
- Audit competitor products and industry patterns
- Define success metrics and KPIs for the UI

## 2. Requirements & Information Architecture

- List functional requirements and user needs
- Define the content structure and page hierarchy
- Map out navigation model and route structure
- Establish naming conventions and taxonomy
- Prioritize features for MVP / phased delivery

## 3. User Flows & Task Analysis

- Map end-to-end user journeys for each persona
- Identify the primary happy path and critical alternate paths
- Document error and edge-case scenarios
- Define entry points, decision points, and exit points
- Validate flows against business requirements

## 4. Wireframing

- Sketch low-fidelity wireframes for each screen
- Define layout structure, content zones, and component placement
- Design key interaction states (empty, loading, error, success)
- Annotate wireframes with behavior notes
- Review wireframes with stakeholders and iterate

## 5. Design System & Visual Design

- Establish (or adopt) a design system: colors, typography, spacing, icons
- Define reusable component library (buttons, inputs, cards, modals, etc.)
- Create high-fidelity mockups from approved wireframes
- Ensure visual consistency across all screens
- Apply branding guidelines

## 6. Interaction & Micro-interaction Design

- Define transitions, animations, and feedback patterns
- Specify form validation behavior and inline error display
- Design notification and toast patterns
- Plan keyboard shortcuts and focus management
- Document hover, active, disabled, and focus states for interactive elements

## 7. Responsive & Adaptive Design

- Define breakpoints and supported viewport sizes
- Adapt layouts for desktop, tablet, and mobile
- Decide which features degrade or hide on smaller screens
- Test touch targets and spacing for mobile usability

## 8. Prototyping & User Testing

- Build interactive prototypes from high-fidelity designs
- Conduct usability testing sessions with representative users
- Gather qualitative feedback and measure task completion rates
- Identify usability issues and pain points
- Iterate on designs based on testing findings

## 9. Accessibility Review

- Ensure color contrast meets WCAG standards
- Add ARIA labels and roles to interactive elements
- Verify keyboard navigability for all flows
- Test with screen readers
- Document accessibility requirements for developers

## 10. Design Handoff & Developer Collaboration

Design docs in `modules/<name>/design/` are the handoff artifact — no separate export needed.

- Write `user-flows.md` and `wireframes.md` to `modules/<name>/design/` before the implementation plan is broken into subtasks (they are read by the frontend-engineer agent at dispatch time)
- Write visual specs and interaction states directly into the relevant design doc — not as a separate file
- Use `/update-design` to update design docs if requirements change mid-plan; add `delta.md` to explain the change
- Review frontend-engineer output against design docs; log discrepancies as new subtasks rather than editing frozen ones

## 11. QA & Iteration

- Conduct visual QA against approved designs
- Verify interaction states and responsive behavior in-browser
- Log UI defects and prioritize fixes
- Collect post-launch user feedback
- Plan iterative improvements for the next cycle
