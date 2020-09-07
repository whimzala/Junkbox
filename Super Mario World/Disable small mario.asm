; This patch will disable small mario in levels.
; Compatibles with SA-1

!addr = $0000                            ; \
!bank = $800000                          ;  |
if read1($00FFD5) == $23                 ;  |
sa1rom                                   ;  | Check for SA-1 Support
!addr = $6000                            ;  |
!bank = $000000                          ;  |
endif                                    ; /

ORG $00F5F5|!bank                        ; \ Disable power down sound temporarily
db $EA,$EA,$EA                           ; /

ORG $0491D5|!bank                        ; Hijack in enter level routine
autoclean JSL KillingMeSmalls
NOP #2                                   ; Get rid of two leftover bytes

freecode

KillingMeSmalls:
LDA $19                                  ; Load marios current power state  
CMP #$02                                 ; Compare marios power state to #$02 (Cape)
BCS HasAPower                            ; If marios power state is #$02 or bigger branch to HasAPower
LDA #$01                                 ; Load marios big power state
STA $19                                  ; Store it (make mario big)
LDA $0DBC|!addr,X                        ; Restore original hijacked code
STA $0DC2|!addr                          ; Restore original hijacked code
RTL

HasAPower:
LDA $0DBC|!addr,X                        ; Restore original hijacked code
STA $0DC2|!addr                          ; Restore original hijacked code
RTL

ORG $00F600|!bank                        ; Hijack in hurt routine
autoclean JSL Fix

freecode

Fix:
LDA $19                                  ; Get marios power state                      
CMP #$02                                 ; Compare marios power state to #$02 (Cape)
BCS Big                                  ; If marios power state is #$02 or bigger branch to Big
JSL $00F606|!bank                        ; Else kill mario
RTL

Big:
LDA #$01                                 ; Load big power state
STA $19                                  ; Store it (downgrade mario to big, since his original power state was #$02 or bigger)
LDA #$04                                 ; Load the power down sound effect (previously disabled on line 12-13)
STA $1DF9|!addr                          ; Play the sound
RTL 
