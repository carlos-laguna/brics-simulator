# Architecture decision records

ADRs record the reasons and trade-offs behind significant technical choices.
The [architecture guide](../architecture.md) describes the resulting design;
the [project scope](../project-scope.md) defines the problem it should serve.

## Register

All four entries below are **Proposed**, pending discussion with the team.

| Record | Proposal | Status |
|---|---|---|
| [001](001-mujoco-and-bounded-backend-portability.md) | Start with MuJoCo and bounded backend portability | Proposed |
| [002](002-single-physics-authority.md) | Give one backend ownership of coupled physics and one runner ownership of advancement | Proposed |
| [003](003-optional-rendering-and-middleware.md) | Keep Unreal rendering and robotics middleware optional | Proposed |
| [004](004-python-application-layer.md) | Use Python for the application layer and native libraries for simulation | Proposed |

## Lifecycle

Use the [short template](template.md). Number new records using the next unused
three-digit identifier. Do not reuse an identifier or renumber existing records
to make a newly added set consecutive.

Discuss proposals with the team before marking them **Accepted**. A proposal can
also become **Rejected** or **Deferred**. Add a dated outcome and a link to the
issue, pull request or meeting note that records the discussion.

Preserve an accepted decision when replacing it: mark it **Superseded** and link
both records. Correct small factual mistakes in place; use a new ADR for a
substantive reversal. Keep records concise and link detailed design and evidence.

Routine conventions belong in CONTRIBUTING.md. New implementation details do
not each need an ADR. Changes to physics ownership, portability promises,
required proprietary dependencies or the application implementation language do.
