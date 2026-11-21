# Architecture

Software components, how they fit together, and what we build versus reuse.

## Status
Confirmed by user: tmux for tabs, Textual for the shell app, an existing editor with a modeless default, Obsidian Headless as the main sync. Editor leaning Neovim (see decisions/0002-editor.md).

## Proposed stack
- Boot: Linux, no desktop. systemd autologin on the console starts tmux, which starts the shell app.
- Tabs and terminal: tmux windows. Each tab is a window. Claude Code and any other CLI run natively in a pane, and sessions survive the shell app restarting.
- Shell app (launcher, file tree, settings): text-mode UI in Python with Textual for the first version. It runs other programs by suspending itself (as ranger and yazi do). Rewrite hot paths in Rust later only if measured slow.
- Editor: embed an existing editor, modeless and Word-like by default. Options and tradeoffs (micro, Neovim, own Textual editor) are in decisions/0002-editor.md. AI link: send the selection to the Claude Code pane through tmux.
- Notes: a plain markdown folder (Obsidian-compatible). Sync is a separate, toggleable service: Obsidian Headless (main), Syncthing or git. One mode active per device.
- Wi-Fi, settings, power: owned by the user, as separate small services the shell app calls.

## Why not the alternatives
- Rust shell: faster, but no Rust experience and the shell is not the bottleneck. Cost is mostly learning time.
- Graphical shell: nicer looks, but adds a display stack, RAM, and mouse-oriented toolkits.
- Writing our own editor: every feature (spell, autocorrect, formatting) is ours to build. Listed as an option in decisions/0002-editor.md.

## Language note
- Rust would give faster startup and lower RAM than Textual. Accepted trade: Textual for speed of development. Keep the shell thin (it talks to Wi-Fi, sync and power through small separate services) so it can be rewritten in Rust later if measured slow on the Pi.

## Agents
- Multiple Claude Code sessions run in separate tmux tabs at the same time. That covers agent management for the MVP.
- Bonus, not required: notifications when an agent finishes, and approving permission prompts from the shell app.

## Sync
- Obsidian Headless (open beta): npm package `obsidian-headless`, needs a paid Obsidian Sync subscription, same end-to-end encryption as the desktop app. Node is already required for Claude Code. Per Obsidian, do not run desktop Sync and Headless Sync on the same device; this matches the one-mode-per-device rule.

## Dev and test approach
- Develop in WSL2 (Ubuntu) on Windows. It is real Linux, so tmux, Neovim, Python/Textual, Node, Claude Code, Obsidian Headless, Syncthing and git all run as on the device. Git Bash and PowerShell are not enough.
- Keep the shell app separate from system services (Wi-Fi, power, sync). Put a fake version of each behind a simple interface so the UI runs and tests on Windows. Use Textual's headless test mode for automated UI tests.
- Windows Terminal grabs some key combinations. Check the final Ctrl shortcuts on the device's real console.
- PC is x86, Pi is ARM64. Check package compatibility (especially `obsidian-headless`) on the Pi.
- Needs real hardware: boot and autologin, passphrase unlock, Wi-Fi setup, power management, screen resolution and line count, boot time, RAM headroom, temperature and battery life.
- Use a Pi 5 as a desk rig early (any HDMI monitor and the user's keyboard). Connect over SSH; update with git or rsync via a deploy script in scripts/.
- Repo split: app/ is plain code testable anywhere, system/ holds config and systemd units checked on the Pi, image/ comes last and just installs them.

## Prototype steps
1. WSL2: Textual shell with a fake file tree backend, opening files in Neovim.
2. WSL2: tmux config for tabs, plus the modeless Neovim keymaps. Test with a non-vim user.
3. WSL2: Claude Code in several tabs, the run shortcut, and code formatting.
4. WSL2: sync modes against a test vault (Obsidian Headless, Syncthing, git). Back up the vault first.
5. Pi desk rig: install the stack, check ARM compatibility, measure RAM headroom with Claude Code open.
6. Pi: autologin into tmux and the shell app, then the encrypted data partition and passphrase unlock. Measure boot time.
7. Pi: Wi-Fi setup, power draw and battery life with a power bank (check the low-current shutoff).
8. Pi with the real screen: confirm line count, readability and battery draw.
9. Build the OS image from system/ once the above works.

## CLI agent tools
- Any CLI runs in a tmux pane, so the shell needs no tool-specific code. Tools are installed on their own (npm, pip, or a binary), not bundled in the image.
- Later: a small manifest (name, install command, ARM64 support, login method, approximate RAM) that the shell app reads to offer one-step installs. Keep it a data file, not code.
- Node and Python stay in the base image because most agent CLIs need one of them.

## Login support (checked from web search; verify before relying)
With no on-device browser, a QR/URL device-code flow is the goal. Support differs:
- Codex CLI: `codex login --device-auth` (beta). Device-code login must be enabled in ChatGPT settings. Fallbacks: API key from stdin, copy the auth cache from another machine, SSH tunnel.
- Copilot CLI: `copilot login` or `/login` uses GitHub's device flow (code plus github.com/login/device, finishable on a phone). Tokens can also come from `COPILOT_GITHUB_TOKEN`, `GH_TOKEN` or `GITHUB_TOKEN`. Without libsecret on headless Linux it may store the token in plaintext in `~/.copilot/config.json`, so keep it inside the encrypted area.
- Gemini CLI: `GEMINI_API_KEY` (Google AI Studio) set as an env var or in `~/.gemini/.env`; no interactive key prompt is documented. Vertex AI works too (service account JSON via `GOOGLE_APPLICATION_CREDENTIALS`). Google-account login needs a browser on a machine that can reach the terminal. API-key free tier is limited (about 250 requests per day, Flash only, per docs). A docs banner says Gemini CLI was replaced by Antigravity CLI on 18 June 2026; check what is current.
- Claude Code: `ANTHROPIC_API_KEY` works with no browser (pay per token). For a Pro/Max subscription, run `claude setup-token` once on a machine with a browser (one-year token), then set `CLAUDE_CODE_OAUTH_TOKEN` on the device. That token only makes model requests: no Remote Control and no claude.ai connectors; locally configured MCP servers still work. No device-code flow documented. Credentials are stored in `~/.claude/.credentials.json` (mode 0600).
- Summary: QR/device-code fits Codex and Copilot. Claude Code and Gemini use a key or token typed or copied onto the device. All of these live as files or env vars, so keep them inside the encrypted area.
