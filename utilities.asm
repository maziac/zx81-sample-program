; Utilizy functions/macros.

; Macro to define an expanded dfile screen.
; Takes the ascii string and converts it to the ZX81 charset.
; asserts that the length of the string is <= 32.
; The string is padded with spaces to 32 characters.
; At the end a newline is appended.
	MACRO DLINE ascii
.start
		defb ascii
.end
		assert .end - .start <= 32, Line exceeds 32 characters
		dup 32 - (.end - .start)
			defb 0
		edup
		defb $76	; Newline
	ENDM


; Macro to create one or more empty (expanded) lines.
; count = number of empty lines to create.
	MACRO DLINE_EMPTY count
		dup count
			dup 32
				defb 0
			edup
			defb $76	; Newline
		edup
	ENDM


