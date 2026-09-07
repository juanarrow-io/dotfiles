# Agents Instructions

These are global defaults shared across all agents on this machine.

## Response Style

- Be concise and direct by default.
- Prefer concrete outputs over long explanations.
- For reviews: list findings first by severity with file references, then summary, then open questions.

## Main rules

- **Think Before Coding.** Don't assume. Don't hide confusion. Surface tradeoffs.
  - State your assumptions explicitly. If uncertain, ask.
  - If multiple interpretations exist, present them - don't pick silently.
  - If a simpler approach exists, say so. Push back when warranted.
  - If something is unclear, stop. Name what's confusing. Ask.
- **Simplicity First.** Minimum code that solves the problem. Nothing speculative.
  - No features beyond what was asked.
  - No abstractions for single-use code.
  - No "flexibility" or "configurability" that wasn't requested.
  - No error handling for impossible scenarios.
  - If you write 200 lines and it could be 50, rewrite it.
  - Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.
- **Surgical Changes.** Touch only what you must. Clean up only your own mess. Every changed line should trace directly to the user's request.
  - Don't "improve" adjacent code, comments, or formatting.
  - Don't refactor things that aren't broken.
  - Match existing style, even if you'd do it differently.
  - If you notice unrelated dead code, mention it - don't delete it.
  - Remove imports/variables/functions that YOUR changes made unused.
  - Don't remove pre-existing dead code unless asked.
  - Don't remove any pre-existing debugging logs or comments that weren't added by you, unless asked.
- **Goal-Driven Execution.** Define success criteria. Loop until verified. Transform tasks into verifiable goals.
  - Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## Workflow Rules

- Prefer minimal diffs and incremental changes.
- Do not create permanent helper scripts for one-off requests unless the user asks.
- Respect dirty worktrees and never revert unrelated user changes.
- NEVER remove comments or debugging logs that weren't added by you, unless asked.

## Inline Comments

Governing rules for comments in any code you write:

- **Explain the "why," not the "what."** Don't restate what the code already makes obvious. Document why a decision was made, which edge case is being handled, what trade-off was chosen.
- **Be precise and contextual.** Short but specific to the logic annotated. Place the comment above the relevant line or block; trailing comments only when very brief.
- **Keep comments current.** Update or delete a comment the moment its code changes — stale comments are worse than none. Mark temporary behavior with a clear `TODO:` or `FIXME:` tag.
- **Use a consistent tone and format.** Full sentences start with a capital letter and end with a period. Imperative mood for instructions ("Do this…"), descriptive mood for explanations ("This does…").
- **Highlight assumptions and constraints.** Document non-obvious preconditions, invariants, and limitations.

## Git Commits

Every commit must be:

- **Clear** — message states what changed and why, understandable without reading the diff.
- **Clean** — stage only intended files; never `git add -A`/`.`. Leave unrelated working-tree changes alone.
- **Concise** — short imperative subject (≤ ~70 chars); body only when the "why" needs it.
- **Conventional** — Conventional Commits: `type(scope): subject` (e.g. `fix(theme): ...`, `feat(api): ...`).
- **Atomic** — one logical change per commit; split unrelated work into separate commits.
- **Single author** — never add `Co-Authored-By` or any attribution trailer.

## Pull Requests

- **Before creating any PR, ask which GitHub account to use** and switch with `gh auth switch -u <user>`. Multiple accounts are configured in `gh` (e.g. `juppy-dev` for personal/solo projects, `paolo-ar`, `paolo-nplus`); the active one is often wrong and PR creation fails with "Could not resolve to a Repository". Confirm the account, switch, then create the PR.
- **No self-attribution.** Never credit yourself in a PR title, body, or comment — no "Generated with Claude Code", no 🤖 line, no `Co-Authored-By` or any attribution trailer, no tool/model name anywhere in the PR.
- **Merge commit format.** When merging a PR, the merge commit subject is a conventional commit with an **ALL-CAPS type** and a **Capitalized description** (e.g. `FIX: Product Page Stripe Integration`, `FEAT: Combined Leasing Deposit Flow`) — note this differs from the lowercase `type(scope): subject` style used for regular commits. Keep GitHub's default `Merge pull request #N from …` line in the **body**, not the subject. Don't accept the plain default subject.

## Superpowers Plugin — Document Paths

- The superpowers skills default to saving documents under `docs/superpowers/<type>/` (e.g. `docs/superpowers/plans/`, `docs/superpowers/specs/`). **Override this**: skip the `superpowers/` segment and use `docs/<type>/` directly — `docs/plans/`, `docs/specs/`, `docs/diagrams/`, etc. Apply the same convention when looking up existing plans/specs.
- **Diagrams rider.** Whenever you create or substantially revise a spec/design document, judge whether it warrants an architecture diagram. If the design has structure worth seeing (layers/components, a multi-step flow, a state machine, data/sequence interactions), author or update a **mermaid `.md` in `docs/diagrams/`** and reference it from the spec. If the change touches a subsystem an existing diagram already covers, **update that diagram in the same change** rather than letting it drift. Skip diagrams for trivial/localized specs (a single function, a copy tweak, a config change) — note briefly that you skipped and why. When it's a genuine toss-up whether a diagram would help, just ask me. Keep diagrams in sync as the design evolves; they are a maintained artifact, not a one-off.

## Superpowers Plugin — Visual Mockups

- **When asked to spin up a visual mockup** (e.g. the brainstorming skill's preview server), first ask whether it should bind to the **default (`127.0.0.1`, local only)** or to **`0.0.0.0`** (reachable over LAN/Tailscale for viewing from another device — e.g. during remote SSH sessions, or to preview on a phone). For `0.0.0.0`, pass `--host 0.0.0.0` to `start-server.sh` (or set `BRAINSTORM_HOST=0.0.0.0`). Note `0.0.0.0` exposes the server on every interface, not just Tailscale.

## Safety

- Never expose secrets from local configs or environment files.
