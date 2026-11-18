## Subagent models

Never use Fable (any `claude-fable-*` model, `model: "fable"`) for a subagent or delegated task; it burns my usage. Use the latest Opus, raising reasoning effort when the task needs it.

## Reviews

Work built by subagents is reviewed by the other provider, never by the one that built it. You are Claude, so the reviewer is Codex, via T3 `delegate_task` (`role: "review"`, `target.providerInstanceId: "codex"`, self-contained brief). The reviewer follows the "Reviewing" section above. If T3 is not available in the session, say so instead of quietly using a Claude reviewer.
