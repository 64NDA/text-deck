# 0002: Editor

Status: leaning Neovim (most customisable). Confirm after a prototype.

Default must be modeless and Word-like, with line numbers, syntax highlighting, format, a run shortcut, and ideally spell check and an AI hook. The shell opens files through one editor command, so the choice can change later.

## micro
- Pros: modeless by default (Ctrl-S, Ctrl-C, Ctrl-V), single small binary, fast start, line numbers, highlighting, Lua plugins, customisable keys, soft wrap.
- Cons: no built-in spell check, language server support is weak, smaller plugin ecosystem, slower development.

## Neovim (modeless keymaps)
- Pros: built-in spell check, language server support (grammar and code), large plugin ecosystem, existing Claude Code integrations.
- Cons: modeless is a keymap layer over a modal editor, so the mode can leak (Esc, stray commands). Needs a maintained config and plugins. Heavier start and RAM.

## Own editor (Textual TextArea)
- Pros: modeless by design, lives inside the shell app, full control of spell squiggles, AI hooks and layout.
- Cons: every feature is ours to build and maintain (spell, autocorrect, formatting, find and replace). Python on a Pi may be slow on large files. Terminal key limits for some Ctrl combinations.

## Direction (user criterion: most customisable, so features can be added later)
- Neovim is the most customisable of the two by a wide margin, so it is the starting editor, with a modeless keymap layer.
- Check early that the modeless layer holds up with a non-vim user. If it leaks too much, fall back to micro.
- A custom Rust editor stays a possible later project; the shell opens files through one editor command so it can be swapped in.
