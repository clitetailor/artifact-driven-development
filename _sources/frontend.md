# Frontend Engineer Process

> Source material. Off-framework vocabulary intentional — see `_sources/README.md`. Do not reconcile against `_registry.md`.

Detailed tasks and phases for the Frontend Engineer role.

---

## 1. Discovery & Research (Support)

- Review product vision and business goals
- Understand target user needs and personas
- Identify technical constraints and opportunities
- Research frontend technology options if needed

## 2. Requirements & Architecture (Collaborate)

- Review functional requirements with BA/UX
- Propose frontend architecture and tech stack
- Identify component structure and state management needs
- Estimate implementation effort for features
- Flag technical risks or dependencies

## 3. User Flows & Task Analysis (Review)

- Review user flows for technical feasibility
- Identify complex interactions requiring special handling
- Suggest optimizations for performance-critical paths
- Note data requirements for each flow

## 4. Wireframing (Review)

- Review wireframes for implementation clarity
- Ask clarifying questions on interaction behavior
- Identify reusable component patterns
- Flag potential accessibility concerns early

## 5. Design System & Component Development

- Implement design system tokens (colors, typography, spacing)
- Build reusable component library
- Ensure components match design specs
- Document component APIs and usage
- Set up Storybook or similar for component showcase

## 6. API Integration Planning

- Review API contracts with Backend
- Define data fetching strategy (REST, GraphQL, etc.)
- Plan state management for server data
- Agree on error handling conventions
- Set up API client and type definitions

## 7. Implementation

- Implement screens and features per wireframes
- Integrate with backend APIs
- Handle loading, error, and empty states
- Implement form validation and user feedback
- Ensure responsive behavior across breakpoints

## 8. Testing & QA

- Write unit tests for components and utilities
- Write integration tests for critical flows
- Perform cross-browser testing
- Test responsive behavior on real devices
- Fix bugs identified during QA

## 9. Performance Optimization

- Optimize bundle size and code splitting
- Implement lazy loading for routes and components
- Optimize images and assets
- Monitor and improve Core Web Vitals
- Profile and fix performance bottlenecks

## 10. Accessibility Implementation

- Implement ARIA labels and roles
- Ensure keyboard navigability
- Test with screen readers
- Fix accessibility issues from audits

## 11. Deployment & Iteration

- Prepare build for production deployment
- Support deployment process
- Monitor frontend errors post-launch
- Iterate based on user feedback and analytics
