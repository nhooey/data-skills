---
name: data-workflow-query-with-duckdb
description: |
  Answer an ad-hoc question about CSV, JSON, NDJSON or Parquet files with
  one DuckDB SQL query (`duckdb -c "…"` or a `.sql` file), not a throwaway
  Python script; `jq` stays fine for one field of one JSON document. Show
  the query with its answer. A query run twice becomes a named command in
  the project. Where the project uses Nix, DuckDB comes from the dev
  shell, never a global install. Use when about to count, filter, group,
  join or summarise data in files: logs, run summaries, exports, test
  results, CSV reports.
---

# data-workflow-query-with-duckdb

_A question about data in files is one DuckDB query, shown with its answer._

DuckDB reads CSV, JSON, NDJSON and Parquet directly, infers their columns, and answers in one declarative statement. A throwaway Python script for the same question is longer, hides the logic in loops, and is easy to get subtly wrong (a missed header row, a string compared as a number). A SQL query is short enough to show and check at a glance.

## The rules

1. **One query, not a script.** Count, filter, group, join or summarise with `duckdb -c "…"`, or with a `.sql` file for a longer query:

   ```sh
   duckdb -c "SELECT status, count(*) FROM 'runs/*.json' GROUP BY status ORDER BY 2 DESC"
   ```

   Read files by path or glob: `'data.csv'`, `'logs/*.ndjson'`, `read_json('x.json', format = 'array')`, `'data.parquet'`.
2. **`jq` for one field of one document.** Pulling `.version` out of one `package.json` is a `jq` job. Anything across many records or files, or with grouping, is a query.
3. **Show the query with its answer.** Put the SQL in the reply next to the result, so the reader can check what was counted and rerun it.
4. **A query run twice becomes a command.** When the same question will come up again, commit the query as a named command in the project, as `shell-hygiene-commands-as-cli-tools` says, rather than pasting it from reply to reply.
5. **DuckDB from the dev shell.** Where the project uses Nix, add `duckdb` to the dev shell's packages and run it from there. Don't install it globally with `brew`, `pip` or `nix profile`; the project's dev shell is what others and later sessions will have.

## When to apply

- About to write a Python, Node or shell script to answer a question about data in CSV, JSON, NDJSON or Parquet files.
- Counting or summarising logs, run results, exports or reports.
- A question needs a join or group across several files.

## Your preferences

!`cat "${CLAUDE_SKILL_DIR}/../data-workflow-query-with-duckdb.preferences.md" "${CLAUDE_PROJECT_DIR}/.agents/skills/data-workflow-query-with-duckdb.preferences.md" 2>/dev/null || true`

If your agent doesn't run the line above, read these files yourself if they
exist: `data-workflow-query-with-duckdb.preferences.md` next to this skill's folder, then
`.agents/skills/data-workflow-query-with-duckdb.preferences.md` in the project. A project's
file overrides the user's, and the user's overrides this skill's defaults.

## Related skills

When one of these applies and it's in your skill listing, load it
without asking. If it isn't in your listing, tell the user which skill is
missing and ask whether to install it from the same collection this skill
came from; don't apply it from memory.

- `shell-hygiene-commands-as-cli-tools`: turning a query run twice into a named, tested command in the project.
- `data-hygiene-figures-from-queries`: every figure stated comes from a command like this one, named with the time of its data.
