# Design rule this exhibit demonstrates

> **Enforcement keyed to artifact EXISTENCE survives merges, rebases, and reverts.
> Enforcement keyed to a FIELD INSIDE a merged file silently disarms.**

The incident (Catch 7 in `EVIDENCE-BUNDLE.md`): a guard quarantined a spec two ways — by rewriting a status field inside the file, and by dropping a `.quarantine` sidecar file next to it. A later git merge brought back the file's older revision, silently reverting the field to "READY." Every enforcement point had been built to check the **sidecar's existence** instead of reading the field, so the hold never lapsed — the system reported the task BLOCKED *while the file said READY*, and the guard re-stamped the field on its next pass.

General form, for anyone building gates on top of version control: version-control operations can rewind the *contents* of tracked files, making any check that parses a mutable field inside them disarmable without anyone noticing. A check for the **presence of a separate artifact** (a sidecar, a patch file, a review record) cannot be silently reverted by the same operation, because the artifact is not part of the rewound content. Build gates that look for files, not for fields.
