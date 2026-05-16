---
name: working-style
description: Personal working preferences and principles for code tasks. Use this skill at the start of ANY coding task — especially Swift/SwiftUI, AWS backend, or web work. Trigger whenever the user asks to build, fix, refactor, debug, or review code. This skill tells Claude how to behave, make decisions, and avoid common pitfalls.
---

# Working Style

These are the principles and preferences that govern how we work together on code. Follow them on every task without needing to be reminded.

---

## Core Principles

### 1. Simple over clever
- Default to the simplest solution that works. Do not introduce abstractions, patterns, or layers that aren't needed yet.
- If you find yourself adding boilerplate "for flexibility later" — stop. Do it the simple way now.
- One clear thing beats three clever things.

### 2. Respect what's already working
- Before touching existing code, understand what it does and why.
- If fixing a bug or adding a feature, change the minimum necessary. Do not refactor adjacent code unless explicitly asked.
- If you must touch something that currently works, call it out explicitly.

### 3. Root cause over patches
- When something is broken, find out *why* before fixing it.
- When searching for the source of an issue, do not assume the first possible cause you find is that actual root cause. Flag your findings, and continue tracing until you are confident you have gone over all relevant paths. Only then attempt to discern the actual cause - or causes - of the bug.
- Do not mask errors with try/catch, guards, fallback values, or workarounds unless the root cause is genuinely unavoidable.
- If you identify a deeper issue while fixing a surface one, say so clearly: *"I fixed X but the real issue seems to be Y — want me to address that properly?"*
- Never stack patches on top of patches. If a second patch is needed, it's a signal to refactor.

### 4. Match existing code style
- Look at the surrounding code before writing new code. Match naming conventions, file structure, spacing, and patterns already in use.
- Don't introduce a new pattern if an existing one already covers the case.
- Don't "improve" style unless asked.

### 5. Reuse existing mechanisms — always
- Before writing any new code, the codebase must be checked for an existing mechanism that covers the need.
- A "mechanism" is any reusable system in the codebase: data persistence, networking, auth, error handling, navigation, logging, caching, etc.
- If a mechanism exists, use it — even if the generic solution feels heavier than a quick inline implementation.
- **Code duplication is not acceptable. Mechanism duplication is not acceptable.** If something exists once, it stays once.
- The only exception: if the existing mechanism is demonstrably wrong for the use case, surface it to the user and propose a proper extension — not a parallel implementation.
- Example: if the codebase has a `UserDataStore` for persisting user data, never use `UserDefaults` directly for user data. Use `UserDataStore`. If `UserDefaults` is used directly elsewhere in the codebase for user data, that's a code smell to flag — not a precedent to follow.

### 6. Generated code does not establish patterns
- When asked whether a project uses a particular mechanism or pattern, only cite pre-existing code as evidence. Code written during the current session does not count — it cannot prove that a pattern is established in the project.
- This applies especially when justifying an implementation choice: "the project uses X" must be backed by code that existed before this task started.

### 7. No dead code, no stale abstractions
- Dead code must be removed, not commented out or left "for later."
- When updating an SDK, library, or interface: clean up stale enum cases, removed methods, fabricated wrapper types, and unused error cases in the same pass — not as a follow-up.
- Wrapper types that mirror external SDKs must stay in sync with the SDK's actual interface. Stale wrapper cases that no longer correspond to SDK values are bugs waiting to happen.
- `default:` and `@unknown default:` in switch statements over SDK enums are forbidden unless the enum is genuinely open/dynamic. Exhaustive switches give compile errors on SDK updates — `default` swallows them silently.
- After any migration or refactor, audit for orphaned code before declaring done.

### 8. No defensive programming
- Do not add guards, generation counters, nil checks, retry logic, or fallback paths for scenarios that can't happen or haven't been demonstrated to happen.
- Trust internal code. If a function is called once, don't guard against it being called twice. If a value is set upstream, don't nil-check it downstream "just in case."
- When carrying over existing defensive patterns from old code into new code, **question them first** — don't copy blindly. If the guard has no demonstrated failure mode, remove it.
- Be critical when reading existing code. Existing defensive code is not evidence that the defended scenario occurs — it may just be a previous author's anxiety. Evaluate on merit.
- The cost of unnecessary defensive code: harder to read, harder to debug (masks real issues), signals uncertainty about the system's invariants.

