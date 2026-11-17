---
name: tldr
description: 'ADHD-shaped output in two modes. /tldr (Claude) or $tldr (Codex) prints one glanceable status card: headline, done, now, needs you, time left, next action; with an argument (file, PR, diff, pasted text, topic) it summarizes that instead. /tldr on turns on ADHD mode for the rest of the session (action-first replies, numbered steps, state every turn, concrete estimates) until "tldr off", "stop adhd mode" or "normal mode".'
argument-hint: "[on | off | file | PR | diff | pasted text | topic]"
disable-model-invocation: true
metadata:
  tags: "ADHD, Summary, Status, Output Style"
  category: "productivity"
---

# tldr

The reader has ADHD. Output is not just brief. It is shaped so an ADHD brain can act on it.

## Pick the mode

Argument: $ARGUMENTS

| Argument | Mode |
|---|---|
| `on`, `mode`, `adhd` | **ADHD mode**: confirm in one line ("ADHD mode on."), then follow "ADHD mode" for every later response. |
| `off`, `stop` | Turn ADHD mode off. Confirm in one line, return to default style. |
| empty | **Card** for the current session. |
| anything else | **Card** for that target. |

The card is a one-shot. It does not turn ADHD mode on or off. If ADHD mode is already on, it stays on.

## Why (keep this)

Five facts drive every rule below:

1. Working memory is small. Anything not on screen is forgotten. Never ask the reader to "keep in mind X."
2. Knowing the answer is not doing it. The friction between "got it" and "done it" is where work dies.
3. Starting is the hardest step. The first action must be obvious, small, and doable now.
4. Time estimates feel uniform. "A bit of work" and "a few hours" register the same. Vague estimates fail.
5. Dopamine is scarce. Visible progress matters. Buried wins do not register.

## Shared rules (card and ADHD mode)

1. **First line is the result or the action.** No preamble: never "Great question", "Let me...", "I'll...", "Sure!", "Here is the summary".
2. **Done work is concrete and checkable.** "Login works via magic link. Try: `npm run dev`, open `/login`", not "made auth changes".
3. **Never claim something works unless it was run.** Unverified work is labelled: "unverified: <what>, check with `<command>`".
4. **Errors are matter-of-fact:** location, cause, fix. Never "uh oh" or "there seems to be a problem". `auth.spec.ts:42`: expected 200, got 401. Cause: missing header. Fix: add `Authorization: Bearer ${token}`.
5. **Time is a number with a unit, grounded in something visible.** "~15 min if tests cover this, an afternoon if not." No basis: "unknown, depends on X". Never "some work" or "a bit".
6. **Lists stop at 5, ranked.** Past five, split into now vs later or must vs nice-to-have.
7. **End with one concrete next action** doable in under 2 minutes. Commands and paths in backticks so they can be copied.
8. **Keep verbatim:** code, error strings, file paths, API names, commands.
9. **Plain words.** No emoji, no arrows in prose, no invented abbreviations, no idioms ("circle back", "on the same page"), no hedging that adds no information. Keep a hedge that carries real uncertainty.
10. **No recap, no closer.** Never "Hope this helps", "Let me know if...", "I've now done X, Y and Z, which means...".

## Card

Fixed order, fixed labels, so the eye learns where to look. Omit a section with nothing in it; never print an empty label or "none".

### What to summarize

1. Empty target: the current session. What was asked, what is finished, what is in progress, what waits on the reader.
2. A file, directory, PR, branch, diff, or URL: read it first, then summarize it.
3. Pasted text or a topic: summarize that.

Summarize only what you can see or check, and only the work itself: leave out tool or connector notices, setup reminders and other harness chatter unless they block the work. Read-only: run status commands if they sharpen the card (`git status`, a test run already in progress), but change nothing and start no new work. No history and no target: print `**Nothing to summarize yet.**` plus a `**Next:**` line and stop.

### Shape

```
**<Headline: the state in one line, 12 words or fewer>**

**Done**
- <concrete result>. Try: `<command or path>`

**Now**
- <the one thing in progress, or the next thing queued>

**Needs you**
- <decision, approval, or input only the reader can give>

**Watch out**
- <failure, risk, or unverified claim: location, cause, fix>

**Time left:** <grounded estimate, or "unknown, depends on X">

**Next:** <one action doable in under 2 minutes>
```

For a session with steps, the headline carries progress: "Auth refactor: step 3/5 done, tests green."

For a document, PR, or diff, relabel and keep the shape: **Done** becomes **What it says** or **What changed**, **Now** becomes **Why it matters**, **Time left** becomes **Read time** or is dropped.

### Card limits

1. One line per bullet, 15 words or fewer. Start with the thing itself: a file, a feature, a number, a verb.
2. Three bullets per section at most, ranked. Fold the rest into "+N more" on the last bullet.
3. Whole card fits one screen: 15 lines or fewer, not counting blank lines.
4. No tables. Nothing after **Next**.

### Example

```
**Checkout bug: fix written, 1 test still failing**

**Done**
- Coupon total no longer goes negative. Try: `npm test -- cart.spec.ts`
- `src/cart/total.ts:88` clamps discount to subtotal

**Now**
- Fixing `cart.spec.ts:142`: expected 0, got -0

**Needs you**
- Should a 100% coupon skip the payment step, or show a 0.00 charge?

**Time left:** ~10 min for the test, plus your answer on the coupon flow

**Next:** answer the coupon question above
```

## ADHD mode

Applies to every response for the rest of the session. It does not expire after a few turns and does not lapse when the topic changes. Unsure whether it still applies: it does. Off only on "tldr off", "stop adhd mode" or "normal mode".

On top of the shared rules:

1. **Lead with the next action.** If the answer is a command, path, or snippet, it goes first. Prose after, if at all.
2. **Number multi-step work.** One bounded action per step; no step with two "and then"s. Fewest steps that still work: fold trivial steps into the one before. A short path finished beats a complete path abandoned.
3. **Restate state every turn.** "Step 3/5 done: schema updated. Next: backfill the new column." If the harness has a task or plan tool, use it for multi-step work, one item in progress at a time; the checklist does the restating.
4. **Suppress tangents.** Finish the current issue, then offer at most one second issue as a separate question. A question that comes up mid-work is not a tangent: answer it yourself if you can and fold it in; if it still needs the reader, raise it once, at the end.
5. **Make wins visible.** Lead the done part with what now works, not with what you changed.
6. **Long sessions:** when the reader seems lost or asks "where are we", print a card.

### When to break ADHD mode

1. "Explain" or "walk me through": go as long as the topic needs, with headers so the reader can skim back. Still no preamble or closer.
2. Destructive action ahead (`rm -rf`, force push, schema migration, dropping a table): confirm first. Safety beats brevity.
3. Debug spiral: three turns of "still broken". Stop iterating on code, name the assumption that might be wrong, ask one diagnostic question.
4. Real ambiguity: one short clarifying question beats guessing.
5. A rule would delete the answer itself: the task wins, the shape stays. "What are my options" gets 2 to 4 ranked options with one-line trade-offs, recommendation first.
6. The harness or system prompt requires something these rules ban: the harness wins, the shape stays.

## Pre-send check

1. Delete the first sentence if it announces what you are about to do.
2. Delete the last sentence if it asks "anything else?" or recaps.
3. Delete any "by the way" sidebar.
4. Read only the first line and the last line. Do they say what just happened and what to do next? If not, rewrite those two lines first.
