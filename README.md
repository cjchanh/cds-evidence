# README — Public Evidence Bundle (Golden-Path Night, 2026-08-17)

**What this is:** a sanitized exhibit from Centennial Defense Systems (CDS), a one-person
defense-adjacent software shop, supporting a fund application. It documents the night a
multi-agent AI engineering toolchain was proven to catch its own failure modes mechanically —
every catch recorded as an append-only receipt file with a machine-decided verdict.

**Contents**

| File | What it is |
|---|---|
| `EVIDENCE-BUNDLE.md` | The narrated exhibit: the eight catches, each with its receipt's verdict fields, plus the five canary drills and stated limits. Start here after this README. |
| `COCKPIT-SNAPSHOT.md` | The one-screen system state and how to read it, plus the five-consumer agreement proof. |
| `README.md` | This file. |
| `SHA256SUMS` | SHA-256 checksums of the three files above. |

## What a stranger should verify first

1. **Integrity of the bundle itself:**
   ```sh
   shasum -c SHA256SUMS        # macOS
   sha256sum -c SHA256SUMS     # Linux
   ```
   All three files must verify. If any fails, what you are reading is not what was published.
2. **Internal consistency (no tools needed):** the verdict strings quoted in
   `EVIDENCE-BUNDLE.md` (`FAIL empty_diff_hollow_pass`, `AUTHORITY_PROVENANCE_AMBIGUOUS ->
   AUTHORITY_PROVENANCE_DIRECT`, `AGREE`, `disagreements: []`) should appear identically in the
   receipts and snapshots when cross-referenced — including the deliberate *self-corrections*
   (§4 of the bundle lists real limits; Catch 6 records two of the author's own claims being
   false until a fix landed). A bundle with no recorded limits should be trusted less, not more.
3. **Against the receipts directory (when published):** the source is an append-only receipts
   directory (`~/.governance/receipts/system-audit/c-wave-20260817/`, ~20 files, plus the
   session closeout). Receipts are never edited — corrections arrive as *new* receipts that
   supersede old ones by name (see the containment → resolution pair in Catch 8). Verify any
   quoted verdict against the named receipt file.
4. **Against git history (when published):** commit IDs cited in the bundle (`ecc8960e`,
   `b9fa3ff7`, `9f18aba8`) live in the source repository's history and can be resolved there.

## How the hash chain works

Three layers, each answering a different question:

1. **Per-task state digests — "is this the same task truth?"** The reducer computes a SHA-256
   digest over a task's full canonical record (status, attempts, evidence links, timestamps).
   Query the same task ID from two independent entry points and the digests must be
   byte-identical — proven for all five canaries (`all_digests_match: true`). A digest match is
   proof the two surfaces read one underlying state, not two copies drifting apart.
2. **Definition digests — "is everyone counting the same way?"** Each status-counting consumer
   hashes the counting *definition* it uses. In the same-snapshot proof, five consumers
   returned one identical definition digest — the same guarantee at the system level, and the
   receipt's verdict field is `AGREE` with an empty disagreement list.
3. **Bundle checksums — "is this document what was published?"** `SHA256SUMS` fixes the exact
   bytes of the three exhibit files. This is the outermost link: it protects the *evidence
   about the evidence*.

Chain property: a change anywhere inside a layer changes its digest; a changed receipt or task
record is detectable without trusting any narrator.

## The design rule this night proved

> **Enforcement keyed to artifact EXISTENCE survives merges, rebases, and reverts.
> Enforcement keyed to a FIELD INSIDE a merged file silently disarms.**

The incident (Catch 7): a guard quarantined a spec two ways — by rewriting a status field inside
the file, and by dropping a `.quarantine` sidecar file next to it. A later git merge brought
back the file's older revision, silently reverting the field to "READY." Every enforcement
point had been built to check the **sidecar's existence** instead of reading the field, so the
hold never lapsed — the system reported the task BLOCKED *while the file said READY*, and the
guard re-stamped the field on its next pass.

General form, for anyone building gates on top of version control: version-control operations
can rewind the *contents* of tracked files, making any check that parses a mutable field inside
them disarmable without anyone noticing. A check for the **presence of a separate artifact**
(a sidecar, a patch file, a review receipt) cannot be silently reverted by the same operation,
because the artifact is not part of the rewound content. Build gates that look for files, not
for fields.

## Sanitization disclosure

Removed for public safety: home-directory path prefixes (shortened to `~`), vendor and model
identifiers, gateway/broker details, process IDs, and account states. Preserved because they
are the substance: gate mechanics, receipt filenames, verdict fields (quoted verbatim),
task IDs, commit IDs, and digest prefixes. No verdict was reworded; abstraction was applied
only to *how the lanes are named*, never to *what the gates decided*.
