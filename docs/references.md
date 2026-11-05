# References and evidence

External documentation supports specific API or product facts. The architecture
and platform roadmap are BRICS proposals, not recommendations endorsed by the
projects linked below. Reference pages were checked on **5 November 2026**;
moving documentation URLs may change. Record exact installed versions in each
experiment, and consult the matching documentation when implementing a feature.

## SwingRL

Guangming Wang and colleagues, **SwingRL: Adaptive Observation Reinforcement
Learning with World-Model Prediction for Cable-Suspended Hoisting Control**,
labelled arXiv:2609.33053v1, 27 September 2026.

The paper informs the first reference use case and its physical
rig requirements. Section IV describes the simulation and real-rig evaluation.
Its learning method is a possible consumer of the simulator, rather than an
architectural requirement of BRICS.

The paper is not a complete executable specification. Obtain and record the
group's model, implementation revision and experiment settings. Resolve missing
or inconsistent geometry, contact and timing details before claiming a faithful
reproduction of a reference setup. Do not redistribute the manuscript or assets without
establishing the applicable permissions.

## MuJoCo

- [Modeling](https://mujoco.readthedocs.io/en/stable/modeling.html): native MJCF,
  model structure and supported import formats. Support for URDF does not make
  it a complete description of every BRICS suspension/contact model.
- [Python bindings](https://mujoco.readthedocs.io/en/stable/python.html): native
  bindings, mutable state arrays and simulation calls.
- [Computation](https://mujoco.readthedocs.io/en/stable/computation/index.html):
  model semantics, numerical integration and the computation pipeline.

## Rendering and robotics integration

- [Epic: Scripting the Unreal Editor Using Python](https://dev.epicgames.com/documentation/en-us/unreal-engine/scripting-the-unreal-editor-using-python):
  editor Python is distinct from runtime integration.
- [ROS 2 clock and time design](https://design.ros2.org/articles/clock_and_time.html):
  simulated time, `/clock` and handling changes in the time source. BRICS must
  separately define experiment scheduling and command-completion semantics.

## Lessons from CARLA

[CARLA: Synchrony and time-step](https://carla.readthedocs.io/en/latest/adv_synchrony_timestep/)
is useful precedent for explicit simulation time, fixed stepping and coordinated
sensor collection. BRICS should learn those design principles without adopting
CARLA's road-specific abstractions or assuming its physics integrations meet
suspended-load requirements or others. This is an architectural analogy, not an engine
comparison or a plan to fork CARLA.

## Development tooling

- [uv dependency management](https://docs.astral.sh/uv/concepts/projects/dependencies/):
  contributor groups and installable optional dependencies serve different
  purposes.
- [MkDocs documentation layout](https://www.mkdocs.org/user-guide/writing-your-docs/):
  navigation, relative Markdown links and static assets.

For published results, cite the exact papers, software releases and asset
revisions used. This page does not replace experiment provenance.
