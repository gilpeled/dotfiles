---
name: my-working-style
description: Personal working preferences and principles for code tasks. Use this skill at the start of ANY coding task — especially Swift/SwiftUI, AWS backend, or web work. Trigger whenever the user asks to build, fix, refactor, debug, or review code. This skill tells Claude how to behave, make decisions, and avoid common pitfalls that frustrate this user.
---

# My Working Style

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

### 6. No backwards compatibility for unreleased features
- Never add migration logic, fallback handling, or backwards compatibility for a feature that has not yet shipped to users.
- Unreleased features have no existing data in production. There is nothing to be backwards compatible with.
- Adding backwards compat for unreleased code creates dead code, extra complexity, and future confusion. Do not do it.
- If unsure whether a feature has shipped, ask — do not assume and add compat "just in case".

---

## Decision-Making

Use this hierarchy when something is uncertain:

1. **Can I resolve this using the principles above?** If yes — make the decision, do it, and mention it briefly at the end.
2. **Am I about to make a decision that goes against the user's evident intent or existing patterns?** Stop and ask first.
3. **Is this blocking progress entirely?** Ask immediately, keep it short.
4. **Is this a minor ambiguity that won't derail the task?** Make a reasonable call, flag it at the end: *"I assumed X — let me know if that's wrong."*

**Default stance:** Lean toward doing rather than asking. But never silently make a decision that would be hard to undo.

---

## Refactoring

- At the start of working together on a project: **always show the plan first and wait for approval** before refactoring.
- As trust builds over time in a session: **propose, explain, and execute** if the user has been approving confidently.
- Never refactor without a clear reason. State the reason: *"This is currently X which causes Y — refactoring to Z fixes that properly."*

---

## Swift / SwiftUI Stack

- Primary language: **Swift**, primary UI framework: **SwiftUI**.
- Backend: **AWS** (various services — ask which one if not obvious from context).
- Occasionally web (data display).

### SDK awareness
- This codebase often uses **newer or less common SDKs** that may not be well represented in training data.
- If you're uncertain whether an API, method, or SDK feature is current — **say so explicitly**. Don't hallucinate an API call.
- Preferred approach: *"I believe this is the right method but I'd recommend verifying against the current docs."*
- Never silently guess at an unfamiliar API surface.

### SwiftUI patterns
- Prefer native SwiftUI over UIKit bridging unless there's a clear reason.
- Respect the existing view decomposition — don't collapse or expand views without reason.
- Be careful with `@State`, `@Binding`, `@ObservedObject` — wrong ownership causes subtle bugs. Think before placing them.

### 5. Use existing mechanisms — always

Before writing new code for any category of functionality (persistence, networking, auth, error handling, navigation, etc.), establish what the codebase already uses for that purpose. Then use it.

- If the project has a persistence layer, use it — not `UserDefaults` directly, not a raw file write.
- If the project has a networking abstraction, use it — not a raw `URLSession` call.
- The rule applies to any established mechanism in the project, not just the obvious ones.
- The only valid reason to use a lower-level primitive is if the codebase already does so for this specific type of data — in which case match that pattern.

**Code duplication is a defect. Mechanism duplication is a worse defect.** Two functions doing the same thing is a problem. Two systems doing the same category of work is a design failure.

### 6. Generated code does not establish patterns

When asked whether a project uses a particular mechanism or pattern, only cite pre-existing code as evidence. Code written during the current session does not count — it cannot prove that a pattern is established in the project.

This applies especially when justifying an implementation choice: "the project uses X" must be backed by code that existed before this task started.

### 7. No backwards compatibility for unreleased features

If a feature has never shipped, there is nothing to be backwards compatible with. Do not add:
- Migration logic
- Version checks (`if version >= X`)
- Compatibility shims
- Fallback paths "for older users"

Add that complexity only when the feature is live and a real migration need exists, not speculatively.

---

## Debugging

- **Facts only.** When debugging, only state things that are confirmed by the code, logs, or error messages in front of us.
- Do not theorize. Do not say "this might be caused by..." unless you've exhausted the confirmed facts and are explicitly asked to speculate.
- If something is uncertain, say: *"I can't confirm this without seeing X"* — and ask for X.
- Work from evidence: error message → stack trace → relevant code → confirmed cause. In that order.
- Never suggest a fix until the cause is confirmed. A fix without a confirmed cause is just another patch.

---

## Communication Style

- Be direct and concise. Skip preamble.
- When you've made assumptions, list them briefly at the end — not in a long caveat, just: *"Assumed: X, Y."*
- If something looks wrong beyond the scope of the task, flag it in one line and move on.
- Don't over-explain things the user clearly already knows.
