# Pipeline — Operational Detail

Reference for operators running the Equipment Manifest pipeline. The README
covers the "why"; this is the "how it actually behaves."

## Message flow, tick by tick

Each cron tick (default `0 */2 * * *`):

1. **Cursor read.** `manifest_last_check.txt` holds the ISO UTC timestamp of
   the last successful sweep. If the file is empty/missing, the agent writes
   *now* and stops — the first run after installation never replays inbox
   history.
2. **Thread list.** AgentMail MCP `list_threads` with the `after` filter
   (the REST API has no `after` support — MCP is mandatory for polling).
   Limit 20, ascending.
3. **Subject gate.** Only threads whose subject contains
   `CREATE MANIFEST` (case-insensitive) are candidates. `CREATE HIRA`
   belongs to the sibling HIRA pipeline — this job ignores it, and the two
   jobs must never share a cursor file or tracking file.
4. **Dedupe.** Message IDs in `manifest-tracking.txt` are skipped. A thread
   that was `REJECT`ed or never approved stays out of the processed set —
   the ID is only appended after a successful approved send.
5. **Cursor advance.** On every run (work or not), `manifest_last_check.txt`
   is overwritten with now.
6. **Approval check.** If `manifest_pending_approval.txt` exists, the agent
   checks the operator conversation for `APPROVE` / `REJECT`:
   - `APPROVE` → upload the CSV to AgentMail, send the reply, append the ID
     to the tracking file, delete the pending marker.
   - `REJECT` or silence → leave the marker; nothing else happens.

## State files

| File | Purpose | Mutated by |
|---|---|---|
| `manifest_last_check.txt` | poll cursor (ISO UTC) | every tick |
| `manifest-tracking.txt` | processed message IDs (one/line) | after approved send |
| `manifest_pending_approval.txt` | outstanding HITL gate (recipient, subject, folder, output path) | created on draft post, deleted on approved send |
| `ACTIVATION_REGISTER.txt` | append-only audit log: `timestamp \| job \| trigger \| summary` | every processed request |

All live under `$HSE_HOME` (e.g. `~/.hermes/hse/` or a dedicated project
directory). Sibling pipelines keep their own files in the same directory —
never rename or merge them.

## Attachment handling

The AgentMail REST API has no attachment endpoints. The flow is:

1. MCP `get_attachment` → SSE response containing a signed `downloadUrl`.
2. `curl -sL -o <path> <downloadUrl>`.
3. Verify size (`stat -c%s`); files under 1 KB are flagged as probable error
   pages but do not abort (Mode A may still work from the body).
4. Text extraction:
   - PDF → `pymupdf` (`import fitz`)
   - DOCX → `python-docx` (paragraph text)
   - CSV/TXT → copied verbatim
5. The email body is always saved as `email_body.txt` in the project folder
   for audit.

**Safety gate:** downloaded content is validated as subsea/diving/offshore
scope before use. Irrelevant files (personal documents, marketing, anything
non-operational) are skipped, not fed to the generator.

## Output contract

- Filename: `{YYYY-MM-DD-Company-Name}/{YYYY-MM-DD-Company-Name}_Equipment_Manifest.csv`
- Mode A header: `Item,Qty,Notes`; category groups introduced by a
  comma-only row.
- Mode B header: `Category,Item,Qty,Notes`.
- No spaces after commas. No markdown. No annotations in the CSV.
- Notes column blank by default — it is the inspection-result column the
  client fills on site.
- Mode B must include Certifications & Documentation as a first-class
  category.

The draft post to the operator chat always carries: project + folder, work
mode, recipient (from-field only), subject, full email body, the CSV as a
MEDIA attachment, path/size/line count, and the approval request.

## Reply template (as sent)

```
Subject: Equipment Manifest — {PROJECT_NAME} — ConsultingSubsea

Dear {SENDER_NAME},

Thank you for entrusting ConsultingSubsea with the equipment manifest
documentation for the {PROJECT_NAME} ({CLIENT_NAME}).

Please find attached the complete equipment loadout manifest (tick-off
sheet), prepared with reference to your submitted scope of work for
{VESSEL/WORKSITE}.

The manifest is formatted as a raw CSV (Category / Item / Qty / Notes)
ready for direct import into Excel, and covers all project equipment
categories including client-specific mandates and the Certifications and
Documentation deliverables.

If you would like to know more about this documentation or any of our
other services — including project planning, HSE documentation, diving
operations, and offshore project management — contact us at
technical@consultingsubsea.com.

Kind regards,
HSE Documentation Team
ConsultingSubsea
```

Personalize every placeholder from the email's own data. Never reuse
names from example documents.

## Failure modes and behavior

| Situation | Behavior |
|---|---|
| Empty cursor file on first run | seed with now, stop (no backlog replay) |
| No matching subjects | cursor advances, silent |
| Attachment 404 / non-200 | noted, continue if body supports Mode A |
| File < 1 KB | flagged as error page, continue with body |
| No SOW + no named categories | clarification post to operator chat, no manifest fabricated, no cursor-loss (cursor still advances; the thread's subject won't re-match unless re-sent) |
| Sender address not identifiable | skip + log; never guess a recipient |
| `REJECT` | pending marker stays; ID not tracked; re-approval on a later run |
| MCP SSE parse failure | retry once; if still failing, log and advance cursor (poison-thread protection) |

## Running two pipelines side by side (HIRA + Manifest)

The HIRA pipeline (sibling repo `hse-doc-generator`) and this pipeline are
independent jobs on the same inbox. Invariants:

- Distinct subject triggers (`CREATE HIRA` vs `CREATE MANIFEST`).
- Distinct cursors (`last_check.txt` vs `manifest_last_check.txt`).
- Distinct tracking files (`hse-tracking.txt` vs `manifest-tracking.txt`).
- Distinct pending markers.
- Shared `ACTIVATION_REGISTER.txt` is append-only and safe to share —
  entries are prefixed with the job name.

A subject matching neither trigger is ignored by both jobs.

## Local LLM pinning

This deployment runs the cron on a local llama.cpp server
(OpenAI-compatible API, port 8080, Qwen3-27B class model at Q4_K_XL).
Pin the cron explicitly (`hermes cron edit <id> --model <gguf-path>
--provider custom`) — an unpinned agent cron may fall back to a cloud
provider when the local server restarts, and a stale provider reference
fails with HTTP 402/401. Re-verify the pin after any model swap.
