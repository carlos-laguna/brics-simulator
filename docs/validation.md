# Validation and evaluation

**Status:** planned validation policy. No test results, physical accuracy, or supported safety envelope are claimed by this document.

The aim is to establish what each model can support scientifically, detect numerical artefacts, and compare learned methods fairly. A visually convincing rollout is useful for inspection but is not validation.

## Separate three questions

1. **Software verification:** does the implementation follow its declared contract, including units, timestamps, resets, records, and failures?
2. **Model validation:** does the simulated behaviour agree with an appropriate reference for the intended operating range?
3. **Research evaluation:** does the proposed method improve the declared outcomes under a controlled comparison?

Passing one does not imply the others. An analytic pendulum test does not validate insertion contact, and good insertion statistics do not establish calibrated impact forces.

## Model assumptions and validity

Each supported scenario should declare its physical assumptions, permitted configurations, and known omissions. Maintain this information beside the scenario and its tests, not only in a global README.

| Model component | Initial limitation to document | Evidence required before a stronger claim |
| --- | --- | --- |
| Rigid bodies | No bending, fracture, crushing, or local surface deformation unless explicitly represented | Relevant deformation or failure measurements and an appropriate model |
| Suspension | Chosen links, joints, or tendons approximate a specific suspension; no automatic claim of rope twist, draping, reeling, or sheave behaviour | Reference cases for each included mechanism and parameter range |
| Contact | Geometry, friction, compliance, regularisation, and solver settings influence penetration and impact response | Timestep/settings sensitivity, contact references, and measurements for calibrated force claims |
| Wind | Applied forces and moments represent a stated field or load approximation | Force/torque references; measurements or appropriate flow modelling for shielding and wake claims |
| Actuation | Command semantics and any ideal motion source affect energy exchange and contact | Explicit limits, tracking dynamics, delay, and validation appropriate to the claimed robot behaviour |
| Sensing | Injected state noise/loss is not equivalent to rendered-camera perception error | Sensor calibration and tests appropriate to the actual observation pipeline |

For each approximation, record why it is adequate for the current experiment and which conclusions it cannot support. Unknown parameters should remain identifiable as assumptions. Parameter randomisation is not a substitute for establishing a plausible range.

## Numerical verification ladder

Use small reference cases before complete placement scenes:

1. **Free fall:** check position, velocity, initial sampling, timestamps, and convergence against the analytic solution. The initial reference example has no ground contact.
2. **Suspended motion:** check static equilibrium and small-amplitude swing under the assumptions of the chosen reference. A fixed-length point pendulum formula is not a universal reference for a hoisting, distributed, multi-sling system.
3. **Disturbances:** check force direction, application point, torque, steady deflection, and a controlled time-varying input. Use a prescribed field before adding complicated turbulence.
4. **Contact:** isolate drop, sliding, fixture contact, and settling cases before combining them with suspension. Include intentional clean seating and rim-contact failures.
5. **Integrated placement:** test the declared operating range, including deliberately unsuccessful cases and imperfect sensing.

For numerical studies, reduce timestep and vary relevant solver settings while keeping physical conditions and control/sensor scheduling comparable. Compare event time, trajectory, approach speed, impulse, penetration, and task classification. A stable run can still have a biased answer. If results change materially, narrow the claimed operating range or improve the model before comparing policies.

Choose tolerances from reference accuracy, discretisation error, measurement uncertainty, and the research decision being made. Record their rationale before using the case to compare methods. There is no universal acceptable contact penetration, force error, or timestep.

## Define safety-related measurements precisely

