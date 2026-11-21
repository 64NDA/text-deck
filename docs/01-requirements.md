# Requirements

What the device must do, with measurable targets.

## Form factor
- Fits in a bag; ideally just a box with a screen.
- Under 1 kg (hard limit). Lighter, smaller and longer battery are always better, but exact targets are deferred.

## Offline
- Notes and writing must work with no network.
- Sync is nice to have, not required.

## Files
- Must be easy to move notes to other devices, by sync or by physical means (USB copy). Notes are plain files.

## Boot
- As fast as the hardware allows. Fast suspend/resume is not required; a cold boot each time is accepted.

## Deferred
- Final numbers (see Provisional targets) and budget.

## Agents
- Several agent sessions can run in separate tabs, but one at a time is the expected use on 4 GB. Multi-session performance is not a target.
- Bonus: notifications and permission-prompt approval inside the app.

## Security
- A login is required. Secrets (API keys, tokens, MCP credentials) must be protected if the device is lost.
- Multiple users: bonus, not MVP.

## Code editing
- Must support editing code well: line numbers, syntax highlighting, formatting, and a run shortcut that opens the output in a new tab.

## Security (encryption)
- Encrypt the data partition, unlocked by a passphrase at boot. Leave the OS partition unencrypted for faster boot.
- Auto-lock after idle. Credentials and secrets live inside the encrypted area.
- Use revocable tokens where possible.

## Provisional targets (not locked)
Starting minimums, to be refined by prototyping. More battery, more RAM and lower cost are always better.
- Weight: under 1 kg for the device with battery, keyboard excluded.
- Battery: 8 hours writing, 3 hours with an agent running. Stretch goal is double (may be too ambitious).
- Boot to editor: under 20 seconds, excluding the passphrase.
- Text area: up to 30 lines is the upper bound; fewer is fine.
- RAM headroom: 1 GB free with Claude Code open.

## Sync
- Selectable sync mode, one active per device: Obsidian Headless (main, needs a paid Obsidian Sync subscription), Syncthing, or git. USB copy as fallback.
- Syncthing and git keep the device usable without paid services.
- Git is required. Heavy code runs on a remote dev environment, not on the device.
- Product (later): rclone connectors (Dropbox, OneDrive, Google Drive, WebDAV); sync the folder, not each app. Needs refinement before launch.

## Login to services
- Log in to services such as Claude Code with a device-based flow: show a QR code or URL on the device, complete the login on the phone. No on-device browser.
- Device unlock stays a passphrase, since it must work offline and without a phone. Phone-based unlock is a possible later second factor.

## CLI agent tools
- Not tied to Claude Code. Any CLI agent (Copilot CLI, Gemini CLI, OpenAI Codex CLI, others) can be installed separately and run in a terminal tab.
- MVP: the user installs tools themselves. Later: a simple tool manager in the shell app.
- Credentials screen in the shell app (bonus): enter an API key or token for a tool once; the app stores it in the encrypted area and exports it as an env var for that tool.
