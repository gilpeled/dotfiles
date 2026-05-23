---
name: solution-review
description: Evaluate a candidate's submission to the ML algo group's take-home exercise (singer-age classification on DAMP-S-AG). Reads the candidate's report + code and produces a concise qualitative checklist of which considerations they engaged with, which they skipped, and where they made strong choices. Does NOT produce numerical scores or a hire/no-hire verdict.
---

# Solution review — ML algo take-home

You are reviewing a candidate's submission to our ML algo group's take-home exercise. The exercise asks to build a from-scratch deep-learning classifier for singer age on the partial DAMP-S-AG dataset, run iterations, and write a report.

We are hiring **senior ML research engineers** for a role that needs:
- Strong expertise in AI model training pipelines.
- Generalist mentality.
- Industry-tested engineering for production systems.

## What you produce

A **concise qualitative review** in markdown — an **intro for the human reviewer**, not their whole review. They will read the report and code themselves; your job is to orient them and point at what's worth focusing on. Aim for something the reviewer can skim in under two minutes.

Not a score. Not a hire/no-hire.

**Disposition: skeptical but fair.** A ~4-hour submission has gaps — finding them is part of the job, and a pretty-ok solution should produce a pretty-ok review, not a glowing one. But give credit where it's due: when the candidate genuinely got something right, say so plainly. Avoid default superlatives ("excellent", "unusually sharp", "sophisticated") — prefer concrete description over praise, and reserve the strong words for work that earns them. `✓ Addressed` is a real bar, not a participation marker.

## Inputs

You will be pointed at a candidate's submission folder. It typically contains (hierarchy may vary):
- A **report** as `.pdf`, `.md`, or `.docx` (sometimes also experiment logs, notes.md, etc.).
- A **code directory** with Python files, possibly notebooks (`.ipynb`).
- A results or runs directory with artifacts.

## Process

### Step 1 — Inventory the submission
- List the main structure (report, code, results) — not every file.
- Read the exercise spec (`exercise.md`, sibling to this SKILL.md) if you have not already in this session.

### Step 2 — Read the report end-to-end
- PDF: use the Read tool's PDF support; docx: convert via `textutil -convert txt` or `pandoc`; md: read directly.
- Also read any auxiliary experiment log if present.

### Step 3 — Read the code
- Read every code file; skim notebooks fully. Note training loop, dataset class, model definition, eval logic.
- Walk the results directory and view a sample of plot images. Don't enumerate everything in the final review.

### Step 4 — Fill in the rubric

For each item, record:

- **Status:**
  - `✓ Addressed` — engaged with the question **and** justified *their specific choice within their solution* beyond what the exercise already directs.
  - `↻ Alternative` — took a different but well-reasoned approach.
  - `~ Mentioned` — made a choice but didn't justify *this particular choice*, only the general direction (often a direction the exercise already prescribes).
  - `? Unclear` — touched on but underspecified, or you can't tell.
  - `✗ Missing` — not mentioned, not visible in code.
- **The choice itself goes on the status line**, terse, when one phrase covers it. E.g. `Architecture — ↻ Alternative — CNN baseline + Transformer focus`. Omit if no clean phrase fits.
- **Notes (≤ 2 sentences):** your reading. Was the rationale convincing? Any caveat? Cite at most **one** report location (e.g. "report §3.2") and at most **one** code location (e.g. `train.py:fit`), inline in the notes, only when they sharpen the point. No separate Evidence field.

**Mentioned vs. addressed.** A candidate stating a choice is not engagement. Engagement requires justifying *their specific choice* — why these bins, this architecture, this patch length, given their data and solution — not restating a direction the exercise already gave them. Restating the exercise's own framing is `~ Mentioned`, not `✓ Addressed`.

## Delegating to subagents

For larger submissions, delegate read-heavy work to subagents and run them in parallel. The main thread (you) stays lean and synthesises.

**Launch all three in a single message with multiple Agent tool calls** so they run concurrently:

