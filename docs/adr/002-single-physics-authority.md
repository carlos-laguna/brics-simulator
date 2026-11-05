# 002: Use one physics authority per coupled world

- **Status:** Proposed
- **Date:** 11-05-2026

## Context

Suspension tension, payload motion and placement contact affect one another.
Independently stepping engines for the rope and load would require a validated
numerical coupling scheme. Rendering and middleware can also introduce
unintended timing changes if allowed to advance the simulation.

## Proposal

For the initial implementation, assign one dynamics backend to the complete
mechanically interacting world for the whole episode. It owns the robot, load,
suspension, fixtures and their physical contacts. Do not switch engines when
contact begins or split connected parts between engines.

Allow only the episode runner to request advancement. The backend performs
the requested fixed-duration physics steps and reports their completed times.
Physics, control and sensor schedules derive from this common timeline.
Record their rates independently; a policy frequency is not a physics rate.

Controllers and external force models may supply commands or forces. They do
not independently integrate the same body's motion. Renderer and ROS callbacks
never request physics steps. Separate independent episodes may have their own
runners and backends.

Define the order of command application, stepping, state extraction, sensor
capture and delivery. Tag records with episode, tick and simulation time. Reset
all episode-dependent state and pending messages before another episode.

## Alternatives considered

- **Different engines for cable and payload:** requires solving interface forces,
  energy transfer and stability, beyond the current scope.
- **Switch engines on impact:** requires transferring hidden solver and contact
  state; copying pose and velocity alone is insufficient.
- **Render-driven variable stepping:** makes numerical behaviour depend on
  rendering workload and hardware.

## Consequences and review

The rule simplifies causal experiments and prevents conflicting physics
ownership. It limits mixed-engine flexibility by design. A future co-simulation
proposal would need its own coupling contract and validation evidence.

Fixed stepping does not guarantee physical accuracy, determinism across
platforms or convergence of contact-force peaks. Select step sizes through
reference tests and convergence studies. Explicitly model latency; wall-clock
slowness alone must not change simulated observation age.

See [architecture](../architecture.md) and [validation](../validation.md).
