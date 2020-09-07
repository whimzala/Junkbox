; This patch disables Switch Palace switches from ending the current level
; This will also remove the dialog box that pops up.
; Is compatible with SA-1

ORG $00EEC4					; Plays the level ending song (#$0C), so lets stop that.
db $EA,$EA,$EA

ORG $00EEC9					; Plays the level ending song (#$0C), so lets stop that.
db $EA,$EA,$EA

ORG $00EECE					; Disable the end level timer set by switches.
db $EA,$EA,$EA