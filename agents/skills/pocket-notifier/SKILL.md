---
name: pocket-notifier
description: Send the user phone notifications through the Pocket Notifier MCP server while you work - after each finished milestone or work unit, when the whole task is done, when you are blocked on their decision, on failures you cannot fix, and when long builds or deploys end. Use in every working session where the pocket-notifier MCP tools (send_notification, list_projects, list_features) are available, or when the user asks to be notified, pinged or told on their phone.
---

# Pocket Notifier

The user steps away from the screen while you work and follows along on their phone. Pocket Notifier is how they know what happened without coming back to read the thread. They want to hear from you **along the way**: each finished milestone, not only the end.

Server: `https://notifier.bartuozel.com/api/mcp` (MCP, OAuth). Tools: `list_projects`, `create_project`, `list_features`, `create_feature`, `update_feature_status`, `send_notification`.

## The model

| Level | What it is | On the phone |
| --- | --- | --- |
| **Project** | A product or repo: `notifier`, `my-app`. `name` = lowercase slug, usually the repo folder. | A project in the Projects tab. The user can mute it. |
| **Feature** | One workstream inside a project: `mvp`, `login-flow`, `cache-layer`. Status `active` → `done` → `archived`. | One chat thread. Every message about that workstream stacks there. |
| *(no feature)* | Project-wide news: deploys, CI, releases, incidents. | The project's own thread. |
| *(no project)* | Only for work that belongs to no repo. | The private General project. |

Pick the feature by **workstream**, the thing the user would track as a ticket or branch. Many notifications in one feature is the goal; a new feature per notification is wrong.

## Setup, once per session

1. `list_projects`. If the repo's project is missing, `create_project` with `name` (repo slug), `displayName` and a one-line `description`.
2. `list_features` for that project (default `active`). Reuse the feature that matches the current work by name and description. Matching hints: the branch name (`feat/login-flow` → `login-flow`), the ticket, the task the user gave you.
3. No match: `create_feature` with a short slug-like name and a one-line description, or pass the new name in `send_notification` (it creates the feature on first use). Prefer `create_feature` when a description helps the user recognise the thread.
4. Keep that feature for the whole workstream, across sessions and turns.

If you cannot tell which feature fits and a wrong guess would scatter messages, ask the user in the session; do not invent a near-duplicate of an existing feature.

## When to send

### Send

| Moment | Priority | Tags | Example title |
| --- | --- | --- | --- |
| **Milestone done**: a work unit finished and checked (see below) | 2 | `milestone` | `Step 2/5: schema migrated` |
| **Task done**: everything the user asked for is done and verified | 3 | `done` | `Login flow done` |
| **Blocked** on the user's decision (an open question in the session) | 4 | `ask` | `Need a decision: cache` |
| **Failure** you cannot fix yourself | 4 | `fail` | `Build broken: auth tests` |
| **Prod or data at risk** | 5 | `fail`, `urgent` | `Prod deploy failing` |
| **Long build, deploy or CI run** (5+ min) ended | 3 ok / 4 failed | `build` (+ `fail`) | `Deploy live` / `CI failed: lint` |
| **PR opened** or ready for review | 3 | `pr` | `PR #12 ready for review` |

### What counts as a milestone

A milestone is a **finished, checked unit of work** that the user would be glad to hear about:

- A numbered step of a plan you are executing is done ("Step 3/5 done").
- A subagent or delegated task returned and you verified its result.
- A component or layer works end to end: tests or typecheck pass for it, or you ran it.
- A commit or push that closes a piece of the task.
- A review came back (findings count, blocking or not).
- An investigation reached a conclusion (root cause found).

Not milestones: starting something, reading files, a plan written but not yet approved, a step whose checks fail, a retry, a "still working".

### Pacing

- No limit per turn or per session. Send every status update that matters: a milestone landed, something broke, you need the user, it shipped. Ask "would the user want to know this now?"; if yes, send.
- Every notification carries something measurable: a step count (`Step 3/5`), test or check results (`42 tests pass`, `lint clean`), a number that moved (`p95 480ms to 90ms`, `bundle -120 KB`), a concrete artifact (`PR #12 open`, `v1.8.0 live`), or an exact failure (`auth.spec.ts:42 gets 401`). If you cannot name a measurable result, it is not worth a notification.
- One notification per milestone. If two milestones finish within a couple of minutes, send one that covers both.
- Short tasks (under ~10 minutes, one or two steps) get only the final `done`, no milestones.
- When the final `done` would come right after the last milestone, send only the `done`.
- Never send the same notification twice. After a failed send, retry once; then mention it in your reply and stop.
- Only the top-level agent the user talks to sends. Subagents and delegated tasks report to their parent instead.

### Never send for

