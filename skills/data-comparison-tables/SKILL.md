---
name: data-comparison-tables
description: Use when writing or updating a Markdown document that compares two or more concrete things (products, libraries, services, frameworks, tools, plans, options) for a reader deciding between them — blog posts, README "alternatives" sections, decision docs, wikis, buyer's guides, "X vs Y" sections.
---

# Comparison Tables

A comparison table earns its keep when a reader scans it and finds the answer in seconds: items in rows, properties in columns, binary values as ✅/❌, hyperlinked names to drill in, and uniform properties pulled out so the table shows only what distinguishes the items.

## When to use

- Comparing 2+ products, libraries, services, frameworks, tools, plans, or options.
- The reader needs to scan and pick, not study each item on its own.

Skip it for single-item deep dives (write prose). For 2 items across 20+ dimensions, transpose to items-as-columns — a deliberate exception, not the default.

## Rules

### 1. Items in rows; first column is the hyperlinked name

Each item is one row. The first cell holds its name, **linked to the most relevant page** — official site or canonical docs, falling back to the GitHub repo, Wikipedia article, or product page.

Rows let the eye scan one property down a single column ("which is wireless?"); transposing forces a slower read-the-label-then-jump-across pattern. The link puts the canonical page one click away instead of a search.

```markdown
| Framework | … |
|---|---|
| [Flask](https://flask.palletsprojects.com/) | … |
| [Django](https://www.djangoproject.com/) | … |
| [FastAPI](https://fastapi.tiangolo.com/) | … |
```

Don't leave names as plain or bold text, link them only in surrounding prose, or strand them in column headers above an unlinked table.

### 2. Include the obvious columns

The properties a reader expects for this category — products: price, license, platforms, use case; libraries: language, license, maintenance, runtime size; services: free tier, hosting model, pricing; physical goods: dimensions, weight, materials, warranty.

Aim for 4–8 load-bearing columns. Three informative columns beat ten weak ones.

### 3. Binary columns use ✅ / ❌, qualifiers on a new `<br/>` line

For any yes/no, supported/unsupported, included/excluded column: ✅ for positive, ❌ for negative. Put any qualifier ("only on the Pro plan") on a `<br/>` line below the symbol.

```markdown
| Keyboard | Wireless | Hot-swappable switches | Onboard layers |
|---|---|---|---|
| [Glove80](https://www.moergo.com/) | ✅<br/>Bluetooth via ZMK | ✅ | ✅<br/>10+ |
| [Moonlander](https://www.zsa.io/moonlander/) | ❌<br/>USB-C only | ✅ | ✅<br/>32 |
| [HHKB Hybrid](https://hhkeyboard.us/) | ✅<br/>Up to 4 devices | ❌<br/>Topre, soldered | ❌<br/>DIP-switch modes only |
```

The reader registers the symbol's shape and color before reading any word, so a column of ✅/❌ communicates instantly where "Yes"/"No" forces cell-by-cell reading — and the gap widens with row count. The `<br/>` keeps the symbol dominant while the detail stays available.

Don't fake it: categorical (switch type, license) or numeric (price, weight) values stay plain text. ✅/❌ is only for columns where every cell is a genuine yes/no.

### 4. A column per notable, differing, shared property

A property earns a column when all three hold:

- **Notable** — readers care about it for this category.
- **Shared by at least half the items** — a real axis, not a one-off feature.
- **Values differ** — the column actually separates the items.

A property relevant to only one or two items belongs in prose or a footnote; a column of mostly empty or "N/A" cells wastes space.

### 5. Pull uniform properties into a list under the table

A property with the same value for every item can't help the reader choose. Move it to a bulleted list directly below.

```markdown
| Service | … |
|---|---|
| [GitHub Actions](https://github.com/features/actions) | … |
| [GitLab CI/CD](https://docs.gitlab.com/ee/ci/) | … |
| [CircleCI](https://circleci.com/) | … |

**Shared by all three:** Linux runners, free tier for public repositories, GitHub Checks API integration, matrix builds, OIDC for cloud-provider auth.
```

A column of "Yes / Yes / Yes" — or "Linux / Linux / Linux" — tells the reader nothing; pulling it out keeps every column load-bearing while preserving the fact. This includes ✅ columns. Do the same for uniformly-absent properties: "**None of these:** ship with a GUI, support Windows, are open-source."

## Putting it together

A complete comparison usually has:

1. **One main table** — items in rows, binary cells as ✅/❌ with `<br/>` qualifiers, everything else concise text, first column the linked name.
2. **A "shared by all" list immediately below** — one line per uniformly-true property (and per uniformly-false one, if useful).
3. **(Optional) prose or footnotes** for nuances that don't fit a cell — history, version-specific behavior, caveats.

Resist splitting one comparison into many small tables; a 4-item, 7-column table reads better than three 4-item, 3-column ones stacked up. Split only when the dimensions are genuinely orthogonal (e.g., a separate pricing-tier table beside a feature table).

## Worked example

Three password managers, before and after.

**Before** — the typical baseline:

```markdown
| | Bitwarden | 1Password | KeePassXC |
|---|---|---|---|
| License | GPL-3.0 | Proprietary | GPL-2.0+ |
| Self-hostable | Yes | No | Yes (local file) |
| Linux support | Yes | Yes | Yes |
| macOS support | Yes | Yes | Yes |
| Windows support | Yes | Yes | Yes |
| Browser extensions | Yes | Yes | Via bridge |
| Family plan | Yes ($40/yr, 6 users) | Yes ($60/yr, 5 users) | No |
| TOTP support | Yes | Yes | Yes |
```

**After:**

```markdown
| Manager | License | Self-hostable | Browser extensions | Family plan |
|---|---|---|---|---|
| [Bitwarden](https://bitwarden.com/) | GPL-3.0 | ✅<br/>Official Docker image | ✅<br/>Chrome, Firefox, Safari, Edge | ✅<br/>$40/yr for 6 |
| [1Password](https://1password.com/) | Proprietary | ❌ | ✅<br/>Chrome, Firefox, Safari, Edge | ✅<br/>$60/yr for 5 |
| [KeePassXC](https://keepassxc.org/) | GPL-2.0+ | ✅<br/>Local-file DB | ❌<br/>Via browser plugin + bridge | ❌<br/>Single-user app |

**Shared by all three:** Linux, macOS, and Windows desktop apps; TOTP code generation; CSV import.
```

Items moved to rows, names linked, Yes/No replaced with ✅/❌, qualifiers moved to `<br/>` lines, the three OS columns collapsed into one shared line — leaving only columns that separate the items.

## Common mistakes

| Mistake | Fix |
|---|---|
| Plain or bolded item names | Hyperlink each to its canonical page |
| `Yes` / `No` cells | Replace with ✅ / ❌ |
| `✅ — only on Pro` (qualifier inline) | Move qualifier to a new line: `✅<br/>Only on Pro` |
| Column of identical values (all ✅, or all "Linux") | Pull out to a "Shared by all:" line below the table |
| Property relevant to one item shown as its own column | Mention in prose or a footnote, not the table |
| Items as columns, properties as rows (transposed) | Transpose so items are rows; first column the linked name |
| One comparison split into 5+ tiny tables | Combine into one main table; split only if dimensions are truly orthogonal |
| `✅` forced into a categorical column (e.g., "switch type") | Use plain text — ✅/❌ is only for genuinely binary columns |
