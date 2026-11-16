---
name: data-hygiene-dated-sourced-prices
description: |
  Each price, spec or availability in a buying catalogue, product
  comparison or shopping list carries its source link, its currency as an
  ISO 4217 code, and the date it was read; a converted price also shows
  the exchange rate and that rate's date. An entry older than the
  catalogue's own refresh period, or 30 days by default, is marked stale,
  not silently kept. Never invent a price or spec to fill a cell. Use when
  writing or updating a buyer's guide, a product or plan comparison, a
  shopping list, a quote or any table of prices, specs or stock.
---

# data-hygiene-dated-sourced-prices

_Every price, spec and stock status says where it came from, in which currency, and when it was read._

Prices and stock change weekly, specs vary by model year and region, and a figure without a source or date can't be checked or refreshed. A reader buying from the list needs to know which numbers are current.

## The rules

1. **Source link per entry.** Each price, spec or availability links to the page it was read from: the seller's product page, the manufacturer's spec sheet. Not the search that found it.
2. **Currency as an ISO 4217 code.** `USD 129.00`, `EUR 119.00`, `THB 4,590`. A bare `$` could be several currencies.
3. **Date read.** Each entry carries the date it was read, in ISO 8601 (`2026-11-16`), in its own column or beside the value.
4. **Converted prices show the rate.** A price converted to another currency keeps the original and shows the rate and its date: "EUR 119.00 (≈ USD 128.50 at 1.0798, 2026-11-16)".
5. **Mark stale entries.** An entry older than the catalogue's own refresh period, or 30 days when it has none, is marked stale (for example "⚠️ stale, read 2026-09-02") until someone rereads it. Don't drop the mark when copying the entry forward.
6. **Never invent a value.** A price, spec or stock status the source doesn't give is written as "—" or "not listed", with the source checked. A plausible guess in a cell is a fabrication.

## When to apply

- Writing or updating a buyer's guide, catalogue, shopping list or quote.
- Comparing products, plans or services on price, spec or availability.
- Copying prices or specs from one document into another.

## Your preferences

!`cat "${CLAUDE_SKILL_DIR}/../data-hygiene-dated-sourced-prices.preferences.md" "${CLAUDE_PROJECT_DIR}/.agents/skills/data-hygiene-dated-sourced-prices.preferences.md" 2>/dev/null || true`

If your agent doesn't run the line above, read these files yourself if they
exist: `data-hygiene-dated-sourced-prices.preferences.md` next to this skill's folder, then
`.agents/skills/data-hygiene-dated-sourced-prices.preferences.md` in the project. A project's
file overrides the user's, and the user's overrides this skill's defaults.

## Related skills

When one of these applies and it's in your skill listing, load it
without asking. If it isn't in your listing, tell the user which skill is
missing and ask whether to install it from the same collection this skill
came from; don't apply it from memory.

- `writing-hygiene-tables-for-comparison`: shaping the comparison as a table, with every cell filled and none invented.
- `data-hygiene-figures-from-queries`: figures computed from the catalogue (totals, averages) come from a command on it.
