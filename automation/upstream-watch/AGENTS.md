# AGENTS.md

This is a [Flue](https://flueframework.com) project: agents are TypeScript functions.

## Layout

- `src/agents/` — agent modules. A module whose first line is the `'use agent'` directive exports agents: every exported capitalized function is one, and the function name is its durable identity.

## Commands

- `pnpm exec flue run src/agents/upstream-watch.ts --message "Analyze commit <sha>"` — run the agent locally, no server.
- `pnpm run check:types` — typecheck.
- `pnpm exec flue docs search <query>` — search the Flue docs from the terminal (then `flue docs read <path>`).
- `pnpm exec flue add` — list blueprints for adding channels, sandboxes, and databases.
