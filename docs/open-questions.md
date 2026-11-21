# Open questions

Unresolved questions and risks, grouped by topic.

## Vision
- "Without the screen" vs. a built-in screen: what is being removed? A smaller, dimmer or simpler display, or fewer apps on it?
- Distraction-free vs. email, MCP and agent management: where is the line, and who enforces it (design or discipline)?
- Agentic work needs network and a model API, so "disconnected" only holds for writing. Is offline writing a first-class mode?
- Weight and noise vs. a laptop: Pi + battery bank + screen + keyboard may not beat a light laptop. Needs a target weight.
- Budget and productisation: deferred, not a blocker.

## Requirements
- Text area: 30 lines is an upper bound; fewer is acceptable. Exact minimum set during prototyping.
- Battery bank behaviour: many power banks shut off at low current draw. Needs checking.

## Hardware
- Pi 5 power: idle is a few watts and peaks are much higher, and it expects a 5 V / 5 A supply for full USB power. Measure real draw and runtime before committing.
- Pi 5 cooling: likely needs a fan or heatsink, which adds noise and weight against the vision.
- Storage (SD vs. NVMe), battery type and capacity, keyboard connection and ports not discussed yet.

## UX
- TUI (curses-style) or a minimal graphical shell with a text view? Decide in architecture.
- Keyboard-only tab switching and tree navigation scheme: not designed yet.
- Links and backlinks need an index of the vault; cost on a small board is unknown.

## Architecture
- Pivot from file tree to terminal inside one tab: new tmux window, split pane, or suspend and return? Decide in prototype.
- Claude Code RAM use on 4 GB alongside the editor, tmux and sync: measure.
- Boot time budget with systemd autologin path: measure.
- Prototype order: see Prototype steps in 04-architecture.md.

## Security
- Multi-user: use ordinary Linux accounts so it stays possible; defer.
- Where Claude Code credentials and MCP secrets are stored, and whether they sit inside the encrypted area.

## Editor
- Editor choice: see decisions/0002-editor.md.
- Language server for formatting and diagnostics: which one(s), and RAM cost on a Pi.

## Sync
- Syncthing on Android: confirm the client is maintained and works with Obsidian Android pointing at the synced folder.
- Only one sync mode active per device (Obsidian Sync and Syncthing together cause conflicts). Exclude .obsidian from Syncthing.
- Product sync: rclone connectors (Dropbox, OneDrive, Google Drive, WebDAV) and git as options; two-way rclone sync and conflict handling need testing.
- Notion and Google Docs are not file-based; treat as one-way import/export, if at all.
- Obsidian Headless is open beta: confirm it runs on ARM64 Linux, how much RAM it uses, and how it behaves over flaky Wi-Fi.
- Captive-portal Wi-Fi is not supported without a browser; the phone hotspot is the workaround.
- Claude Code login on a headless device: confirm it prints a URL that can be shown as a QR code.

## CLI agent tools
- ARM64 support varies by tool; check each one on the Pi.
- Login differs per tool; see Login support in 04-architecture.md. Verify each against current docs before relying on it.
- Claude Code subscription token (`setup-token`) lacks claude.ai connectors, which affects the MCP email idea; local MCP servers still work. Test.
- Gemini CLI vs Antigravity CLI: check the current official tool and auth options.
- Each tool stores credentials differently; keep all of them inside the encrypted area.
