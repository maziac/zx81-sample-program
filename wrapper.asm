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

	; Include character codes and BASIC tokens
	include "charcodes.asm"
	include "basic_tokens.asm"

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
NXTLIN:         defw BASIC_PROGRAM	; Basic program next executed line
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


; BASIC program:
BASIC_PROGRAM:
	; 1 REM ... machine code ...
	defb 0, 1	; Line 1
	defw rem_line_end - rem_line_start
rem_line_start:
	defb REM
	include "main.asm"
	defb NEWLINE
rem_line_end

	; 10 IF INKEY$<>"S" THEN GOTO VAL "20"
	BLINE 10, <IF, INKEYS, NEQ, _QT, _S, _QT, THEN, GO_TO, VAL, _QT, _1, _0, _QT>

	; 20 RAND USR VAL "16514"
	BLINE 20, <RAND, USR, VAL, _QT, _1, _6, _5, _1, _4, _QT>


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

