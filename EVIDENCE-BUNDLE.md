# Evidence Bundle — The Golden-Path Night (2026-08-17)

**Centennial Defense Systems (CDS)** · Founder-operated, single-person engineering shop running a
multi-agent AI toolchain.
**Source:** append-only receipts directory `~/.governance/receipts/system-audit/c-wave-20260817/`
(to be published alongside this bundle) + the session closeout
`~/Documents/Centennial/audits/2026-08-17-golden-path-closeout.md`.
**Sanitization:** host paths shortened to `~`; vendor/model identifiers, process IDs, and gateway
details removed. Gate mechanics and verdict fields are quoted verbatim — they are the point.

---

## 0. Plain-language glossary (read this first)

| Term | One-line definition |
|---|---|
| **Receipt** | An append-only JSON or Markdown file an automated gate writes when it acts; it cannot be edited after the fact, only superseded by a newer receipt. |
| **Verdict** | The machine-decided outcome field of a receipt (`PASS` / `FAIL` / `BLOCKED` / `NEEDS_OPERATOR`); never a human's self-assessment. |
| **Canary** | A deliberate drill that injects a known fault to prove the guardrail catches it. |
| **Ledger** | The append-only file that owns task-ID allocation; a task ID exists because the ledger says so. |
| **Digest** | A SHA-256 hash over a task's full canonical record; identical digests from two entry points = the same underlying truth. |
| **Reducer** | The single program that folds all raw state into one canonical task list and one system digest. |
| **Cockpit** | The one-screen status page rendered from the reducer (see `COCKPIT-SNAPSHOT.md`). |
| **Dead-letter inbox** | Where tasks that exhausted their attempt budget park until a human decides. |
| **Quarantine sidecar** | A marker file placed next to a spec to hold it out of execution; enforcement reads the marker's *existence*. |
| **Worktree** | An isolated checkout of the repository where workers build changes without touching the main tree. |
| **Lease** | A time-boxed, single-writer permit to operate on a defined scope. |
| **ZDR (zero data retention)** | A model-lane property meaning submitted content is not stored by the provider; a lane *without* it is an egress risk. |

---

## 1. What this night was

**Before (2026-08-16 audit):** four status readers disagreed on the same queue (34 vs 69 vs 71
"READY"), captured work landed in a 17,000-line backlog file nothing consumed, ~388 of 1,186
"done" items were closed without an evidence stamp, and a worker's own claim of success could pass
as closure. Trust score: **3.4/10**.

**After (this wave):** one capture path → one ledger-allocated task ID → one spec queue → a
contained factory execution → receipts → an independent review gate → one closure gate → one
reducer → one cockpit. Every step refuses, receipts, or escalates mechanically.

**Two headline proofs anchor the night:**

1. **Five canaries, all caught or completed as designed** (drill table in §2).
2. **Same-snapshot agreement:** five independent status consumers were compared against one
   frozen snapshot of the live queue — all five returned identical counts and an identical
   definition digest. Receipt verdict: **`AGREE`**, `disagreements: []`, `consumer_count: 5`
   (`20260817T054945Z-same-snapshot-live-AGREE.json`).

**Then the system was left running — and eight real things happened.** Five were live incidents;
three were the canary drills whose verdict receipts prove the guardrails fire on their own. Each
catch below names its receipt and quotes its verdict fields.

---

## 2. The five canary drills (fault injection, 2026-08-17 ~06:2x–06:39Z)

| # | Drill | Task | What the machine did | Final state (digest, two entry points) |
|---|---|---|---|---|
| 1 | Cross-surface identity | 2622914 | Capture → one canonical ID via the real ledger; duplicate capture refused (`DUPLICATE dedupe_of=…`) | `VERIFIED_COMPLETE` · `56f5b0d8f1e4` ×2 |
| 2 | Normal factory build | 2622914 | Real model worker in a detached-worktree containment; bounded 2-file patch; dispatcher re-ran the acceptance commands itself (rc=0); independent other-family review; closed at review level L2 | `VERIFIED_COMPLETE` · `56f5b0d8f1e4` ×2 |
| 3 | Hollow-pass rejection | 2622915 | Worker printed "SHIP"; diff was empty → dispatcher verdict **`FAIL` `empty_diff_hollow_pass`** (14.1s) | `READY` · `c19379234f99` ×2 |
| 4 | Interruption + recovery | 2622916 | Killed mid-run; in-flight marker preserved; plain retry refused (**`BLOCKED`** stale-inflight); explicit `--recover discard` → exactly one PASS receipt, one queue entry | `VERIFIED_COMPLETE` · `a24f21285370` ×2 |
| 5 | Retry + escalation | 2622917 | Acceptance impossible by design; FAIL → budget 2/2 → **`NEEDS_OPERATOR`**; parked on attempt 3; dead-letter inbox row + cockpit row appeared in step | `NEEDS_OPERATOR` · `12422db55698` ×2 |

