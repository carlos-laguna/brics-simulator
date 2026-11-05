# BRICS

**Building Robotics Intelligence & Construction Simulator**

An open-source construction robotics simulation project, initially focused on
reusable simulation of suspended-load handling and placement.

> **Status:** Initial development. The development environment supports importing
> BRICS and MuJoCo locally or in Docker. The first reference simulation is next.
> The benchmark, physics adapter interfaces, Unreal and ROS integrations, and BIM
> import described in the documentation are planned, not implemented features.

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

- **MuJoCo first:** develop a small, verified physics example before a complete
  suspended-load task.
- **Bounded backend independence:** keep experiment, command, observation and
  evaluation meanings separate from native engine objects. Preserve explicit
  backend-specific models and solver settings.
- **One physics authority:** one backend owns the interacting world for each
  episode; one runner coordinates all requests to advance simulation time.
- **Optional integrations:** Unreal Engine 5 may supply rendering and sensors;
  ROS 2 may connect robotics systems. Neither owns physics or is required for
  headless reference experiments.
- **Python application layer:** use Python with native simulation libraries, adding
  lower-level components only for a demonstrated need.

This is the proposed direction, not a promise that arbitrary backends or scenes
can be interchanged. Team decisions remain recorded as **Proposed** until review.
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

The reference development environment uses Python 3.12, uv and MuJoCo.
Choose either the native or Docker workflow below.

Run all commands from the repository root.

### Native development

Install [uv](https://docs.astral.sh/uv/getting-started/installation/), then
synchronise the development and simulation dependencies:

```bash
uv sync --locked --python 3.12 --group dev --group sim
```

uv creates the project environment in `.venv` and can download Python 3.12
if needed. Select this environment in your editor.

Check that BRICS and MuJoCo import:

```bash
uv run --locked --python 3.12 --group sim python -c "import brics; import mujoco; print(brics.__file__); print(mujoco.__version__)"
```

Expect a path ending in `src/brics/__init__.py`, followed by the installed
MuJoCo version. The command should exit successfully.

The `sim` dependency group must be requested when setting up simulation
dependencies. It is a contributor dependency group, not a published
`brics[sim]` installation extra.

### Docker development

Install Docker with BuildKit support and the Docker Compose plugin.
A host Python or uv installation is not required for this workflow.

Build the image:

```bash
docker compose build physics-sim-mujoco
```

Run the default import check:

```bash
docker compose run --rm physics-sim-mujoco
```

Expect `/app/src/brics/__init__.py`, followed by the installed MuJoCo version.
The command should exit successfully, and the container is removed afterward.

This is a CPU environment without a viewer or rendering context. The import
check requires no GPU access or display server. It verifies the environment;
it does not launch or validate a BRICS simulation.

The image contains a copy of the repository source from build time.
Rebuild after changing source files, dependencies or Docker configuration.
The current configuration does not mount the source or an output directory
from the host.

### Dependency versions

The setup commands use `--locked` to require agreement between
`pyproject.toml` and `uv.lock`.

If you intentionally change dependencies, update the lockfile with uv,
review the changes and commit both files together.

The lockfile records resolved Python dependencies. Full environment
reproducibility also requires recording the base-image digest and relevant
tool and interpreter versions.

## Development tools

BRICS uses:

- **uv** for dependency and environment management.
- **pytest** for testing.
- **Ruff** for linting and formatting.
- **MkDocs** for documentation.

Run the code-quality checks locally:

```bash
uv run --locked --group dev --group sim ruff check .
uv run --locked --group dev --group sim ruff format --check .
```

Or run them in the rebuilt Docker image:

```bash
docker compose run --rm physics-sim-mujoco ruff check .
docker compose run --rm physics-sim-mujoco ruff format --check .
```

Once tests have been added, run them locally:

```bash
uv run --locked --group dev --group sim pytest
```

Or in Docker:

```bash
docker compose run --rm physics-sim-mujoco pytest
```

An empty test suite is not expected to pass. The import check is the
environment check for the initial setup.

Documentation dependencies are optional. To include them alongside the
development and simulation dependencies:

```bash
uv sync --locked --python 3.12 --group dev --group sim --group docs
```

Build or preview the documentation:

```bash
uv run --locked --group docs mkdocs build --strict
uv run --locked --group docs mkdocs serve
```

The site uses static SVG diagrams and the standard MkDocs theme. No rendering
engine, GPU, additional documentation plugin or external diagram service is
required. Generated `site/` output should remain untracked.

The current Docker image excludes `docs/` and does not install the `docs`
dependency group; use the native workflow for the documentation build.

## Documentation and next steps

- [Documentation overview](docs/index.md)
- [Project scope](docs/project-scope.md)
- [Architecture](docs/architecture.md)
- [Validation and limitations](docs/validation.md)
- [Platform roadmap](docs/roadmap.md)
- [Architecture decision records](docs/adr/README.md)
- [References](docs/references.md)

The next task is a headless free-fall experiment with analytic checks, an
installed CLI and container execution. It deliberately has no suspension,
contact, renderer or robotics middleware. The `sim` group is planned to become
an installation extra when this functionality is implemented; the commands
above describe the current dependency layout.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch conventions, pull requests,
testing guidance and architecture decision records.

The project is at an early stage, and its interfaces may change substantially.

Before starting a substantial change, open an issue describing the problem,
proposed approach and expected behaviour.

Contributions involving external models, datasets or other assets should
include their source and licensing information.
