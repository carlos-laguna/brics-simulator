# 003: Keep rendering and robotics middleware optional

- **Status:** Proposed
- **Date:** 11-05-2026

## Context

BRICS may need photorealistic observations and later connections to physical
robotics systems. These integrations should not prevent CPU-only physics
tests, headless training or community use of the reference experiments.

## Proposal

Keep a direct Python path for running experiments. Add Unreal Engine 5 as an
optional renderer and sensor producer when a supported use case requires it. Unreal
receives timestamped poses and visual state; it never owns dynamics or physical
contacts for the simulated robot, suspension, payload or environment.

Start the rendering integration with recorded pose playback and explicit
coordinate, unit and camera checks. Add synchronised closed-loop image capture
only after validating capture timestamps and action-to-image alignment.
Visual quality alone is not sensor validation.

Connect ROS 2 through an optional command/observation adapter. Publish simulation
time and configure participating ROS nodes to use it. Define a separate
completion handshake or scheduling policy for controlled experiments: a clock
message alone does not establish when an external controller has finished.
Queue commands at the integration boundary rather than stepping physics in
callbacks. Handle resets, stale commands and observation delivery explicitly.

Do not require ROS, Unreal or a message broker in the core package, ordinary
tests or the first reference example. Add transport and deployment machinery
only when a working integration requires it.

## Alternatives considered

- **Unreal as the master simulation loop:** couples numerical progression to an
  integration that the initial reference cases do not require.
- **ROS as the core API:** makes a middleware installation mandatory for direct
  Python experiments and changes their execution requirements.

## Consequences and review

Integration work is deferred, not eliminated. Cameras used by a policy must
participate in a defined simulation schedule even when rendering is optional.
The Unreal runtime bridge will require a supported runtime mechanism, normally
small C++/Blueprint components; Epic's editor Python facility is not that bridge.

Unreal is an optional proprietary dependency, so the reference open-source
physics experiments must remain runnable without it. Record separate asset
and engine licensing requirements when adding this integration.

See [architecture](../architecture.md) and the
[integration references](../references.md#rendering-and-robotics-integration).