| Measurement | Required definition |
| --- | --- |
| Landing approach speed | Signed relative velocity along the declared contact normal immediately before the resolved contact event; specify body/fixture pair and coordinate convention |
| Contact event | Named body or geometry pair, first resolved contact time, duration, locations, normals, and any event-merging rule |
| Impact impulse | Vector or normal component over a declared event window, with the backend quantity, frame, aggregation, and units identified |
| Contact force | Backend-reported quantity and sampling semantics; distinguish instantaneous model force from an impulse divided by a step duration |
| Swing and rotation | Defined angle, angular velocity, horizontal motion, and/or energy measure with the reference frame and geometric approximation stated |
| Cable loading | Per-element tension or an explicitly identified proxy; record slack definition and availability rather than inventing missing measurements |
| Placement outcome | Geometric seating condition, dwell time, allowable contacts, timeout, and early-termination rules |
| Safety-related violation | A predefined threshold or forbidden event, with severity and exposure time where meaningful |

Payload centre-of-mass speed is insufficient for a tilted or rotating load. A point's velocity includes both translation and rotation:

`v_point = v_COM + cross(omega, r)`

Here, `v_COM` is the centre-of-mass velocity, `omega` is the angular
velocity, and `r` is the vector from the centre of mass to the point.
`cross` denotes the vector cross product. All vectors must be expressed
in the same coordinate frame. Approach speed uses the difference between payload and fixture point velocities projected on the declared normal. Curved surfaces and multiple contact points require an explicit aggregation rule.

The first contact resolved by a discrete solver is not necessarily the exact continuous-time impact instant. Preserve the last non-contact sample and event sample, and report the timing resolution or validated interpolation used. Contact geometry may itself be an approximation. A post-step body pose and the solver's stored force/contact data may describe different calculation times: timestamp their actual semantics rather than assigning the endpoint time to every field.

Measure at physics resolution, including substeps when used, rather than only at the control or rendering rate. Peaks can depend strongly on timestep and contact compliance. Record impulse where meaningful and check consistency with momentum change while accounting for gravity, suspension, actuation, and other external forces over the same interval. Do not equate impulse with damage.

Store raw event quantities and the metric-definition version so later summaries can be audited. Do not silently treat an unavailable quantity as zero. Keep failed or unstable episodes in the results with an explicit reason.

## Reusable benchmark contracts

When BRICS maintains a benchmark, version its scenario definitions, observation
and action interfaces, disturbance schedules, termination conditions and
metric definitions. Record realised parameters as well as seeds; a shared
seed alone does not ensure identical conditions if consumers draw random
numbers in a different order. Separate disturbance and sensor randomness
from application randomness where needed.

Keep allowed observations distinct from evaluator truth. Document calibration
status and threshold rationale, and report invalid and unsuccessful runs.
Completion, elapsed simulation time and contact/swing measurements should
remain available together so consumers can examine trade-offs.

A published benchmark may own fixed splits and scoring rules if BRICS commits
to maintaining them. Individual research projects own their hypotheses,
method selection, training, ablations and statistical conclusions. Freezing
a benchmark protocol is separate from selecting a study that uses it.

## Automated checks and experiment records

Pure unit tests cover configuration, transformations, metric logic, and input validation without a renderer or GPU. Simulator integration tests exercise actual stepping and physical reference cases. Renderer and ROS integration checks remain separate and document their environments. Exploratory scripts are acceptable; supported behaviour needs a contract and appropriate checks.

Every recorded experiment should identify code and dependency versions, model/assets and their provenance, physical parameters, backend/solver settings, physics/control/sensor timing, randomisation, policy checkpoint, observation/action definitions, and metric versions. Include hardware and rendering settings when they affect results or performance.

Use repeated runs to test repeatability on a declared environment with stated tolerances. Do not promise bitwise identity across versions or hardware. Pose playback, rerunning recorded actions, and restoring a complete simulator checkpoint have different guarantees and must be named separately.

## Gates for supported scenarios

A scenario is ready for baseline research when its contract and assumptions are documented, software checks pass, applicable reference tests pass with justified tolerances, numerical sensitivity is characterised, records permit reproduction, and both successful and failed cases have been inspected. Mark uncalibrated quantities clearly.

Real-rig evidence is a later gate for physical accuracy claims. Synchronised pose, commands, wind, and suitable force measurements would strengthen validation; sensor location and bandwidth limit what they establish. Until then, report improvements as simulated outcomes within the evaluated conditions.