Full per-canary receipt lists and dual-entry digests: `canary-evidence.json`
(`all_digests_match: true`).

---

## 3. The eight catches

Each catch names the receipt a stranger can read (paths below are inside the receipts directory;
see README §Verify for how to check them).

### Catch 1 — A hollow success claim was rejected mechanically
**Receipt:** factory-dispatch `20260817T063447Z-2622915-FAIL.json` (drill).
A worker declared success ("FACTORY_RESULT: SHIP") but produced an **empty diff**. The dispatcher
did not read the claim — it compared the tree before and after, found nothing, and ruled:
verdict **`FAIL`**, reason **`empty_diff_hollow_pass`**, attempt 1/2. The task returned to
`READY`, not "done". *Why it matters: an AI asserting success is never evidence; the delta is.*

### Catch 2 — A killed run recovered with zero duplicates and zero false closures
**Receipt:** factory-dispatch `20260817T063544Z-2622916-BLOCKED.json` (drill).
A dispatch was killed mid-run. The in-flight marker survived the kill; a naive re-dispatch was
refused (**`BLOCKED`** — stale in-flight; recovery state deliberately not destroyed); an explicit
`--recover discard` cleared it, and the rerun produced exactly **one `PASS` receipt and one queue
entry**. *Why it matters: interruption cannot manufacture duplicate tasks or phantom completions.*

### Catch 3 — A doomed task escalated to a human instead of looping forever
**Receipt:** factory-dispatch `20260817T063800Z-2622917-NEEDS_OPERATOR.json` (drill).
Acceptance was impossible by construction. Attempt 1 **`FAIL`**; attempt 2 exhausted the budget
(2/2) → verdict **`NEEDS_OPERATOR`**; attempt 3 was refused (parked). A dead-letter inbox row,
a worker-result receipt, and a cockpit "NEEDS YOU" row all appeared together. *Why it matters:
failure terminates in a parked, visible state — never a silent retry loop.*

### Catch 4 — A live ID collision between two concurrent sessions was caught and adjudicated by ledger provenance
**Receipt:** `20260817T1839Z-2622903-collision-adjudicated.md`.
Two sessions filed different specs under the same seven-digit ID (**2622903**) — a real
concurrency incident, not a drill. The adjudication receipt records the decision: *"Ledger
provenance of 2622903 stays with the canonical-task-state-reducer spec. The later-filed
stamp-writer spec was re-ided to 2622919."* The reducer then confirmed the fix live:
`find: unique`. Root cause (a rule that lived in a document but had no committed caller in the
runtime) was itself receipted and queued for fix. *Why it matters: identity is owned by an
append-only ledger, not by filename inspection — and collisions surface instead of silently
overwriting.*

### Catch 5 — Commit authority of ambiguous provenance was frozen, then ratified
**Receipt:** `20260817T190000Z-ratification-ecc8960e.json`.
The authorizing instruction for commit `ecc8960e` had arrived at the tail of a large pasted
transcript — a human could not be sure it was typed intent vs paste artifact. Post-commit
forensics ruled the file scope **`COMMIT_SCOPE_CLEAN`** (18 files exact) but the authority
**`AUTHORITY_PROVENANCE_AMBIGUOUS`**, and placed a **`HOLD`** on the merge. The operator then
re-issued the instruction as a direct, standalone message; the ratification receipt records:
`"resolves": "AUTHORITY_PROVENANCE_AMBIGUOUS -> AUTHORITY_PROVENANCE_DIRECT"`. *Why it matters:
the system distinguishes "the change is correct" from "the change was authorized" — and refuses
to proceed on the second until it is proven, even after the first is.*

