; Custom checkpoint system that hijacks the death routine, specifically to avoid overworld.
; Will restart the current level depending on where the screen has been passed.
; Screen 00 in Lunar Magic defaults to the start of the level which can be changed on line 9
; Screen 0A in Lunar Magic is chosen to be the checkpoint or halfway mark, can be changed on line 10
; Works with sublevels.
; Not compatible with SA-1
; Made specifically for my hack Mario In Soul Land.

!LevelStartScreen = $09
!CheckpointScreen = $0A

ORG $00F611                               ; Disable the music from changing on death
db $EA,$EA,$EA

ORG $00F616                               ; Disable the death animation
db $EA,$EA,$EA

ORG $00F625                               ; Value that is cleared when dead
db $EA,$EA,$EA

ORG $00F60A                               ; Hijack inside death routine
autoclean JSL Checkpoint
NOP                                       ; Get rid of the extra byte

freecode

Checkpoint:
LDA $13CE                                 ; Midway point flag
CMP #$01                                  ; If obtained
BCS CheckpointPassed                      ; CHECKPOINT!
LDA $0DBE                                 ; Load player lives
CMP #$00                                  ; Compare to see if the lives are #$00
BEQ GameOver                              ; Gameover if lives are #$00
DEC $0DBE                                 ; Decrease lives since not equal
LDA #$2A                                  ; Load the negative sound
STA $1DFC                                 ; Some quality of life, plays the negative sound when a life is lost
LDA $5B                                   ; Screen mode
AND #$01                                  ; Check if C
ASL                                       ; Shift, 0
TAX                                       ; Load $5B to X
LDA $95,X                                 ; Marios X Position
TAX                                       ; Load $95 to X
LDA $19B8+!LevelStartScreen               ; \
STA $19B8,X                               ;  | Level exit flags, !LevelStartScreen is the levels start set on line 9
LDA $19D8+!LevelStartScreen               ;  |
STA $19D8,X                               ; /
LDA #$06
STA $71
STZ $88
STZ $89
LDA #$09                                  ; Original code
NOP #3                                    ; Original code but (disable the music from changing on death)
RTL

CheckpointPassed:
LDA $0DBE                                 ; Load player lives
CMP #$00                                  ; Compare to see if the lives are #$00
BEQ GameOver                              ; Gameover if lives are #$00
DEC $0DBE                                 ; Decrease lives since not equal
LDA #$2A                                  ; Load the negative sound
STA $1DFC                                 ; Some quality of life, plays the negative sound when a life is lost
LDA $5B                                   ; Screen mode
AND #$01                                  ; Check if C
ASL                                       ; Shift, 0
TAX                                       ; Load $5B to X
LDA $95,X                                 ; Marios X Position
TAX                                       ; Load $95 to X
LDA $19B8+!CheckpointScreen               ; \
STA $19B8,X                               ;  | Level exit flags, !CheckpointScreen is the levels midway mark set on line 10
LDA $19D8+!CheckpointScreen               ;  |
STA $19D8,X                               ; /
LDA #$06                                  ; Animation value (#$06 for vertical warp pipe)
STA $71                                   ; Store to player animation trigger
STZ $88                                   ; Set how long the player is in a "pipe" until warp to zero
STZ $89                                   ; Set player exit action to zero
LDA #$09                                  ; Original code
NOP #3                                    ; Original code but (disable the music from changing on death)
RTL

GameOver:
LDY #$03                                  ; Load value of #$03 (Loads the title screen)
STY $0100                                 ; Set the gamemode
RTL
