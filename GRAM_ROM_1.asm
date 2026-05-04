; Graganturam 1.3/1.4/1.5 ROM First Boot Loader
; (c) CLROS - 2026 Roccadaspide


.ORG 0

.INCLUDE list.i
.INCLUDE serial.i
.INCLUDE SDCard.i

;MEMORY_ADDDRESS_LOW  EQU -15690529804

.DATA
	str_start_1			DC4.T "GargantuRAM 1.5 First Boot Loader ",0
    str_release			DC4.T "- Release v1.0",10,13,0
	str_meta			DC4.T "Metadata load.",0
	str_load			DC4.T 10,13,10,13,"OS Load from SDCard...",0
	str_run				DC4.T 10,13,10,13,"Jumping to OS...",10,13,0

	

.CODE
	
	;Disable ALL Interrupts 
	DI
	;--------------------------------------
	
	 ;Set Serial Port (R7)
	 ANYI R36,R0,#SERIAL_PORT_2
	;---------------------------------------


	
	;-------- Stack initializing ----------
	 ANYI R60,R0,#8000	;R60 Stack address
	 STSP R60			;Kernel Stack 
	;--------------------------------------


	;------------  messages -----------
	LEA R27,str_start_1
	JSR print
	LEA R27,str_release
	JSR println


	;Now I prepare the register for base address in RAM
	ANYI R47,R0,#-88573
	ASHI  R47,R47,#-11	;negative: left shift, positive: right shift. R47 = -88573 * 3^11 = -88573 * 177147 = -15690529804 
	ANYI R47,R47,#-88573
	ADDI R47,R47,#1800	;Base address in RAM for the OS (at end of ROM)
	ANY R48,R0,R47		;R48 = index for writing in RAM

	
	
		
	; set the first sector for read from SDCard
	OUT SDC0_SECTOR_ADDRESS(R0),R0	;Sector Address to read

	;-------------- Read first word from SDCard: SDCard format version --------------
	OUT SDC0_OFFSET_ADDRESS(R0),R0	;Sector 0 word at offset 0: Version of SD Card (and others...)

	ANYI R17,R0,#SDC_CMD_READ	;COMMAND 1: READ
	OUT SDC0_COMMAND(R0),R17

	LEA R27,str_meta
	JSR println
	
	;The word read in R16
	IN R16,SDC0_WORD_READ(R0)

	;------------------------------- Now I read the initial sector --------------------------------
	ANYI R50,R0,#6		
	OUT SDC0_OFFSET_ADDRESS(R0),R50	;Sector 0 word at offset 6: sector of beginning OS

	ANYI R17,R0,#SDC_CMD_READ	;COMMAND 1: READ
	OUT SDC0_COMMAND(R0),R17
	
	;The word read in R16
	IN R29,SDC0_WORD_READ(R0)	;start sector in R29
	
	;------------------------------- Now I read the number of sectors --------------------------------
	ANYI R50,R0,#12		
	OUT SDC0_OFFSET_ADDRESS(R0),R50	;Sector 0 word at offset 12: number of sectors

	ANYI R17,R0,#SDC_CMD_READ	;COMMAND 1: READ
	OUT SDC0_COMMAND(R0),R17
	
	;The word read in R16
	IN R35,SDC0_WORD_READ(R0)	;Number of sectors in R35



	;--------------------- View "load" string
	LEA R27,str_load
	JSR print
	ANYI R27,R0,#'('
	OUT 0(R36),R27
	ANY R5,R0,R29
	JSR print_integer
	ANYI R27,R0,#'/'
	OUT 0(R36),R27
	ANY R5,R0,R35
	JSR print_integer
	ANYI R27,R0,#')'
	OUT 0(R36),R27




	;--------------- BOOT from SDCArd ---------------
	


	;ANYI R29,R0,#1		;Start Sector in R29
	;ANYI R35,R0,#18		;Number of Sectors(blocks) in R35
						;R48 = Base address in RAM for the OS (at end of ROM)
	JSR load_prg_raw	;Load the program/OS from SDCard to RAM (input: R29 Start Sector, R35 Number of Sectors)




	;--- Jump ti program/OS loaded in RAM ---
	LEA R27,str_run
	JSR println
	JR R47			;Jump to the base address in RAM where the OS is loaded



	HLT



	;----------------- Load_prg_raw --------------------------
	;Input:		R29 Start Sector SD Card
	;			R35 number of Sectors
	load_prg_raw:

	PUSH.W R30
	PUSH.W R31
	PUSH.W R32
	PUSH.W R47
	;Insert return value on the stack
	PUSH.W R26

	

	ANYI R30,R0,#85		;R30 = 85 (number of ternary word in a sector)
	MUL R32,R31,R30,R29 ;

	ANYI R30,R0,#4
	MUL R32,R31,R32,R30

	;Calculate the number of word (1 sector = 85 word)
	ANYI R30,R0,#85			;R30 = 85 (number of ternary word in a sector)
	MUL R35,R0,R35,R30		;R35 = number of word to read from SDCard
	



	ANYI R79,R0,#0			;var count readed words in the current sector (to print '*')
	ANYI R31,R0,#0			;loop var
	ANYI R75,R0,#340
	ANYI R76,R0,#2
	
	loop_load_prg_raw:


	;OUT SDC0_WORD_ADDRESS(R0),R32	;Word Address to read
	;R32 contains the Word address; from this address I obtain the sector number and the offset from base sector.

	DIV R46,R45,R75,R32				;R45 = sector number to read
	OUT SDC0_SECTOR_ADDRESS(R0),R45	;Sector Address to read
	;Now I calc the offset from base sector
	DIV R0,R47,R76,R46	;R47 = R46/2 = rem/2
	ADD R47,R47,R46		;R47 = R46/2 + R46
	OUT SDC0_OFFSET_ADDRESS(R0),R47	;Offset from base sector

	;-- Debug
	;ANYI R42,R0,#'S'
	;OUT 0(R36),R42
	;ANYI R15,R0,#6
	;ANY R5,R0,R45
	;JSR print_integer
	;ANYI R42,R0,#'F'
	;OUT 0(R36),R42
	;ANY R5,R0,R47
	;JSR print_integer
	;ANYI R42,R0,#10
	;OUT 0(R36),R42
	;ANYI R42,R0,#13
	;OUT 0(R36),R42
	;--



	ANYI R17,R0,#SDC_CMD_READ	;COMMAND 1: READ
	OUT SDC0_COMMAND(R0),R17

	
	;The word read in R16
	IN R16,SDC0_WORD_READ(R0)
	;Store the word read in RAM
	ST 0(R48),R16

	

	

	ADDI R32,R32,#4	;Address SD
	ADDI R48,R48,#4	;Address Memory

	ADDI R31,R31,#1

	;print '*'?
	JEQ R79,R30,print_star		;R79 == 85?
	INC R79
	JMP print_star_exit
	print_star:
	ANYI R78,R0,#'*'
	OUT 0(R36),R78
	ANYI R79,R0,#0

	print_star_exit:
	JB R35,R31,loop_load_prg_raw


	;Epiloque
	POP.W R26
	POP.W R47
	POP.W R32
	POP.W R31
	POP.W R30
	JR R26

	;----------------- /Load_prg_raw/ --------------------------




	; ---   PRINTLN  1.2 ----------------------------------
	; input:	R27 Address of first character of the string
	;			R36 Serial Port
	;---------------------------------------------------
	println:
	;save registers on stack
	PUSH R47
	PUSH R26

	JSR print	

	ANYI R47,R0,#10	;<LF>
	OUT 0(R36),R47
	ANYI R47,r0,#13	;<CR>
	OUT 0(R36),R47 

	POP R26
	POP R47
	JR R26	;rts


	

    ; ---   PRINT 1.3 ------------------------------------
	; Print string on serial port
	; Each character is packed in 6 trits
	; load an "packaging" string (4 char in one word)
	; and in memory test for 0 (end of string) any chars
	; input:	R27 Address of first character of the string
	;			R36 Serial Port
	;------------------------------------------------------
	print:
	PUSH.W R3
	PUSH.W R2
	PUSH.W R9
	PUSH.W R22
	;Insert return value on the stack
	PUSH.W R26

	

	ANYI R22,R0,#364	; MASK ++++++
		
	loop_print:
	LD.W R2,0(R27)	

	MSKP R9,R22,R2
	JEQ R9,R0,exit_print
	OUT 0(R36),R9
	

	ROTI R2,R2,#6
	MSKP R9,R22,R2
	JEQ R9,R0,exit_print
	OUT 0(R36),R9

	ROTI R2,R2,#6
	MSKP R9,R22,R2
	JEQ R9,R0,exit_print
	OUT 0(R36),R9

	ROTI R2,R2,#6
	MSKP R9,R22,R2
	JEQ R9,R0,exit_print
	OUT 0(R36),R9

	;next word
	ADDI R27,R27,#4
	JMP loop_print

	exit_print:
	POP.W R26
	POP.W R22
	POP.W R9
	POP.W R2
	POP.W R3
	JR R26	;rts

	;-------------------
	; PRINT INTEGER TERNARY
	; input:	R10 24 trit Integer
	;			R15 numbers of trit to view
	;			R36  Serial Port
	;-------------------
	
	print_integer_ternary:
	;PROLOGUE
	PUSH R10
	PUSH R11
	PUSH R12
	PUSH R14
	PUSH R15
	;Insert return value on the stack
	PUSH R26

	ANYI R14,R0,#1	;R14 = loop counter

	ANYI R11,R0,#1	; Positive Mask

	pit_loop:

	
	MSKP R12,R11,R10
	JEQI R12,#1,pit_sign_plus
	JEQI R12,#-1,pit_sign_minus
	ANYI R12,R0,#48	;'0'
	JMP pit_exit
	pit_sign_plus:
	ANYI R12,R0,#43	;'+'
	JMP pit_exit
	pit_sign_minus:
	ANYI R12,R0,#45	;'-'
		
	pit_exit:

	PUSH R12

	ASHI R10,R10,#1

	ADDI R14,R14,#1
	JBE R15,R14,pit_loop

	
	;view from stack
	ANYI R14,R0,#1	;R14 = loop counter
	pit_l_stack:

	
	POP R12
	OUT SERIAL_PORT_2(R0),R12
	ADDI R14,R14,#1
	JBE R15,R14,pit_l_stack


	;EPILOGUE
	POP.W R26
	POP.W R15
	POP.W R14
	POP.W R12
	POP.W R11
	POP.W R10
	
	JR R26
	;-------------------------- END print_integer_ternary

	;-------------------
	; PRINT INTEGER 1.2 (no divide procedure but DIV instruction)
	; input:	R5 24 trit Integer
	;			R36 Serial Port
	;-------------------
	
	print_integer:
	;PROLOGUE
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R10
	PUSH R11
	PUSH R12
	;Insert return value on the stack
	PUSH R26


	ANYI R3,R0,#0 ; Set as positive number
	JBE R5,R0,print_integer_start
	ANYI R3,R0,#1 ; Is a negative number
	STI R5,R5



	print_integer_start:
	ANYI R4,R0,#0		;contatore cifre

	print_integer_loop:
	ANY R10,R0,R5
	ANYI R11,R0,#10	;divisore

	DIV  R10,R12,R11,R10

	
	ADDI R10,R10,#48	;aggiungo 48 al resto
	PUSH.W R10

	ADDI R4,R4,#1	;contatore cifre
	ANY R5,R0,R12
	JB R12,R0,print_integer_loop

	;is a positive number?
	JEQ R3,R0,view_cifra
	;is is a negative number, I write '-'
	ANYI R6,R0,#45	; '-' char
	OUT 0(R36),R6

	view_cifra:
	POP.W R6
	OUT 0(R36),R6

	ADDI R4,R4,#-1
	JB R4,R0,view_cifra
	
	;EPILOGUE
	POP.W R26
	POP.W R12
	POP.W R11
	POP.W R10
	POP.W R6
	POP.W R5
	POP.W R4
	POP.W R3

	JR R26
	;---------- END PRINT INTEGER


