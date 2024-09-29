
	; Check the pc value to be inside the REM statement.
	assert $ == 16514

; The assembler/machine code program starts here.
; The sample code just fills each line of the screen with characters
; for ever (in a loop).
main:
	; Start character for filling
	ld a, _A
.loop:
	; Get start address of dfile/screen
	ld hl, (D_FILE)
	inc hl
	ld c,24	; Number of lines

.next_line:
	call fill_line

	; Choose next character
	inc a
	cp _Z
	jr c,.cont_character
	; Restart with 'A'
	ld a, _A
.cont_character:

	; Next line
	dec c
	jr nz,.next_line

	; Start at first line again
	jr .loop
	; We never reach this point

; Fills a line with characters.
; A = character to fill
; HL = address to start
fill_line:
	; Fill one line
	ld b,32
.loop:
	ld (hl),a
	inc hl
	djnz .loop
	inc hl	; Skip the newline character
	ret
