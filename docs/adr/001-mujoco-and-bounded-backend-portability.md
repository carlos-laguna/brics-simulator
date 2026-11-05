# 001: Start with MuJoCo and bounded backend portability

- **Status:** Proposed
- **Date:** 05-11-2026

## Context

The first supported use case needs suspended-load motion, placement contact
and controlled disturbances. SwingRL task supplies useful reference
requirements and candidate models. An extensible open-source platform also
needs an accessible initial backend and a manageable maintenance burden.

## Proposal

Use MuJoCo for the first supported physics implementation.

Keep experiment configuration, named commands, observations, evaluation and
run metadata independent of MuJoCo objects. Isolate native simulator calls.
Preserve backend-specific model files and solver settings where their semantics
matter. Introduce shared interfaces after working examples demonstrate a need.

Share physical intent such as dimensions, mass, inertia, frames and attachments.
Do not promise lossless conversion between arbitrary engines or invent a
universal scene language now. A future backend must declare capabilities,
report explicit approximations and pass the relevant reference tests.

Maintain an open-source path for the reference experiments. Proprietary
integrations may be optional later, after a demonstrated need and review of
licensing for the intended research and distribution.

## Alternatives considered

- **Commit directly to an industrial commercial backend:** potentially valuable
  for specialised wire mechanisms, with access and licensing dependencies that
  are not justified by the immediate task.
- **Implement several backends together:** stronger early portability evidence,
  but substantially more modelling and validation work.
- **Expose MuJoCo objects throughout BRICS:** simplest initially, but couples
  policies and evaluators to native model layouts.

## Consequences and review

This gives a narrow, testable path to supported simulation capabilities. MuJoCo's approximations
still limit the claims BRICS can make. Four fixed suspension lines do not imply
validated winch, reeving, wire-contact or torsion models.

Revisit the choice when a required use case fails a documented
validation case after reasonable model and solver investigation. Consider a
second backend against that case, not against a generic feature checklist.

See [architecture](../architecture.md), [validation](../validation.md) and the
[MuJoCo references](../references.md#mujoco).
