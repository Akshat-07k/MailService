# Copilot instructions for MailService (mailvas)

Purpose
- Frontend web app built with Vue 3 + Vite. Provides an AI-assisted mail composer UI and chat components that integrate with Google's Generative AI libraries.

Quick commands
- Install deps: cd mailvas && npm install
- Start dev server: cd mailvas && npm run dev
- Build for production: cd mailvas && npm run build
- Preview production build: cd mailvas && npm run preview
- Format code: cd mailvas && npm run format
- Tests: No test framework configured. If adding tests, the repo currently has no test script; add scripts (e.g., vitest) to package.json. There is no single-test command configured.

High-level architecture
- Framework: Vue 3 + Vite. Entry point: mailvas/src/main.js -> mounts App.vue
- Routing: mailvas/src/router/index.js defines app routes. Pages live in mailvas/src/pages.
- State: Pinia used for global state; stores in mailvas/src/stores (example: counter.js).
- UI: Single-file components (SFCs) under mailvas/src/Component and mailvas/src/pages. Note: folder name is "Component" (capital C) — not the common "components" — respect this when searching or scaffolding files.
- AI integration: Uses @google/genai and @google/generative-ai and groq-sdk. Files of interest: mailvas/src/pages/Ai.vue, mailvas/src/pages/CreateMailView.vue and chat-related components (chat.vue, chat2.vue). API keys / config likely live in mailvas/.env.
- Assets & public: mailvas/src/assets and mailvas/public.

Key conventions and repo-specific patterns
- Directory naming: "Component" (capital C) contains UI components. Pages live in src/pages. Follow these locations for feature work.
- Pinia stores are single-file (e.g., counter.js). Keep stores in src/stores and register Pinia in src/main.js.
- Router is centralized at src/router/index.js — add new pages there.
- Formatting: Prettier is the canonical formatter via npm run format. No ESLint or other linters configured by default.
- No test runner configured: Do not assume tests exist. If adding tests, update package.json with test scripts and include guidance here.
- Node runtime requirement: package.json specifies node engine constraints (Node 20.19+ or >=22.12). Use an appropriate Node version manager when running locally.
- Generative-AI usage: Look for code that imports @google/genai or @google/generative-ai or groq-sdk when modifying AI-related logic.

Files to open first in a Copilot session
- mailvas/README.md
- mailvas/package.json
- mailvas/src/main.js
- mailvas/src/router/index.js
- mailvas/src/pages/CreateMailView.vue
- mailvas/src/pages/Ai.vue
- mailvas/src/Component/chat.vue (and chat2.vue)
- mailvas/src/stores/counter.js

Notes for Copilot assistants
- Do not assume a test suite or linting beyond Prettier exists.
- When proposing code changes touching AI integrations, check mailvas/.env for environment variables and avoid exposing secrets in code or commits.
- Respect the "Component" directory name and the existing page/store/router locations.
- When adding third-party tools or scripts, update package.json scripts and add a short note in this file describing how to run them.

MCP Servers
- (Optional) Configure a Playwright or headless browser MCP server only if adding end-to-end tests or browser automation. Ask the repo owner before provisioning.

Summary
- Created repository-specific Copilot instructions describing build commands, architecture, and key conventions. Update this file if tests, linters, or CI are added, or if directory names change.
