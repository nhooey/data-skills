---
name: data-comparison-tables
description: Shape a Markdown comparison of two or more concrete things as one table a reader scans in seconds. Items go in rows, with the first column the item's name linked to its canonical page. The columns are the properties readers expect for the category, and a property earns one only when it is notable, shared by at least half the items and differs between them. Genuinely binary cells are ✅ or ❌ with any qualifier on a `<br/>` line, and properties every item shares, or every item lacks, move to a list under the table. Use when writing or updating a Markdown document that compares products, libraries, services, frameworks, tools, plans or options for a reader deciding between them, such as blog posts, README "alternatives" sections, decision docs, wikis, buyer's guides, "X vs Y" sections.
---

# Comparison tables

_A comparison table lets a reader find the answer in seconds: items in rows, linked names in the first column, binary values as ✅/❌, and only the properties that tell the items apart._

## When to use

- Comparing two or more products, libraries, services, frameworks, tools, plans or options.
- The reader needs to scan and pick, not study each item on its own.

A single item is prose. Put items in columns only as a deliberate exception: two or three items against many properties (six or more, or twenty for two items), where items in rows would make a two-row table ten columns wide.

## Rules

### 1. Items in rows, the first column the linked name

Each item is one row. Its first cell holds its name, linked to the most relevant page: the official site or canonical docs, else the repository, the Wikipedia article or the product page.

Rows let the eye scan one property down a single column ("which is wireless?"); items in columns force reading a label and jumping across. The link puts the canonical page one click away instead of a search.

```markdown
| Framework                                   | …   |
| ------------------------------------------- | --- |
| [Flask](https://flask.palletsprojects.com/) | …   |
| [Django](https://www.djangoproject.com/)    | …   |
| [FastAPI](https://fastapi.tiangolo.com/)    | …   |
```

A name in plain or bold text, linked only in the surrounding prose, or stranded in a column header above an unlinked table, is a defect.

### 2. The columns readers expect

Each category has properties a reader looks for first:

- **Products:** price, license, platforms, use case.
- **Libraries:** language, license, maintenance, runtime size.
- **Services:** free tier, hosting model, pricing.
- **Physical goods:** dimensions, weight, materials, warranty.

Aim for four to eight load-bearing columns. Three informative columns beat ten weak ones.

### 3. Binary cells are ✅ or ❌, a qualifier on a `<br/>` line

A yes/no, supported/unsupported or included/excluded column holds ✅ or ❌. A qualifier ("only on the Pro plan") goes on a `<br/>` line under the symbol.

```markdown
| Keyboard                                     | Wireless                 | Hot-swappable switches | Onboard layers               |
| -------------------------------------------- | ------------------------ | ---------------------- | ---------------------------- |
| [Glove80](https://www.moergo.com/)           | ✅<br/>Bluetooth via ZMK | ✅                     | ✅<br/>10+                   |
| [Moonlander](https://www.zsa.io/moonlander/) | ❌<br/>USB-C only        | ✅                     | ✅<br/>32                    |
| [HHKB Hybrid](https://hhkeyboard.us/)        | ✅<br/>Up to 4 devices   | ❌<br/>Topre, soldered | ❌<br/>DIP-switch modes only |
```

The eye reads a symbol by shape and colour before any word, so a column of ✅/❌ reads at a glance where `Yes`/`No` must be read cell by cell, and the gap widens with the row count. The `<br/>` keeps the symbol leading the cell with the detail still there.

Only a column where every cell is genuinely yes or no gets them: categorical values (a switch type, a license) and numbers (a price, a weight) stay plain text.

### 4. A column per notable, shared, differing property

A property earns a column when all three hold:

- **Notable:** readers care about it for this category.
- **Shared by at least half the items:** a real axis, not a one-off feature.
- **Values differ:** the column separates the items.

A property relevant to only one or two items goes in prose or a footnote; a column of mostly empty or "N/A" cells wastes space.

### 5. Uniform properties in a list under the table

A property with the same value for every item can't help the reader choose, so it moves to a list directly below the table, ✅ columns included. Properties every item lacks go there too: "**None of these:** ship a GUI, support Windows, are open source."

```markdown
| Service                                               | …   |
| ----------------------------------------------------- | --- |
| [GitHub Actions](https://github.com/features/actions) | …   |
| [GitLab CI/CD](https://docs.gitlab.com/ci/)           | …   |
| [CircleCI](https://circleci.com/)                     | …   |

**Shared by all three:** Linux runners, a free tier for public repositories, YAML pipeline configuration, matrix builds, OIDC for cloud-provider authentication.
```

