# 004: Use Python for the application layer

- **Status:** Proposed
- **Date:** 11-05-2026

## Context

BRICS needs an accessible development interface for scenario configuration,
simulation control, data collection and evaluation. The existing package and
tooling use Python, and the first backend exposes native Python bindings.
Supporting contributors and integrations matters alongside runtime performance.

## Proposal

Use typed Python for configuration, orchestration, observations, measurements,
recording and command-line entry points. Delegate dynamics to the native
simulator through its supported bindings. Keep external controllers and learning
systems behind documented data interfaces rather than selecting a required
learning framework for the platform core.

Keep uv, pytest, Ruff and MkDocs, with the tested Python 3.12 development
environment initially. Add dependencies for implemented capabilities. Profile
representative workloads before proposing a native extension, and keep any
such extension narrow and behaviourally tested.

## Alternatives considered

- **Rust throughout:** useful language guarantees, with additional binding,
  contributor-onboarding and integration work before meeting current needs.
- **C++ throughout:** closer to some engine APIs, with greater complexity for
  configuration and experiment-facing code.

## Consequences and review

Python does not provide Rust's compile-time ownership guarantees. Type hints,
validation, focused tests and clear state ownership remain necessary. Native
physics execution does not eliminate Python callback or data-copying overhead.

Revisit a component when profiling demonstrates a relevant bottleneck and a
measurable benefit from another implementation. Review language/version changes
against supported dependencies, contributors and CI. The platform does not
require every optional integration to be implemented in Python.

See the [roadmap](../roadmap.md) and the
[MuJoCo binding reference](../references.md#mujoco).
