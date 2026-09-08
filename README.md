# cds-evidence

A sanitized exhibit from Centennial Defense Systems: the night a multi-agent engineering toolchain caught its own failure modes in machine-written records.

**Install / example** — clone and check the files:

```sh
git clone https://github.com/cjchanh/cds-evidence.git
cd cds-evidence
shasum -a 256 -c SHA256SUMS        # macOS
# sha256sum -c SHA256SUMS          # Linux
```

All three exhibit files must verify. If any fails, what you are reading is not what was published.

**Refuses:** this repo does not include the private queue or the source records directory. Cockpit counts are a point-in-time snapshot and cannot be re-derived from these files. `SHA256SUMS` only proves the three exhibit files are unmodified.

Rebuild checksums after editing an exhibit file:

```sh
./scripts/regenerate.sh
```

The design rule this night demonstrated lives in [`docs/design-rule.md`](docs/design-rule.md).

## Contents

| File | What it is |
|---|---|
| `EVIDENCE-BUNDLE.md` | The narrated exhibit: the eight catches, each with its record's verdict fields, plus the five canary drills and stated limits. Start here after this README. |
| `COCKPIT-SNAPSHOT.md` | The one-screen system state and how to read it, plus the five-consumer agreement proof. |
| `README.md` | This file. |
| `SHA256SUMS` | SHA-256 checksums of the three files above. |
| `scripts/regenerate.sh` | Rebuilds `SHA256SUMS` from the three exhibit files. |
| `docs/design-rule.md` | Why existence-checks survive merges that field-checks do not. |

## What a stranger should verify first

1. **Integrity of the bundle itself:** `shasum -a 256 -c SHA256SUMS` (or `sha256sum -c SHA256SUMS` on Linux). All three files must verify.
2. **Internal consistency (no tools needed):** the verdict strings quoted in `EVIDENCE-BUNDLE.md` (`FAIL empty_diff_hollow_pass`, `AUTHORITY_PROVENANCE_AMBIGUOUS -> AUTHORITY_PROVENANCE_DIRECT`, `AGREE`, `disagreements: []`) should appear identically when cross-referenced — including the deliberate *self-corrections* (§4 of the bundle lists real limits; Catch 6 records two of the author's own claims being false until a fix landed). A bundle with no recorded limits should be trusted less, not more.
3. **Against the records directory (when published):** the source is an append-only records directory (`~/.governance/receipts/system-audit/c-wave-20260817/`, ~20 files, plus the session closeout). Records are never edited — corrections arrive as *new* records that supersede old ones by name (see the containment → resolution pair in Catch 8). Verify any quoted verdict against the named record file.
4. **Against git history (when published):** commit IDs cited in the bundle (`ecc8960e`, `b9fa3ff7`, `9f18aba8`) live in the source repository's history and can be resolved there.

## How the hash chain works

Three layers, each answering a different question:

1. **Per-task state digests — "is this the same task truth?"** The reducer computes a SHA-256 digest over a task's full canonical record (status, attempts, evidence links, timestamps). Query the same task ID from two independent entry points and the digests must be byte-identical — proven for all five canaries (`all_digests_match: true`). A digest match is proof the two surfaces read one underlying state, not two copies drifting apart.
2. **Definition digests — "is everyone counting the same way?"** Each status-counting consumer hashes the counting *definition* it uses. In the same-snapshot proof, five consumers returned one identical definition digest — the same guarantee at the system level, and the record's verdict field is `AGREE` with an empty disagreement list.
3. **Bundle checksums — "is this document what was published?"** `SHA256SUMS` fixes the exact bytes of the three exhibit files. This is the outermost link: it protects the *evidence about the evidence*. Rebuild it with `./scripts/regenerate.sh`.

Chain property: a change anywhere inside a layer changes its digest; a changed record or task record is detectable without trusting any narrator.

## Sanitization disclosure

Removed for public safety: home-directory path prefixes (shortened to `~`), vendor and model identifiers, gateway/broker details, process IDs, and account states. Preserved because they are the substance: gate mechanics, record filenames, verdict fields (quoted verbatim), task IDs, commit IDs, and digest prefixes. No verdict was reworded; abstraction was applied only to *how the lanes are named*, never to *what the gates decided*.