Plain Q&A, turns under ~2 minutes, things starting, raw progress ("50% done"), subagent or retry events, anything the user is watching you do right now in an interactive back-and-forth.

## Writing it

- **`title`**: the outcome only, at most 32 characters. No project or feature prefix (the app shows both). For plan steps, lead with the step: `Step 3/5: API wired`.
- **`body`**: one line, at most ~90 characters. Result first, the user's next step (or yours) last.
  - Milestone: `Migration runs clean, 42 tests pass. Next: wire the API.`
  - Done: `Magic-link login works, tests pass. Try it: open /login.`
  - Fail: `auth.spec.ts:42 expects 200, gets 401. Needs the staging token.`
- **`priority`** and **`tags`**: from the table above.
- **`project`** / **`feature`**: the ones chosen in setup. Omit `feature` only for project-wide news (deploys, CI, releases).

## What to attach

Attach the place the user would open to check your claim. Tapping the notification opens its thread; `url` adds an **Open** button there and on the notification.

| Notification | `url` | `actions` (up to 2 extra buttons) |
| --- | --- | --- |
| PR opened, review done | The PR | `Files changed`, or the CI run |
| CI / build / deploy ended | The run, or the deployed URL when it passed | Logs of the failing job |
| Deploy live | The live URL | The deploy run |
| Milestone with a commit | The commit or branch compare on GitHub | — |
| Task done with something to try | The preview or local URL only if the phone can reach it | The PR |
| Blocked / ask | The agent thread (T3 Code link) when known | A doc or diff the decision depends on |
| Failure | The failing run or issue | — |

Rules:

- URLs must be `https://` and reachable from the phone. Never `localhost`, LAN IPs or file paths.
- Put the T3 Code thread link in `url` when you have it and nothing better fits, so the user can jump back to you.
- `actions` labels are short verbs or nouns: `Open PR`, `CI logs`, `Live site`.
- No images or files: the MCP sends links only. Link to a screenshot that is already hosted (for example one attached to the PR) instead.

## Asking from the phone

When you are blocked and have asked a question in the session, also send:

```json
{
  "project": "notifier",
  "feature": "cache-layer",
  "title": "Need a decision: cache",
  "body": "Redis or in-memory LRU for the search cache? Blocked until you pick.",
  "priority": 4,
  "tags": ["ask"],
  "ask": {
    "question": "Which cache?",
    "quickReplies": ["Redis (Recommended)", "LRU"],
    "allowText": true
  }
}
```

- `quickReplies`: the same 2-3 options as the session question, recommendation first. Each at most 40 characters.
- Replies are stored on the phone and **not returned to you**. The user answers in the session; wait for them there.

## Closing the workstream

When the work is merged or shipped:

1. Send the final `done` notification in the feature.
2. `update_feature_status` → `done`.

Do not reopen a `done` feature for new work; start a new feature. Follow-up fixes to the same just-merged work may reuse it.

## Examples

A five-step plan, run over an hour:

```json
{ "project": "my-app", "feature": "search-cache", "title": "Step 1/5: cache module added",
  "body": "LRU cache with TTL, 12 unit tests pass. Next: hook into search.",
  "priority": 2, "tags": ["milestone"] }

{ "project": "my-app", "feature": "search-cache", "title": "Step 3/5: review back",
  "body": "Codex review: 2 findings, 0 blocking. Fixing both now.",
  "priority": 2, "tags": ["milestone"] }

{ "project": "my-app", "feature": "search-cache", "title": "Search cache done",
  "body": "p95 search 480ms to 90ms, all tests pass. Review PR #31.",
  "priority": 3, "tags": ["done"], "url": "https://github.com/acme/my-app/pull/31",
  "actions": [{ "label": "CI run", "url": "https://github.com/acme/my-app/actions/runs/123" }] }
```

A project-wide deploy (no feature):

```json
{ "project": "my-app", "title": "Prod deploy live",
  "body": "v1.8.0 is live, health check OK.", "priority": 3, "tags": ["build"],
  "url": "https://my-app.example.com" }
```

## Never

- Never put secrets in any field: tokens, passwords, API keys, private keys, cookies, connection strings. Name the env var or file instead.
- Never send personal data the user did not ask to see on their phone.
- Never notify on behalf of a subagent, or let a subagent send.

## Fallback

If the pocket-notifier tools are missing, need authentication, or fail twice, use `agent-notify` (ntfy; see `agent-notify --help`) for the same moments, and tell the user the MCP is unavailable. To connect the MCP:

```bash
claude mcp add --transport http --scope user pocket-notifier https://notifier.bartuozel.com/api/mcp   # then /mcp → Authenticate
codex mcp add pocket-notifier --url https://notifier.bartuozel.com/api/mcp && codex mcp login pocket-notifier
```
