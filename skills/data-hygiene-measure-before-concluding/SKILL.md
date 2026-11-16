---
name: data-hygiene-measure-before-concluding
description: |
  Before saying one option is faster, smaller or cheaper, measure both the
  same way: a warm-up run discarded, several runs of each (say how many),
  the median and a spread (IQR or min–max), on the same machine in the
  same conditions, with what was held constant named and the difference
  compared with the spread. A difference inside the noise is reported as
  no difference; one run is an anecdote. Covers benchmarks, trials of a
  setting or flag, build and test timings, and projections from a few data
  points (say how many points and how far they extrapolate). Use whenever
  about to claim a speed-up, a regression, a size or cost saving, or a
  trend.
---

# data-hygiene-measure-before-concluding

_A claim that one option beats another rests on repeated runs of both, measured the same way, with the difference larger than the spread._

Timings vary from run to run with caches, CPU load, thermal state and background work. One run of each option measures that variation as much as the options, so a 10% gap between two single runs is often noise.

## The rules

1. **Warm up, then discard.** Run each option once before measuring and drop that run. It pays for cold caches, JIT compilation, downloads and lazy setup.
2. **Run each option several times, and say how many.** Five is a floor for anything that takes seconds; more when the spread is wide. Interleave the options (A, B, A, B) rather than all of A then all of B, so drift over time hits both.
3. **Report the median and a spread.** The median resists one slow outlier; the interquartile range or min–max shows how much the runs vary. "Median 4.2 s (min–max 4.0–4.6 s, 7 runs)".
4. **Measure both the same way.** Same machine, same command line, same input, same conditions. Name what you held constant: CPU load, caches warm or dropped, build parallelism (`MAKEFLAGS`, `-j`), power and network state.
5. **Compare the difference with the spread.** If the two options' ranges overlap, or the gap between medians is smaller than either spread, report no measurable difference. Say so plainly rather than "slightly faster".
6. **One run is an anecdote.** If you could only run once, report it as a single observation and draw no conclusion from it.
7. **Projections say how many points and how far.** A trend fitted to a few data points states the number of points and how far past the last one it extrapolates: "from 4 points over 2 weeks, projected 3 months out". Extrapolating far beyond the measured range is a guess, and the reply says so.

Prefer a tool that does the repetition and statistics, such as `hyperfine` for commands, over a hand-rolled loop. Where the project uses Nix, take it from the dev shell.

## When to apply

- About to say one option, setting, flag, build or version is faster, slower, smaller, larger or cheaper.
- Running a benchmark, a timing comparison or a trial of a configuration change.
- Projecting a trend (growth, cost, time to finish) from a few measurements.

## Your preferences

!`cat "${CLAUDE_SKILL_DIR}/../data-hygiene-measure-before-concluding.preferences.md" "${CLAUDE_PROJECT_DIR}/.agents/skills/data-hygiene-measure-before-concluding.preferences.md" 2>/dev/null || true`

If your agent doesn't run the line above, read these files yourself if they
exist: `data-hygiene-measure-before-concluding.preferences.md` next to this skill's folder, then
`.agents/skills/data-hygiene-measure-before-concluding.preferences.md` in the project. A project's
file overrides the user's, and the user's overrides this skill's defaults.

## Related skills

When one of these applies and it's in your skill listing, load it
without asking. If it isn't in your listing, tell the user which skill is
missing and ask whether to install it from the same collection this skill
came from; don't apply it from memory.

- `data-hygiene-figures-from-queries`: each figure in the comparison comes from a command named in the reply.
