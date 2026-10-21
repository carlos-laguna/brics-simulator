# BRICS

**Building Robotics Intelligence & Construction Simulator**

An open-source platform for construction robotics simulation, with physics-based environments and BIM integration.

> **Status:** Initial development. BRICS is currently establishing its package structure and development workflow. Simulation functionality is not yet available.

## Vision

BRICS aims to help researchers and developers build, test and evaluate robots operating in construction environments.

The platform will build on existing simulation technologies and add construction-specific assets, scenarios, physical models and evaluation tools. The goal is to connect industry data with reproducible robotics experiments.

## Planned capabilities

- **Construction tasks:** Scenarios for component handling, assembly, lifting and earthmoving.
- **Domain-relevant physics:** Rigid-body interactions, wind loading and, progressively, deformable terrain and material behaviour.
- **Perception:** Photorealistic environments and simulated sensor observations.
- **Industry data:** Import pipelines for BIM, point clouds and other construction assets, preserving relevant metadata and coordinate information.
- **Experimentation:** Configurable scenarios, recorded observations and actions, and task-specific evaluation metrics.
- **Extensibility:** Modular components that allow new tasks, assets and simulation integrations to be added.

These are development goals, not currently supported features.

## Development principles

- Build small, complete examples before expanding the platform.
- Reuse established simulation tools where appropriate.
- Keep construction-domain logic separate from simulator-specific implementation.
- Document physical assumptions and validate behaviour against suitable reference cases.
- Record configuration, dependency and asset versions to support reproducible experiments.
- Keep installation, testing and contribution workflows straightforward.

## Getting started

Development currently uses Python 3.12 and [uv](https://docs.astral.sh/uv/).

From the repository root, install the development and documentation dependencies:

```bash
uv sync --group dev --group docs
```

Check that the package imports:

```bash
uv run python -c "import brics; print(brics.__file__)"
```

This checks the package installation; it does not launch a simulation.

## Development tools

BRICS uses:

- **uv** for dependency and environment management.
- **pytest** for testing.
- **Ruff** for linting and formatting.
- **MkDocs** for documentation.

Run the code-quality checks with:

```bash
uv run ruff check .
uv run ruff format --check .
```

Run tests as they are added:

```bash
uv run pytest
```

## Contributing

The project is at an early stage, and its interfaces may change substantially.

Before starting a substantial change, open an issue describing the problem, proposed approach and expected behaviour. Keep pull requests focused, include appropriate tests, and document any new physical assumptions or dependencies.

Contributions involving external models, datasets or other assets should include their source and licensing information.