Every column left in the table is then load-bearing, and the fact is still stated.

## Putting it together

A complete comparison has:

1. **One main table:** items in rows, the first column the linked name, binary cells as ✅/❌ with `<br/>` qualifiers, everything else short text.
2. **A "Shared by all" list directly below:** each property true of every item, and, where useful, each one true of none.
3. **Optional prose or footnotes:** nuances that don't fit a cell, such as version-specific behaviour or caveats.

Keep one comparison in one table: a 4-item, 7-column table reads better than three 4-item, 3-column tables stacked up. Split only when the dimensions are genuinely orthogonal, such as a pricing-tier table beside a feature table.

## Worked example

Three password managers.

### Before

```markdown
|                    | Bitwarden             | 1Password             | KeePassXC        |
| ------------------ | --------------------- | --------------------- | ---------------- |
| License            | GPL-3.0               | Proprietary           | GPL-2.0+         |
| Self-hostable      | Yes                   | No                    | Yes (local file) |
| Linux support      | Yes                   | Yes                   | Yes              |
| macOS support      | Yes                   | Yes                   | Yes              |
| Windows support    | Yes                   | Yes                   | Yes              |
| Browser extensions | Yes                   | Yes                   | Via bridge       |
| Family plan        | Yes ($40/yr, 6 users) | Yes ($60/yr, 5 users) | No               |
| TOTP support       | Yes                   | Yes                   | Yes              |
```

### After

```markdown
| Manager                             | License     | Self-hostable                | Browser extensions                   | Family plan            |
| ----------------------------------- | ----------- | ---------------------------- | ------------------------------------ | ---------------------- |
| [Bitwarden](https://bitwarden.com/) | GPL-3.0     | ✅<br/>Official Docker image | ✅<br/>Chrome, Firefox, Safari, Edge | ✅<br/>$40/yr for 6    |
| [1Password](https://1password.com/) | Proprietary | ❌                           | ✅<br/>Chrome, Firefox, Safari, Edge | ✅<br/>$60/yr for 5    |
| [KeePassXC](https://keepassxc.org/) | GPL-2.0+    | ✅<br/>Local-file database   | ❌<br/>Via plugin and bridge         | ❌<br/>Single-user app |

**Shared by all three:** Linux, macOS and Windows desktop apps; TOTP code generation.
```

The items moved to rows with linked names, Yes/No became ✅/❌ with qualifiers on `<br/>` lines, and the three operating-system rows and TOTP support, the same for every item, collapsed into the shared line, leaving only columns that separate the items.

## Common mistakes

| Mistake                                            | Fix                                                            |
| -------------------------------------------------- | -------------------------------------------------------------- |
| Plain or bold item names                           | Link each to its canonical page                                |
| `Yes` / `No` cells                                 | ✅ / ❌                                                        |
| `✅ — only on Pro`, the qualifier inline           | `✅<br/>Only on Pro`                                           |
| A column of identical values (all ✅, all "Linux") | A "Shared by all" line under the table                         |
| A column for a property only one item has          | A sentence or footnote, not a column                           |
| Items as columns, properties as rows               | Items as rows, the first column the linked name                |
| One comparison split into many small tables        | One main table; split only for genuinely orthogonal dimensions |
| ✅ in a categorical column, such as switch type    | Plain text; ✅/❌ only where every cell is genuinely yes or no |

## Your preferences

!`cat "${CLAUDE_SKILL_DIR}/../data-comparison-tables.preferences.md" "${CLAUDE_PROJECT_DIR}/.agents/skills/data-comparison-tables.preferences.md" 2>/dev/null || true`

If your agent doesn't run the line above, read these files yourself if they
exist: `data-comparison-tables.preferences.md` next to this skill's folder, then
`.agents/skills/data-comparison-tables.preferences.md` in the project. A project's
file overrides the user's, and the user's overrides this skill's defaults.

## Related skills

When one of these applies and it's in your skill listing, load it
without asking. If it isn't in your listing, tell the user which skill is
missing and ask whether to install it from the same collection this skill
came from; don't apply it from memory.

- `writing-hygiene-tables-for-comparison`: when content is an item-by-property grid, and keeping the table faithful to its source.
- `markdown-hygiene-lists-headings-tables`: the Markdown syntax of a table: pipes, alignment, `<br/>` in cells and an explicit `—` or `N/A` for an empty cell.
- `markdown-hygiene-terminal-rendering`: a table that will be read raw in a terminal.
