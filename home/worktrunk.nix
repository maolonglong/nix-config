{
  programs.worktrunk = {
    enable = true;
    enableZshIntegration = true;
    settings.worktree-path = "~/.worktrees/{{ repo }}/{{ branch | sanitize }}";

    # The rex-worktrunk picker closes its own session. Shell `wt remove` and
    # `wt merge` do not, so close the session from the post-remove hook.
    settings."post-remove"."rex-session" = "command -v rex >/dev/null 2>&1 && rex --autostart=false do worktree_close path={{ worktree_path }} main={{ primary_worktree_path }} >/dev/null 2>&1 || true";
  };
}
