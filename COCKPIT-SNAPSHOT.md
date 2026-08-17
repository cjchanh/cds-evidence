# Cockpit Snapshot — the one screen

The cockpit (the status page rendered by the single canonical reducer) is the entire system
state as a human reads it. Below is the **live render from the production branch immediately
after the golden-path code was merged** (2026-08-17 18:42Z, quoted from the merge receipt's
verification block), followed by a line-by-line reading.

```text
WHERE YOU STAND — 2026-08-17 18:42 UTC
NEEDS YOU: 4
  (includes one real dead-letter inbox item)
COCKPIT (canonical task-state reducer):
  READY=33   BLOCKED=124   COMPLETED TODAY=2   NEEDS YOU (tasks): live
  system state digest: 33e32d9157fc
  test suite: 51 passed in 2.74s (live branch)
```

## How to read each line

- **NEEDS YOU** — everything parked awaiting a human decision: dead-letter inbox rows
  (tasks that exhausted their attempt budget) plus operator-gated actions. Nothing in this
  row resolves itself; nothing outside it needs a human.
- **READY / BLOCKED** — tasks available to run vs held (missing input, quarantine sidecar,
  unresolved dependency). BLOCKED is a *visible, receipted* state, never a silent skip.
- **COMPLETED TODAY** — tasks closed through the closure gate today with evidence stamps.
  (The "2" here were canary drill closes — see Honest Limits in EVIDENCE-BUNDLE §4.)
- **System state digest** — a SHA-256 digest over the entire reduced task list. Re-render
  the page anywhere, any time: same input, same digest, same answer.

## Companion proof — five consumers, one snapshot, one verdict

Before the merge, five independent status consumers were compared against one frozen snapshot
of the live queue (`20260817T054945Z-same-snapshot-live-AGREE.json`):

| Field | All five consumers returned |
|---|---|
| Spec files counted | 200 |
| Labeled READY | 70 |
| Quarantined-READY (held) | 37 |
| Runnable | 33 |
| Counting-definition digest | `7a770aae7e5c…` (identical ×5) |

Receipt verdict: **`AGREE`** · `disagreements: []` · `consumer_count: 5`.

*Note for careful readers:* the AGREE snapshot (READY=70) and the post-merge cockpit render
(READY=33) cover **different directory scopes at different times** — the AGREE proof ran against
the full working queue; the post-merge render ran against the live branch's reduced scope.
Within any single snapshot, all consumers agreed; across snapshots, each page prints its own
derivation next to its own numbers. Divergent numbers with hidden derivations were the "before"
state (34 vs 69 vs 71 READY); same numbers with printed derivations are the "after."
