# BRICS documentation

BRICS means **Building Robotics Intelligence & Construction Simulator**.
It is an open-source construction robotics project, currently focused on
simulation of suspended-load handling and placement.

> **Implementation status:** The package and CPU MuJoCo development environment
> are established. The architecture, reference scenarios, integrations and
> evaluation workflows described here are planned. A free-fall reference example
> is the next implementation task. These pages do not announce a completed simulator.

## Read in this order

| Page | Question it answers |
|---|---|
| [Project scope](project-scope.md) | What does the platform serve first, and how can its scope grow? |
| [Architecture](architecture.md) | Who owns physics, time, observations and integration boundaries? |
| [Validation and limitations](validation.md) | What evidence supports a result, and what can the simulator not establish? |
| [Platform roadmap](roadmap.md) | What should we build next, and what must wait? |
| [Proposed ADRs](adr/README.md) | Which choices require team discussion, and why are they proposed? |
| [References](references.md) | Which external documents and research informed this plan? |

The repository README owns installation instructions. CONTRIBUTING.md owns the
contribution workflow. This documentation describes the platform scope and technical
design without duplicating their setup commands.

## How to interpret these pages

- **Implemented** requires code and relevant checks. Documentation alone is not
  evidence that a capability exists.
- **Planned** describes the current intended implementation, subject to review.
- **Proposed** is the status of a decision awaiting the team's agreement.
- **Deferred** means deliberately outside the immediate implementation scope.

Accepting an ADR records agreement with a direction; it does not change the
implementation status of that direction. Update status statements when the
corresponding implementation is merged and verified.
