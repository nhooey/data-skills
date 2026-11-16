---
name: data-hygiene-figures-from-queries
description: |
  Every count, sum, rate or percentage you state comes from a command run
  on the data just now, which the reply names or shows, along with when
  the data is from. Never from memory, a skim of output, or counting lines
  that look alike. Covers counting the field that means what you claim (a
  run that finished is not a run that succeeded), recounting after the
  data changes, and saying "about" only for an estimate you call an
  estimate. Use whenever a reply, report, commit message, PR or status
  update states how many, how much or what share: results of a batch of
  jobs, test or CI outcomes, rows, files, errors, users.
---

# data-hygiene-figures-from-queries

_A number you state is the output of a command you ran on the data, named in the reply, with the time the data is from._

A figure reads as fact. One taken from a skim, from memory or from lines that look alike is a guess that looks like a fact, and the reader acts on it.

## The rules

1. **Run a command for every figure.** Count, sum or divide with a command on the data (`wc -l`, `jq`, `duckdb`, `grep -c`, a SQL query) at the moment you state it. Not from memory of an earlier run, not from scrolling output, not by counting lines by eye.
2. **Name or show the command.** Put it beside the figure, or in a line under it, so the reader can rerun it: "9 succeeded (`jq '[.[] | select(.status == "ok")] | length' summary.json`)".
3. **Say when the data is from.** The file's modification time, the query time, or the run it covers: "as of 14:05, wave 3's summary file".
4. **Count the field that means what you claim.** Find the field or line that records the outcome you are reporting, not one that happens to occur once per item. A run that _finished_ is not a run that _succeeded_: a wave's 43 "run ok" log lines meant 43 runs exited, while its summary file said 9 ok and 34 nothing-to-do. When two sources disagree, report the one that records the outcome and say they differ.
5. **Recount after the data changes.** A figure is good until the data under it changes: a rerun, a retry, more rows, a fix. State the new figure from a new command, not the old one adjusted by hand.
6. **"About" means an estimate, and you say so.** Use "about" or "roughly" only for a figure you estimated, and say it is an estimate and from what ("about 2,000 rows, estimated from the file's size and a 100-line sample"). A counted figure is stated exactly.

## Before stating a figure

- Which command produced it, and is it in the reply?
- Does the field counted mean what the sentence claims?
- Has the data changed since the command ran?

## When to apply

- Reporting outcomes of a batch: jobs, runs, waves, test suites, CI checks, migrations.
- Stating counts, totals, rates or percentages of rows, files, errors, users or anything else in a reply, report, commit message or PR.
- Summarising another agent's or tool's output that contains figures.

## Your preferences

!`cat "${CLAUDE_SKILL_DIR}/../data-hygiene-figures-from-queries.preferences.md" "${CLAUDE_PROJECT_DIR}/.agents/skills/data-hygiene-figures-from-queries.preferences.md" 2>/dev/null || true`

If your agent doesn't run the line above, read these files yourself if they
exist: `data-hygiene-figures-from-queries.preferences.md` next to this skill's folder, then
`.agents/skills/data-hygiene-figures-from-queries.preferences.md` in the project. A project's
file overrides the user's, and the user's overrides this skill's defaults.

## Related skills

When one of these applies and it's in your skill listing, load it
without asking. If it isn't in your listing, tell the user which skill is
missing and ask whether to install it from the same collection this skill
came from; don't apply it from memory.

- `data-workflow-query-with-duckdb`: the query that produces a figure from CSV, JSON or Parquet files.
- `data-hygiene-measure-before-concluding`: figures that compare two options' speed, size or cost.
- `data-hygiene-dated-sourced-prices`: prices and specs, which carry a source and a date the same way.
