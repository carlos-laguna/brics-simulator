# BRICS

**Building Robotics Intelligence & Construction Simulator**

An open-source project for construction robotics simulation.

> **Status:** Initial development. The development environment supports importing
> BRICS and MuJoCo locally or in Docker. BRICS simulation scenarios and BIM
> integration are not yet implemented.

## Vision

BRICS aims to help researchers and developers build, test and evaluate robots
operating in construction environments.

The platform will build on existing simulation technologies and add
construction-specific assets, scenarios, physical models and evaluation tools.
The goal is to connect industry data with reproducible robotics experiments.

## Planned capabilities

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

These are development goals, not currently supported features.

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

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch conventions, pull requests,
testing guidance and architecture decision records.

The project is at an early stage, and its interfaces may change substantially.

Before starting a substantial change, open an issue describing the problem,
proposed approach and expected behaviour.

Contributions involving external models, datasets or other assets should
include their source and licensing information.
