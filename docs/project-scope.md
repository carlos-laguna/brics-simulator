# Project scope

> **Status:** proposed platform scope. The development environment is established;
> the simulation capabilities and integrations below remain planned.

## Purpose

BRICS is an open-source platform for construction robotics simulation. It should
support reusable physical models, scenarios, observations and evaluation tools
for researchers and developers working on different controllers and learning
systems.

Build this platform through concrete supported use cases. Generality should
follow demonstrated reuse and tests, rather than a promise to simulate every
construction process from the beginning.

## First reference use case

The first use case is handling and placing a suspended rigid load under wind
disturbances and imperfect sensing. The SwingRL paper task
provides initial requirements and candidate assets. It informs the simulator's
scope without prescribing the architecture of systems that use it.

Initial requirements include configurable payload and suspension properties,
documented actuation, controlled disturbances, placement contact, timestamped
observations, and measurements of approach speed, swing and contact events.
These are intended capabilities, not current implementation claims.

Start with a small family of configurations that can be modelled and verified
credibly. Record missing rig parameters as assumptions. A model inspired by the
rig described in SwingRL is not automatically a calibrated digital twin.

## Initial scope and deferred capabilities

| Build first | Defer until justified by a supported use case |
|---|---|
| One physics backend and small reference cases | Several interchangeable backends |
| Rigid payload, suspension and receiving fixtures | Arbitrary crane types, winches, sheaves and reeving |
| Controlled wind forces and moments | Full fluid simulation and automatic shielding prediction |
| State observations with explicit timing, noise and loss | Complete photorealistic sensor pipelines |
| A few inspected collision geometries | General BIM and point-cloud import pipelines |
| Local headless execution and run records | Distributed services, cluster scheduling and exact checkpoints |

Mixed-engine dynamics within one interacting world are outside the initial
architecture. Unreal rendering and ROS integration remain optional extensions.
Excavation, deformable materials and broader construction workflows remain
longer-term possibilities; their models need separate evidence of validity.

## Relationship to research projects

Research projects can set concrete requirements and contribute reusable
capabilities. BRICS owns the simulator contract: what is simulated, how inputs
are applied, what observations and measurements mean, and which limitations
affect interpretation.

Keep thesis hypotheses, novelty arguments, model architectures, training
objectives, ablation plans, study-specific splits and paper results in the
research project's own documentation. Research code should depend on a recorded
BRICS release or commit. BRICS must not depend on that research code.

Reusable example controllers and versioned benchmark protocols can belong in
BRICS when the project explicitly takes responsibility for maintaining them.
A benchmark can specify contact metrics, scenario sets and scoring rules; the
individual study decides which methods to compare and what conclusions follow.
Version a frozen benchmark instead of changing it to favour an active study.

For example, BRICS can define relative approach speed at a contact point and
record a collision event. A research project can train a model to predict those
quantities and test whether its decisions improve placement outcomes.

## Criteria for adding capabilities

Before promoting an experiment into supported BRICS functionality, establish:

- A concrete user need and a clear, reusable input/output contract.
- A documented model, operating range, assumptions and failure behaviour.
- Appropriate reference cases, tests and numerical sensitivity checks.
- Asset/dependency provenance and distribution conditions.
- A maintainer and a proportionate support burden.

Avoid hard-coding the first user's observation vector, reward function, world
model or fixture into the core. Equally, avoid adding an abstract subsystem with
no working use case. Preserve clear boundaries while implementing a small,
complete example first.

The [architecture](architecture.md) defines those boundaries. The
[validation guide](validation.md) defines evidence for supported models and
measurements. The [roadmap](roadmap.md) identifies the next platform milestones.
