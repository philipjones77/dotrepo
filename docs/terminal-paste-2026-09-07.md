# Terminal paste settings

Configured explicit Ctrl+V, Ctrl+Shift+V and Shift+Insert paste bindings in
Windows Terminal and VS Code/Antigravity terminals. Windows Terminal bindings
apply to its PowerShell, Command Prompt and WSL profiles. Editor bindings apply
only with terminal focus; terminal shortcuts are handled by the editor, and
right-click copies selected text or pastes when no text is selected.

PowerShell PSReadLine now binds the same three keys to Paste. The source's
PowerShell 7 and Windows PowerShell all-host profiles also include the bindings.
Legacy console defaults and existing console subkeys have clipboard shortcuts,
QuickEdit, InsertMode and the modern console enabled. Start new shell windows
to load profile and legacy console changes.

Validation: JSON files parsed, the shared PowerShell profile passed syntax
parsing, and PSReadLine reported Paste for all three chords. Physical clipboard
keystrokes in every terminal host have not been tested. Existing clipboard
contents were not read or replaced.

The Mathematica activation prompt intentionally hides typed and pasted keys.
Its local helper now explains paste shortcuts and reports the received character
count after Enter. The previous attempt returned activation exit code 78;
that alone does not establish why activation failed. A new prompt was launched
after these settings changes. Activation is still pending verification.
