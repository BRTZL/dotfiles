## Reviews

Work built by subagents is reviewed by the other provider, never by the one that built it. You are Codex, so the reviewer is Claude, via T3 `delegate_task` (`role: "review"`, `target.providerInstanceId: "claudeAgent"`, self-contained brief). The reviewer follows the "Reviewing" section above. If T3 is not available in the session, say so instead of quietly using a Codex reviewer.
