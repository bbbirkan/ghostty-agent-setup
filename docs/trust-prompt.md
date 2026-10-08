# "Do you trust this folder?" (and how to stop answering it by hand)

The first time Claude Code opens a folder it asks:

> Quick safety check: Is this a project you created or one you trust? ...

This is **not** the same as the permission mode. Even with permissions bypassed ("bypass permissions on"),
every *new* folder asks once. Answer once and it is remembered for that exact folder.
Trust is **not inherited**: trusting `~` does not trust `~/projects/foo`.

Why the question exists: a repository can contain its own `.claude/` settings and hooks. If you open
someone else's repo and say "yes", those can run commands on your machine.

## The annoying case

You start several agents at once (see [caravan-mode.md](caravan-mode.md)), or create a new
git worktree for every task: each new folder asks again, and the question can swallow the first
message you send to the agent.

## `trust-folders`: pre-answer it for *your own* folders

```bash
sudo install -m755 scripts/trust-folders /usr/local/bin/trust-folders   # or ~/.local/bin
export TRUST_OWNERS=my-github-name        # whose remote repos count as yours (comma-separated)

trust-folders -n ~/code/*/       # dry run: show what would change
trust-folders ~/code/*/          # list, ask, then write
trust-folders -y ~/code/new-app  # no question
```

A folder is trusted **only if** it is a git repo that either has **no remote** or whose remote owner is in
`TRUST_OWNERS`. Other people's repos and non-git folders are skipped, on purpose.

`panel` calls `trust-folders -s <folder>` (silent mode) before starting Claude, so folders you launch
that way never ask. Do the same in your own launcher scripts.

## What it changes

It sets `projects["<path>"].hasTrustDialogAccepted = true` in `~/.claude.json` (override with `CLAUDE_CONFIG`).
Before each write it saves `~/.claude.json.bak-trust-<time>` (last 5 kept) and replaces the file atomically.

## Honest limits

- Running Claude sessions also write that file. A write at the exact same moment could drop a tiny
  piece of their bookkeeping (the file stays valid JSON). Do not run this in a loop.
- A Claude that is **already showing** the question does not notice the change; restart that pane.
- There was no global "never ask" setting when this was written; per-folder is the supported way.
  Check Claude Code's current docs, this may have changed.
- Only use it for code you wrote or genuinely trust.