1. **Report reader** (`subagent_type: general-purpose`) — reads the report + any experiment log. Returns A1–A8 with status + brief notes.
2. **Code reader** (`subagent_type: Explore` for scan, `general-purpose` for deeper reads) — reads code, skims notebooks. Returns B2 and B3 with `path:line` references.
3. **Artifacts auditor** (`subagent_type: general-purpose`) — walks the results directory, opens a sample of plots. Returns B1 categories + main artifacts.

After they return, you write section C, the summary, and open-question suggestions, then produce the final review file.

### Gotchas

- **Don't duplicate the subagents' work.** Synthesise from what they returned; don't re-read files they already covered.
- **Subagents don't see this conversation.** Each prompt must be self-contained: submission path, pointer to `exercise.md` (sibling to this SKILL.md), and which rubric items they own.
- **Trust but verify on red flags.** If an agent reports something dramatic ("used pretrained weights," "no validation set," "trained on test data"), spot-check that one claim before it lands in C2.

## The rubric

### A. Report content

**A1. Data exploration & bucket choice**
Did they look at the data (age / gender / country / track-length distributions) before training? What buckets did they pick — and did they justify *these specific bins* for their data and task? Coarse bucketing is already in the exercise; the interesting question is why this particular partition.

**A2. Model input representation**
Raw waveform / spectrogram / mel-spec / MFCC / other. Did they discuss the choice?

**A3. Dataset construction & data usage**
- Silence filtering / VAD?
- Patching / fixed-length clips — what choices and rationale?
- Are per-patch predictions pooled into per-song predictions at inference?
- Class imbalance handling (weighted sampling/loss, undersampling, balanced buckets)?
- Discussion of limitations imposed by the limited data?

**A4. Model architecture**
Conv2D / other? Reasoning given? The spec forbids pretrained weights / existing audio models — flag any violation.

**A5. Dataset splits & leakage**
- Train / val / test, or just train / test?
- **Split by `account_id`** so the same singer doesn't appear in both train and test? This is the most important leakage check for this dataset — call it out explicitly.

**A6. Framework & training infrastructure**
PyTorch / Lightning / Keras / other? Checkpointing? Logging (TensorBoard / W&B / printed)? Reproducibility (seeds, configs)?

**A7. Evaluation**
- Metrics beyond raw accuracy (F1, per-class precision/recall, macro vs. micro)?
- Confusion matrix?
- Eval loss tracked alongside train loss?
- Sensible interpretation of the numbers?

**A8. Improvement directions discussed**
- **Data augmentations** (specaugment, mixup, time/pitch shift, noise) — augmentations are a core lever for small, imbalanced audio datasets like this one; **absence from the future-work discussion is a real flag** and should be called out, not just noted neutrally.
- Pretrained embedding models (WavLM, HuBERT, wav2vec2, …) as a future direction?
- Other forward-looking thinking?

### B. Code & results

**B1. Result artifacts present**
Highlight the main artifacts and which broad categories are covered, with one example per category — not a full enumeration. Categories: data-distribution plots, iteration-comparison tables, confusion matrices, loss curves, other metric curves, saved checkpoints. Call out conspicuous absences.

**B2. Code quality**
NOT production-grade. Looking for:
- Broadly readable structure (clear module responsibilities, no 1000-line god-files)
- Reasonable naming, minimal duplication
- Some config / arg handling so experiments are repeatable

Flag obvious smell (copy-paste blocks, hard-coded magic, dead code), but don't be a stickler.

**B3. Training pipeline soundness**
- Coherent training loop (clean train/val separation, proper optimizer/scheduler use, no obvious bugs)?
- Supports experimental work — could you run 5 variants without rewriting? Config-driven? Reasonable separation of model / data / training?
- Production-engineering instincts (error handling at boundaries, deterministic seeding, resumable checkpoints)?

### C. Cross-cutting signal

The point of section C is to surface what the candidate's choices reveal about them as a researcher and engineer. **Broad signal, not technical trivia. Filter aggressively.**