### Catch 6 — A test fixture leaked into the real operator inbox; the fix was landed and proven closed by hash
**Receipt:** `20260817T203000Z-rigfix-landed.json`.
The factory test rig failed to isolate its environment, so a budget-exhaustion test wrote its
fixture row into the **real** operator inbox. The fix (test-rig isolation) was committed on the
work branch and landed on the live branch as an exact cherry-pick — a literal merge would have
dragged an unratified neighboring commit. Proof quoted from the receipt's `gate5_proof`:
inbox file SHA-256 **byte-identical before/after** a full 51-test run (`d40af1583bb0…` both
sides), zero fixture rows, verdict **"contamination vector CLOSED on the live branch."** An
external review then caught that the pre-fix suite had re-leaked the row once more — which the
closeout records as two of its own claims being false until the fix landed. *Why it matters:
the boundary between test and production is enforced and provable by digest, and the narrative
corrects itself against receipts.*

### Catch 7 — A git merge silently reverted an in-place quarantine stamp; the enforcement survived anyway
**Receipt:** `20260817T194500Z-merge-b9fa3ff7.json` (field `correction_20260817T1955Z`).
A scope guard had quarantined a spec by rewriting its status field in place — and by dropping a
`.quarantine` **sidecar** file next to it. The subsequent merge imported the older file revision,
silently reverting the field to `READY`. The hold survived regardless, because **every
enforcement point keys on the sidecar file's existence, not the field**: the orchestrator skips
the spec, the survey excludes it, and the reducer reported it `BLOCKED` / reason "quarantine
sidecar" *while the file itself said READY*. The guard later re-stamped the field on its own
tick — the field self-heals; the existence check never blinked. This produced the design rule
documented in the README. *Why it matters: it is a demonstrated, receipted case of a gate
surviving a version-control operation that would have silently disarmed a field-reading gate.*

### Catch 8 — An out-of-scope cloud egress was contained, root-caused, and rerouted
**Receipts:** `20260817T205500Z-egress-incident-containment.json` +
`20260817T213000Z-egress-incident-resolved.json`.
The legacy dispatch engine sent a spec that (a) declared no cloud-egress permission and (b)
targeted a repository outside the active lease's scope — to a free-tier cloud model lane that
carries the routing table's only data-retention carve-out, with permission-skip flags set.
Containment was **reversible by design**: quarantine sidecars placed on 10 out-of-scope specs
(one command releases them); the already-running workers were *not* killed (process control is
operator-gated). Root cause found in the model routing table: eight route slices fell back to
that non-ZDR lane because their primaries were blocked by a stale gate; all fallbacks were
corrected to a retention-compliant lane, five sidecars released, five kept pending a permanent
guard. The re-fired task then completed with exit 0 — and produced **zero tree changes and zero
receipts**: the exact "unreceipted-exit-0" class the new factory + closure gates exist to make
impossible. Recorded as evidence; no unauthorized fix of the legacy lane attempted. *Why it
matters: egress is treated as a security boundary with fail-closed holds, reversible
containment, and root-cause repair — and the incident itself became the argument for the new
architecture.*

---

## 4. Honest limits (stated, not hidden)

- Two executor profiles were logged-out/balance-blocked that night; canaries ran on the pinned
  local profile through identical containment.
- The wave's own governing specs were closed outside the new closure contract — the wave
  predates its own contract; this is receipted.
- Canary ("drill") completions were counted in the cockpit's "COMPLETED TODAY" row until a
  drill namespace was queued.
- The legacy dispatch lane still permits unreceipted exit-0 runs (Catch 8) — migration to the
  factory route is the queued fix, not a completed one.
- Commit SHAs referenced here (`ecc8960e`, `b9fa3ff7`, `0ab43b30`→`9f18aba8`) live in the
  source repository's history; they become independently checkable when that history is
  published.

## 5. One-line summary

A one-person shop ran an agent toolchain through a night of drills and live incidents, and every
failure mode — hollow claims, killed runs, runaway retries, ID collisions, ambiguous authority,
test-to-production leaks, merge-reverted stamps, and out-of-scope egress — was caught by a
mechanical gate that wrote a receipt saying so. **It doesn't answer. It testifies.**
