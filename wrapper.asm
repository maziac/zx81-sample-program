; ZX81 BASIC Wrapper.
; Wraps a small BASIC program around the machine code.
; The machine code will be placed in a REM line.
; The REM line size increases with the machine code program.
; The next BASIC line will start the machine code.
; Afterwards a LOAD statement will load the real program.
; It is meant as loader for OSMO, to place the stack in another area
; and to load custom graphics and color data for chroma81.


	DEVICE NOSLOT64K
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

	; Include character codes
	include "charcodes.asm"

	; Include other macros etc.
	include "utilities.asm"

; System variables tht start at $4009
	ORG $4009
VERSN:          defb 0
E_PPC:          defw 2
D_FILE:         defw DFILE_DATA		; $400C
DF_CC:          defw DFILE_DATA+1
VARS:           defw BASIC_VARS
DEST:           defw 0
E_LINE:         defw BASIC_END
CH_ADD:         defw BASIC_END+4
X_PTR:          defw 0
STKBOT:         defw BASIC_END+5
STKEND:         defw BASIC_END+5
BREG:           defb 0
MEM:            defw MEMBOT
UNUSED1:        defb 0
DF_SZ:          defb 2
S_TOP:          defw $0002
LAST_K:         defw $fdbf
DEBOUN:         defb 15
MARGIN:         defb 55
NXTLIN:         defw LINE2_RAND ; LINE2_RAND  ; Basic program next executed line
OLDPPC:         defw 0
FLAGX:          defb 0
STRLEN:         defw 0
T_ADDR:         defw $0c8d
SEED:           defw 0
FRAMES:         defw $f5a3
COORDS:         defw 0
PR_CC:          defb $bc
S_POSN:         defw $1821
CDFLAG:         defb $40
PRBUFF:         dup 32 ; 32 Spaces + Newline
					defb 0
				edup
				defb $76
MEMBOT:     	dup 30
					defb 0
				edup
;    defb 0,0,0,0,0,0,0,0,0,0,$84,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
UNUSED2:       defw 0
; End of system variables


; Start of BASIC program:
; First line with the REM statement that holds the machine code.
LINE1_REM:
	defb 0, 0	; Line 0
    defw LINE1_REM.end - LINE1_REM.start  ; Length of line
.start:
	defb $EA	; REM

; Include the assembler code
	include "main.asm"

; End of line
	defb $76	; Newline
LINE1_REM.end

; Second line with RAND USR VAL "16514" to start the machine code.
LINE2_RAND:
	defb 0, 10	; Line 10
    defw LINE2_RAND.end - LINE2_RAND.start
.start:
    defb $F9, $D4, $C5	; RAND USR VAL
	defb $0B, $1D, $22, $21, $1D, $20, $0B	; "16514"
    defb $76; Newline
.end

; Screen:
DFILE_DATA:
	defb _NL
	; dup 24
	; 	defb _NL
	; edup

	DLINE_EMPTY 5
	DLINEC <_Z,_X,_8,_1,__,_S,_A,_M,_P,_L,_E,__,_P,_R,_O,_G,_R,_A,_M>
	DLINE_EMPTY 5
	DLINEC <_P,_R,_E,_S,_S,__,_QT,_S,_QT,__,_T,_O,__,_S,_T,_A,_R,_T>
	DLINE_FILL_REMAINING

; BASIC variables:
BASIC_VARS:
.end:
	defb $80

BASIC_END
