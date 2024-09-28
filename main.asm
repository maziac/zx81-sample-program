
; Charset
ROM_CHARSET: equ 0x1E00
RAM_CHARSET: equ 0x2000
CHARSET_SIZE: equ 0x0200	; 64*8 = 512



; The start address of the machine code program.
; Is 16514.
main:
	assert main == 16514
	ret