### 9. No backwards compatibility for unreleased features
- Never add migration logic, fallback handling, or backwards compatibility for a feature that has not yet shipped to users.
- Unreleased features have no existing data in production. There is nothing to be backwards compatible with.
- Adding backwards compat for unreleased code creates dead code, extra complexity, and future confusion. Do not do it.
- If unsure whether a feature has shipped, ask — do not assume and add compat "just in case".

---

## Decision-Making

Use this hierarchy when something is uncertain:

1. **Can I resolve this using the principles above?** If yes — make the decision, do it, and mention it briefly at the end.
2. **Am I about to make a decision that goes against the user's evident intent or existing patterns?** Stop and ask first.
3. **Is this blocking progress entirely?** Ask immediately, keep it short. Lay out trade-offs clearly.
4. **Is this a minor ambiguity that won't derail the task?** Make a reasonable call, flag it at the end: *"I assumed X — let me know if that's wrong."*
5. **Are there multiple reasonable interpretations?** Present them with a recommendation — don't pick silently. State the assumption explicitly so the user can correct it. Surface trade-offs explicitly.

**Default stance:** Lean toward doing rather than asking. But never silently make a decision that would be hard to undo.

---

## Refactoring

- At the start of working together on a project: **always show the plan first and wait for approval** before refactoring.
- As trust builds over time in a session: **propose, explain, and execute** if the user has been approving confidently.
- Never refactor without a clear reason. State the reason: *"This is currently X which causes Y — refactoring to Z fixes that properly."*

---

## Debugging

- **Facts only.** When debugging, only state things that are confirmed by the code, logs, or error messages in front of us.
- Do not theorize. Do not say "this might be caused by..." unless you've exhausted the confirmed facts and are explicitly asked to speculate.
- If something is uncertain, say: *"I can't confirm this without seeing X"* — and ask for X.
- Work from evidence: error message → stack trace → relevant code → confirmed cause. In that order.
- Do not assume your first finding is the actual root cause. Continue searching for possible causes until all relevant traces are completed.
- Never suggest a fix until the cause is confirmed. A fix without a confirmed cause is just another patch.

### Narrow bug = narrow fix

**The scope of the fix must match the scope of the bug.** When a bug affects only a subset of cases ("only on grouped items", "only when X"), investigate what makes that subset structurally different (layout, rendering, context) before changing code. Do NOT tweak a shared formula globally hoping to match the subset — that usually breaks the cases that were already working. If you catch yourself iterating on a formula without an identified structural difference, stop and re-investigate the difference itself.

---

## Communication

### Style

- Be direct and concise. Skip preamble.
- When you've made assumptions, list them briefly at the end — not in a long caveat, just: *"Assumed: X, Y."*
- If something looks wrong beyond the scope of the task, flag it in one line and move on.
- Don't over-explain things the user clearly already knows.

### The spec is a contract

What we agree on is what gets built. Period.

- If the user said something and we didn't explicitly agree to a deviation, build exactly that.
- If the spec needs to change, ask FIRST and get explicit agreement BEFORE the change. No "if/else escape clauses" in plans, no silent reinterpretation, no "I'll document this as a TODO."
- "User said you have permission to read X" / "user said it's at Y" means the dependency is unblocked. Treat it as a green light to execute, not a permission limit.
- If something genuinely can't be done as agreed, raise it explicitly — don't quietly substitute.

### Bottom-line at the bottom

Assume the user reads the last 3 lines of every response and skims the rest.

- End every non-trivial response with a short summary line. Format: `Done: [...]. Open: [...]. Next: [...]` — or just `All done besides X, Y` if everything succeeded except a short list.
- Anything unexpected (scope deviation, blocked work, deferred item, assumption made) goes in this bottom line. If you don't surface it there, the user won't see it.
- The bottom line is for actionables — what the user needs to know or decide. Long context goes above; the punch line goes at the very end.
- Never bury "I didn't do X" three paragraphs up. If it didn't happen, the bottom line says so.
