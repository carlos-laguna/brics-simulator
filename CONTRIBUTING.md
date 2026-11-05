# Contributing to BRICS

Follow the [Getting started instructions](README.md#getting-started) to set up
your environment. Keep contributions focused and discuss substantial changes
in an issue before implementation.

## Branches and pull requests

Create short-lived branches from an up-to-date `main`. Use lowercase names
with hyphen-separated words:

| Prefix | Purpose | Example |
|---|---|---|
| `feat/` | New functionality | `feat/free-fall-example` |
| `fix/` | Bug fixes | `fix/incorrect-gravity-direction` |
| `docs/` | Documentation changes | `docs/simulation-setup` |
| `chore/` | Tooling and maintenance | `chore/editor-setup` |
| `refactor/` | Restructuring without changing behaviour | `refactor/result-recording` |
| `experiment/` | Time-limited feasibility investigations | `experiment/rigid-body-backend` |

Keep each pull request focused on one purpose. Explain the change, why it is
needed and how it was verified. Include relevant documentation updates and
link associated issues or architecture decision records.

All required checks must pass before merging.

Squash-merge completed pull requests and delete their branches.
Commit messages should describe the change clearly; Conventional Commits
are not required.

## Testing and development

Use test-driven development for well-defined application behaviour:

1. Define the expected behaviour and relevant edge cases.
2. Write a small test and confirm that it fails for the expected reason.
3. Implement the simplest maintainable solution that passes.
4. Refactor while keeping the tests passing.

Test observable behaviour rather than private implementation details.
For bug fixes, add a regression test that demonstrates the defect where
practical.

Short exploratory scripts are acceptable when investigating unfamiliar
simulator APIs or uncertain physical behaviour. Before incorporating the
result into supported functionality, define its contract and add appropriate
automated checks.

Keep unit tests for simulator-independent logic free of simulator and GPU
requirements. Separate simulator integration tests and document their
environment requirements. Tests of simulated physics should exercise the
actual physics engine.

For numerical and physics checks, document the reference result, physical
assumptions, units and tolerance. Use analytic solutions, conservation laws
or independently established reference cases where appropriate.
Do not treat visually plausible output as sufficient validation.

Run relevant checks locally before opening a pull request. Submit tests
and implementation together with passing checks.

Use proportionate checks for tooling and documentation changes.
Do not add placeholder tests just to make an empty test suite pass.

## Dependencies and development environment

Use uv to manage dependencies. Commit `pyproject.toml` and `uv.lock`
together when dependencies change, and do not edit the lockfile manually.

The reference development environment uses Python 3.12. Keep
`.python-version`, Docker configuration and CI consistent with the
interpreter versions the project tests.

The `dev` group contains development tools, `sim` contains simulation
dependencies, and `docs` contains documentation tools.

Keep the [setup instructions](README.md#getting-started) up to date when
changing these groups or the development workflow.

For Docker changes, check the Compose configuration, build the image and
run its import check:

```bash
docker compose config --quiet
docker compose build physics-sim-mujoco
docker compose run --rm -T physics-sim-mujoco
```

A successful build alone does not verify the image's runtime command.
Keep both build and runtime checks in CI.

Base-image updates should be deliberate. For recorded research baselines,
pin the tested image digest and record relevant environment versions.

Keep generated outputs, virtual environments, caches and local environment
files out of version control. Store generated experiment results under
`outputs/`.

Shared editor settings may be committed in `.vscode/`; keep machine-specific
paths and personal preferences out of those shared files.

## Architecture decision records

Record significant technical decisions in `docs/adr/`, using the
[ADR template](docs/adr/template.md). Routine implementation details
do not need an ADR.

Use the [ADR register](docs/adr/README.md) to find related proposals before
adding a new one. Significant changes to physics ownership, required runtimes,
backend portability promises or research language belong in an ADR. Keep
branch names, formatting conventions and ordinary tooling instructions here.

Name records `NNN-short-title.md`, using the next unused number from `001`.
Never reuse or overwrite an existing numbered record. New records begin
as **Proposed** and are discussed with the team before becoming **Accepted**.
Proposals may also be **Rejected** or **Deferred**.

When an accepted decision is replaced, preserve it as **Superseded** and link
to the new record. Link relevant ADRs from implementation pull requests.

Accepting a proposal records agreement; it does not mean the capability has
been implemented. Update the [architecture guide](docs/architecture.md) when
an agreed design changes, and update the README's capability status only when
the corresponding implementation and checks exist.

## Documentation

The README explains project status and setup. Detailed research scope,
architecture and limitations belong in `docs/`. ADRs explain why significant
directions were chosen; avoid copying entire design guides into each record.

For a new physical model or supported scenario, document:

- Model assumptions, operating range, missing mechanisms and parameter sources.
- Units, frames, command semantics, observation access and simulation timing.
- Reference cases, tolerance rationale and relevant numerical sensitivity.
- Metrics, success/failure definitions and any uncalibrated quantities.
- Asset provenance, modifications and redistribution conditions.

Label future work as planned. Document a deliberate approximation explicitly;
do not imply that a capability exists because an upstream engine supports it.

Install the `docs` group as described in the README, then run:

```bash
uv run --locked --group docs mkdocs build --strict
```

Preview substantive edits with `uv run --locked --group docs mkdocs serve`.
Check links, tables and diagrams. Keep generated `site/` output untracked.
The site displays committed SVG diagrams; their editable Graphviz source is
stored beside them. Diagram editing instructions are in the architecture guide.

## Research comparisons

Follow the [validation and evaluation policy](docs/validation.md). Keep a clear
separation between policy observations, privileged training targets and evaluator
truth. Compare methods under declared observation and action authority, with
explicit train/validation/test splits and scenario provenance.

Record numerical failures and unsuccessful episodes. Do not present simulated
improvements as demonstrated real-world safety. Distinguish reproduction of
SwingRL from extensions to its task, model or available actions.

## External assets and data

For models, datasets, textures or other external assets, document their source,
licence and any modifications. Check that redistribution is permitted before
adding assets to the repository.

Keep original source assets distinguishable from derived simulation assets,
and document relevant unit and coordinate-system conversions.
