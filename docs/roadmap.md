# Platform roadmap

> **Status:** proposed implementation sequence. These milestones are not delivery
> promises, and planned capabilities should not be described as implemented.

## Near-term milestones

| Milestone | Deliverable | Completion evidence |
|---|---|---|
| Development environment | Importable package and CPU MuJoCo Docker workflow | Native/container import checks; current setup stage |
| Free-fall reference example | Small Python API and installed CLI | Analytic checks, timestep convergence and clean package/container execution |
| Suspended-load reference scene | Documented payload, suspension and commands | Equilibrium and swing reference cases; explicit units and frames |
| Disturbance and contact cases | Prescribed wind, landing and fixture interaction | Correct forces/moments, contact records and numerical sensitivity studies |
| Reusable placement scenario | Configurable placement task with observation and metric contracts | Documented assumptions, reset behaviour and successful/unsuccessful reference cases |
| Optional integrations | Unreal observations or robotics middleware adapter | Demonstrated need and verified timing, transforms and reset behaviour |

The first application guides priorities. New users and evidence can change
their order. An image-dependent application may justify an early rendering
feasibility task while the headless reference cases continue.

## Minimum modular structure

Start with a few well-separated functions or modules. Preserve boundaries
between scenario/configuration, backend-specific operations, observations and
measurements, and command-line or integration code. Configuration and results
should not expose native engine handles to callers.

Do not create an empty package for every box in the architecture diagram.
Extract a shared backend interface when working examples establish its
requirements. A plugin registry, universal scene language, service framework
and second engine are not prerequisites for the first supported examples.

## Packaging and deployment foundations

The current environment uses a contributor dependency group named `sim`.
When installable simulation functionality is added, migrate its runtime
dependencies to an optional installation extra and declare directly imported
dependencies explicitly. Update the project metadata, lockfile, Docker, CI and
setup documentation together. Keep development and documentation tools in
their respective groups, and keep top-level package imports lightweight.

Verify an installed wheel outside the repository checkout, as well as native
and container execution. Use a headless CLI with explicit configuration and
reliable failure exits before adding services or orchestration infrastructure.

The Docker image is a development environment, not an accuracy or cross-hardware
reproducibility guarantee. Record the tested image digest, code/assets and
resolved dependencies for reference runs. Add GPU integration jobs only when
there is an implemented integration with a defined check.

## Deferred decisions

Future backends, asset formats and integrations need concrete requirements,
capability declarations and validation. Reassess dependencies when a supported
case exposes a documented limitation. Keep architectural decisions in the
[ADR register](adr/README.md).

Learning exercises and individual study milestones can use this sequence, but
their schedules, methods and results are maintained outside the platform roadmap.