**Don't recap the rubric.** If a fact has a natural home in an A or B item, it lives there — not in C. C is for the *pattern across multiple items* or a *characterization of the candidate* that no single rubric item carries. If you find yourself writing a C bullet that just restates an A or B finding, either delete the C bullet or rewrite it to say what the pattern means. The same fact appearing in A, B, *and* C is the failure mode to avoid.

**C1. Strong unexpected choices**
High-level research and engineering moves that suggest expertise: a non-obvious architecture or framing decision, infrastructure choices that show iteration discipline (caching, parallel sweeps, careful ablations), problem reformulations the exercise didn't prompt. **Skip incidental details** that a coding agent would have produced as boilerplate (file layout, micro-config), unless they reveal something real. Test: would a senior ML researcher say "interesting, I want to ask about that"? If yes, include.

**C2. Concerning gaps or red flags**
Gaps that affect interpretation of results or the candidate's reasoning: unfair baselines, missing leakage controls, misinterpreted labels, no validation set, conclusions that don't account for the candidate's own evidence. **Skip minor reporting nits** unless they materially change what the reviewer should think of the work. If the gap is already captured in an A/B item, only repeat it here when C is making a broader point about it that the rubric item can't carry alone.

## Output format

Write the review to the current directory:

```markdown
# Solution review — <candidate name>

**Submission:** <path>
**Reviewed:** <date>
**Reviewer:** /solution-review skill

## Summary
<Up to ~4 sentences, OR a short bulleted lead (2–4 bullets) followed by 1–2 sentences if the points are distinct enough that prose runs them together. Where is the candidate strong, where are they thin? Default skeptical — a pretty-ok solution gets a pretty-ok summary, not a flattering one. No hire/no-hire, no numeric score.>

## A. Report content

### A1. Data exploration & bucket choice — <status> — <one-phrase choice, if applicable>
*Notes: ≤ 2 sentences, with at most one report ref and one code ref inline.*

[…A2–A8 in the same compact form…]

## B. Code & results

### B1. Result artifacts — <status>
*Notes: main artifacts + categories covered, 1 example per category. Call out absences. Don't enumerate.*

### B2. Code quality — <status>
*Notes: ≤ 2 sentences.*

### B3. Training pipeline soundness — <status>
*Notes: ≤ 2 sentences.*

## C. Cross-cutting

### C1. Strong unexpected choices
- <broad research/engineering signal only — 2–4 bullets max>

### C2. Concerning gaps or red flags
- <gaps that matter for interpretation — 2–4 bullets max>

## Open question suggestions for the interview
<2–5 probes, tailored to this specific solution: surprising choices, under-discussed decisions, apparent implicit assumptions.>
```

## Rules

- **Skeptical but fair.** A pretty-ok solution gets a pretty-ok review; strong work gets plain acknowledgement. Describe concretely instead of reaching for superlatives. `✓ Addressed` is a real bar.
- **Be terse.** This is an intro for the reviewer, not their review. Cut anything that doesn't earn its place.
- **Don't recap.** Each fact has one home. If it's in A or B, it doesn't repeat in C unless C is making a broader point. Same for open-question suggestions — probe, don't digest C2.
- **One report ref + one code ref max per item**, inline in Notes, and only when they sharpen the point.
- **No numeric scoring** ("7/10", "B+"). Status markers + prose only.
- **No hire/no-hire verdict.** The hiring manager makes the call.
- **"Mentioned" ≠ "addressed."** Stating a choice isn't engagement. Use `~ Mentioned` for the gap.
- **Be generous about alternatives.** Strong, well-reasoned divergence from the rubric earns `↻ Alternative`.
- **Filter C aggressively.** Broad research/engineering signal only — skip coding-agent boilerplate and reporting nits.
- **Don't grade for things outside the spec.** ~4 hours, no SOTA, 50% accuracy is a stretch. Don't ding for "low" accuracy or missing features that would take days.
- **Read the actual files.** Don't infer code from filenames; don't summarise a report from its abstract.
