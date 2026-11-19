# BRICS

**Building Robotics Intelligence & Construction Simulator**

An open-source construction robotics simulation project, initially focused on
reusable simulation of suspended-load handling and placement.

BRICS was initiated by Carlos Laguna Sanchez during his MPhil research at the University
of Cambridge.

> **Status:** The BRICS Python package is importable. The first simulation task is
> planned for Isaac Lab 3.0 with Newton physics.

## Vision

BRICS aims to help researchers and developers build, test and evaluate robots
operating in construction environments.

The platform will build on existing simulation technologies and add
construction-specific assets, scenarios, physical models and evaluation tools.
The goal is to connect industry data with reproducible robotics experiments.

## First reference use case

The initial use case is suspended-load handling and placement under wind
disturbances and imperfect sensing. The group's physical rig and SwingRL task
provide initial requirements and candidate assets. BRICS aims to provide
reusable scenarios, observations and measurements for different controllers
and learning systems.

Research projects can guide requirements and contribute reusable capabilities.
Their hypotheses, model architectures and study results are maintained
separately. BRICS does not depend on any individual thesis or trained model.

See [project scope](docs/project-scope.md) for the initial operating scope,
deferred capabilities and the boundary between platform and research work.

## Intended architecture

- **Kit-less Isaac Lab with Newton first:** develop a small, verified physics example
  before a complete
  suspended-load task.
- **Bounded backend independence:** keep experiment, command, observation and
  evaluation meanings separate from native engine objects. Preserve explicit
  backend-specific models and solver settings.
- **One physics authority:** one backend owns the interacting world for each
  episode; one runner coordinates all requests to advance simulation time.
- **Task-specific sensors:** add full Isaac Sim for RTX LiDAR or ROS 2.
- **Python application layer:** use Python with native simulation libraries, adding
  lower-level components only for a demonstrated need.

The platform choice is recorded in [ADR 005](docs/adr/005-isaac-lab-and-newton.md).
Read the [architecture guide](docs/architecture.md),
[validation and limitations](docs/validation.md) and
[ADR register](docs/adr/README.md).

## Longer-term vision

- **Construction tasks:** Scenarios for component handling, assembly, lifting
  and earthmoving.
- **Domain-relevant physics:** Rigid-body interactions, wind loading and,
  progressively, deformable terrain and material behaviour.
- **Perception:** Photorealistic environments and simulated sensor observations.
- **Industry data:** Import pipelines for BIM, point clouds and other construction
  assets, preserving relevant metadata and coordinate information.
- **Experimentation:** Configurable scenarios, recorded observations and actions,
  and task-specific evaluation metrics.
- **Extensibility:** Modular components that allow new tasks, assets and simulation
  integrations to be added.

These are longer-term development goals, not currently supported features or
commitments for the first platform milestone. In particular, excavation, broad
BIM/point-cloud ingestion, arbitrary crane mechanisms and multiple interacting
physics engines are outside the immediate scope.

## Development principles

- Build small, complete examples before expanding the platform.
- Reuse established simulation tools where appropriate.
- Keep construction-domain logic separate from simulator-specific implementation.
- Document physical assumptions and validate behaviour against suitable
  reference cases.
- Record configuration, dependency and asset versions to support reproducible
  experiments.
- Keep installation, testing and contribution workflows straightforward.

## Getting started

Use Python 3.12 and uv for package and documentation work.

```bash
uv sync --locked --python 3.12 --group dev --group docs
uv run --no-sync python -c "import brics; print(brics.__file__)"
uv run --no-sync ruff check .
uv run --no-sync ruff format --check .
uv run --no-sync mkdocs build --strict
```

For the same package import check in Docker, run
`docker compose run --build --rm brics-dev`.
The simulator integration is planned. The first GPU milestone will establish
a tested kit-less environment and record the compatible driver, Python,
Isaac Lab and Newton versions.

For local GPU work, use NVIDIA's kit-less Isaac Lab container. Each lab obtains the
image directly from NVIDIA and mounts its BRICS checkout and results directory.
The BRICS development image serves the CPU package checks. When the first GPU task
passes, document its launch command and the upstream image digest alongside it.
See [NVIDIA's container setup](https://docs.nvidia.com/isaaclab/3.0/isaac-lab/installation)
and the [Isaac Sim licence FAQ](https://docs.isaacsim.omniverse.nvidia.com/6.2.0/common/license-faq.html).

## Documentation and next steps

- [Documentation overview](docs/index.md)
- [Project scope](docs/project-scope.md)
- [Architecture](docs/architecture.md)
- [Validation and limitations](docs/validation.md)
- [Platform roadmap](docs/roadmap.md)
- [Architecture decision records](docs/adr/README.md)
- [References](docs/references.md)

The next task is a headless free-fall experiment with analytic checks and an installed
CLI.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch conventions, pull requests,
testing guidance and architecture decision records.

The project is at an early stage, and its interfaces may change substantially.

Before starting a substantial change, open an issue describing the problem,
proposed approach and expected behaviour.

## Licence

Original BRICS code and documentation use [Apache License 2.0](LICENSE)
(`Apache-2.0`). Third-party software and assets retain their respective licences.
Users install Isaac software separately. See the
[distribution guidance](docs/adr/platform-decision-brief.md#who-pays-in-practice).
BRICS's licence does not grant rights to that third-party material.
The documentation site's [licence bundle](docs/assets/licenses.txt) accompanies
its generated assets.
