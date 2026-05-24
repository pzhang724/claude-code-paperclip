# Clinical AI Agent — Demo Replays

## What this is

A small R Shiny app that replays pre-recorded AI agent sessions for clinical
domain experts. The replays show an AI agent searching FDA documents, clinical
trials, and the biomedical literature, then synthesizing what it found. The app
exists so reviewers can experience the workflow without installing anything,
signing up for anything, or holding any API keys.

## Who it's for

Clinical statisticians, medical writers, regulatory-affairs staff, and clinical
operations. People who would benefit from seeing what an agent-driven literature
search looks like in practice but whose day job is not engineering.

## Try it

The deployed app is at: **[https://your-org.connect.posit.cloud/clinical-agent-replays](https://your-org.connect.posit.cloud/clinical-agent-replays)** *(placeholder — update once published)*.

## What's actually happening

Each session in the sidebar is a pre-recorded JSON transcript on disk.
When you press **Play**, the app streams the recorded events — agent thoughts,
tool calls, tool outputs, and the final synthesis — back to you at human-readable
pace. The app does not call any LLM API at viewing time. It is a replay viewer,
not an agent.

The sessions themselves were originally generated using
[Paperclip](https://paperclip.gxl.ai), an agent-native CLI for the biomedical
literature, in combination with [Claude Code](https://www.anthropic.com/claude-code).
The transcripts in this repo are illustrative; the underlying recording workflow
runs separately.

## Add your own sessions

Each session is a single JSON file in `transcripts/`. The schema is documented
by example in [`transcripts/01-estimand-trend.json`](transcripts/01-estimand-trend.json),
and the field list at the top (`id`, `title`, `subtitle`, `audience_tags`,
`estimated_duration_seconds`, `metadata`, `events`) is required. Events are
a flat array with these `type` values:

| `type` | Notes |
| --- | --- |
| `user_query` | The reviewer's question (rendered at top) |
| `agent_thought` | Free-form narration; typewriter effect |
| `tool_call` | Has `tool_name` and `args` |
| `tool_output` | Has `content` and optional `format: "code"` |
| `final_synthesis` | Markdown body, rendered as the closing answer |
| `pause` | Visual breather; `delay_ms` only |

Each event takes an optional `delay_ms` (the wait *before* it renders);
default is 500 ms.

To record a new session:

1. Run your investigation with Paperclip and Claude Code.
2. Convert the trace to the schema above. (A trivial way: keep a structured
   journal as you go, or write a script that walks the Claude Code session log.)
3. Drop the file into `transcripts/`.
4. Add an entry to `transcripts/_index.json` so it appears in the picker.
5. Redeploy.

## Run locally

```r
renv::restore()
shiny::runApp()
```

This requires R ≥ 4.2. Dependencies are pinned in `renv.lock`.

## Deploy to Posit Connect Cloud

1. Push this repo to GitHub.
2. Sign in to [Posit Connect Cloud](https://connect.posit.cloud) (free public tier).
3. Choose **Publish → Shiny** and point at the GitHub repo.

Connect Cloud reads `renv.lock` and builds a clean container. No keys, no
secrets, no configuration.

## Disclaimer

The seed transcripts in this repository are illustrative. NCT numbers, BLA / NDA
numbers, document IDs, reviewer quotes, and trial statistics may be fictional
or composite. **Do not cite these demos as primary sources.** For real
regulatory or clinical-development work, retrieve the underlying documents
directly from the FDA, ClinicalTrials.gov, or the published literature.
