## Branches and pull requests

Create short-lived branches from an up-to-date `main`. Use lowercase names with hyphen-separated words:

| Prefix | Purpose | Example |
|---|---|---|
| `feat/` | New functionality | `feat/falling-box-example` |
| `fix/` | Bug fixes | `fix/incorrect-gravity-direction` |
| `docs/` | Documentation changes | `docs/simulation-setup` |
| `chore/` | Tooling and maintenance | `chore/editor-setup` |
| `refactor/` | Restructuring without changing behaviour | `refactor/result-recording` |
| `experiment/` | Time-limited feasibility investigations | `experiment/rigid-body-backend` |

Keep each pull request focused on one purpose. Explain the change and how it was verified. All required checks must pass before merging.

Squash-merge completed pull requests and delete their branches. Commit messages should describe the change clearly; Conventional Commits are not required.

## Testing and development

Use test-driven development for well-defined application behaviour:

1. Define the expected behaviour and relevant edge cases.
2. Write a small test and confirm that it fails for the expected reason.
3. Implement the simplest maintainable solution that passes.
4. Refactor while keeping the tests passing.

Test observable behaviour rather than private implementation details. For bug fixes, add a regression test that demonstrates the defect where practical.

Short exploratory scripts are acceptable when investigating unfamiliar simulator APIs or uncertain physical behaviour. Before incorporating the result into supported functionality, define its contract and add appropriate automated checks.

Keep ordinary unit tests independent of simulator installations and GPU hardware. Separate simulator integration tests and document their environment requirements.

For numerical and physics checks, document the reference result, assumptions and tolerance. Use analytic solutions, conservation laws or independently established reference cases where appropriate. Do not treat visually plausible output as sufficient validation.

Run relevant checks locally before opening a pull request. Submit tests and implementation together with passing checks.

## Architecture decision records

Record significant technical decisions in `docs/adr/`, using the [ADR template](docs/adr/template.md). Routine implementation details do not need an ADR.

Name records `NNN-short-title.md`, starting with `001`. New records begin as **Proposed** and are discussed with the team before becoming **Accepted**. Proposals may also be **Rejected** or **Deferred**.

When an accepted decision is replaced, preserve it as **Superseded** and link to the new record. Link relevant ADRs from implementation pull requests.