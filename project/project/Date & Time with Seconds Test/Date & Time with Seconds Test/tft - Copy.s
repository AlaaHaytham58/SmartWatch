	AREA MYDATA, DATA, READONLY
	
RCC_BASE	EQU		0x40021000
RCC_APB2ENR		EQU		RCC_BASE + 0x18


AFIO_BASE		EQU		0x40010000
AFIO_MAPR	EQU		AFIO_BASE + 0x04


GPIOC_BASE         EQU      0x40011000   ; port c
GPIOC_CRH         EQU     GPIOC_BASE+0x04
GPIOC_ODR     EQU        GPIOC_BASE+0x0C
GPIOC_IDR     EQU        GPIOC_BASE+0x08
GPIOC_BRR  EQU     GPIOC_BASE +  0x14
GPIOC_BSRR  EQU     GPIOC_BASE +  0x10



GPIOA_BASE      EQU     0x40010800
GPIOA_CRH         EQU     GPIOA_BASE+0x04
GPIOA_CRL         EQU     GPIOA_BASE
GPIOA_ODR     EQU        GPIOA_BASE+0x0C
GPIOA_BRR  EQU     GPIOA_BASE +  0x14
GPIOA_BSRR  EQU     GPIOA_BASE +  0x10


GPIOB_BASE  EQU 0x40010C00
GPIOB_CRH         EQU     GPIOB_BASE+0x04
GPIOB_CRL         EQU     GPIOB_BASE
GPIOB_ODR     EQU        GPIOB_BASE+0x0C
GPIOB_BRR  EQU     GPIOB_BASE +  0x14
GPIOB_BSRR  EQU     GPIOB_BASE +  0x10


INTERVAL EQU 0x566004		;just a number to perform the delay. this number takes roughly 1 second to decrement until it reaches 0



;the following are pins connected from the TFT to our EasyMX board
;RD = PB9		Read pin	--> to read from touch screen input 
;WR = PB8		Write pin	--> to write data/command to display
;RS = PB7		Command pin	--> to choose command or data to write
;CS = PB6		Chip Select	--> to enable the TFT, lol	(active low)
;RST= PB15		Reset		--> to reset the TFT (active low)
;D0-7 = PA0-7	Data BUS	--> Put your command or data on this bus



;just some color codes, 16-bit colors coded in RGB 565
BLACK	EQU   	0x0000
BLUE 	EQU  	0x001F
RED  	EQU  	0xF800
RED2   	EQU 	0x4000
GREEN 	EQU  	0x07E0
CYAN  	EQU  	0x07FF
MAGENTA EQU 	0xF81F
YELLOW	EQU  	0xFFE0
WHITE 	EQU  	0xFFFF
GREEN2 	EQU 	0x2FA4
CYAN2 	EQU  	0x07FF











	AREA MYCODE, CODE, READONLY

    EXPORT __main
    ENTRY
__main FUNCTION
    ; Initialize TFT and RTC
    BL SETUP                  ; Initialize the TFT
    BL rtc_setup              ; Initialize the RTC
	
    ; Clear the screen with black color
    MOV R0, #0               ; Top-left X1 = 0
    MOV R1, #0               ; Top-left Y1 = 0
    MOV R3, #319             ; Bottom-right X2 = 320
    MOV R4, #239             ; Bottom-right Y2 = 240
    MOV R10, #0x0000         ; Black color
    BL DRAW_RECTANGLE_FILLED ; Fill entire screen with black color
	ldr R10,=BLUE
	BL DRAW_COLLEN
    ; Initialize previous registers to track changes
    MOV R4, #0xFF            ; Previous seconds (set to invalid to force initial draw)
    MOV R6, #0xFF            ; Previous minutes (set to invalid to force initial draw)
    mov r12,#0
MainLoop

	; ======== Hours Check ========
	MOV R5,#1
	BL SEGMENT_POSITIONS_TIME
	BL DRAW_1
	MOV R5,#2
	BL SEGMENT_POSITIONS_TIME
	; ======== Minutes Check ========
	BL DRAW_2
	MOV R5,#3
	BL SEGMENT_POSITIONS_TIME
	BL DRAW_3
	MOV R5,#4
	BL SEGMENT_POSITIONS_TIME
	BL DRAW_4
	; ======== Seconds Check ========
	MOV R5,#5
	BL SEGMENT_POSITIONS_TIME
	BL DRAW_1_SMALL
	MOV R5,#6
	BL SEGMENT_POSITIONS_TIME
	BL DRAW_2_SMALL
	; ======== Days Check ========
	MOV R5,#1
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_3_SMALL
	MOV R5,#2
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_4_SMALL
	; ======== Months Check ========
	MOV R5,#3
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_5_SMALL
	MOV R5,#4
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_6_SMALL
	; ======== Years Check ========
	MOV R5,#5
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_7_SMALL
	MOV R5,#6
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_8_SMALL
	MOV R5,#7
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_9_SMALL
	MOV R5,#8
	BL SEGMENT_POSITIONS_DATE
	BL DRAW_0_SMALL
    ; ======== Return to Main Loop ========
    B MainLoop
    ENDFUNC

	endfunc


;#####################################################################################################################################################################
LCD_WRITE   FUNCTION
	;this function takes what is inside r2 and writes it to the tft
	;this function writes 8 bits only
	;later we will choose whether those 8 bits are considered a command, or just pure data
	;your job is to just write 8-bits (regardless if data or command) to PE0-7 and set WR appropriately
	;arguments: R2 = data to be written to the D0-7 bus

	;TODO: PUSH THE NEEDED REGISTERS TO SAVE THEIR CONTENTS. HINT: Push any register you will modify inside the function
	PUSH {r0-r3, LR}


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 0 ;;;;;;;;;;;;;;;;;;;;;
	;TODO: RESET WR TO 0
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #8
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;BL delay_1_second

	;;;;;;;;;;;;; HERE YOU PUT YOUR DATA which is in R2 TO PE0-7 ;;;;;;;;;;;;;;;;;
	;TODO: SET PE0-7 WITH THE LOWER 8-bits of R2
	LDR r1, =GPIOA_ODR
	STRB r2, [r1]			;only write the lower byte to PE0-7
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;BL delay_1_second

	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET WR TO 1 AGAIN (ie make a rising edge)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #8
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;BL delay_1_second


	;TODO: POP THE REGISTERS YOU JUST PUSHED.
	POP {R0-r3, PC}
    ENDFUNC
;#####################################################################################################################################################################




;#####################################################################################################################################################################
LCD_COMMAND_WRITE   FUNCTION
	;this function writes a command to the TFT, the command is read from R2
	;it writes LOW to RS first to specify that we are writing a command not data.
	;then it normally calls the function LCD_WRITE we just defined above
	;arguments: R2 = data to be written on D0-7 bus

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH {R0-R3, LR}
	


	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #9
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RS to 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 0 (to specify that we are writing commands not data on the D0-7 bus)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #7
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ALL REGISTERS YOU PUSHED
	POP {R0-R3, PC}
    ENDFUNC
;#####################################################################################################################################################################






;#####################################################################################################################################################################
LCD_DATA_WRITE  FUNCTION
	;this function writes Data to the TFT, the data is read from R2
	;it writes HIGH to RS first to specify that we are writing actual data not a command.
	;arguments: R2 = data

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH {R0-R3, LR}

	;TODO: SET RD TO HIGH (we don't need to read anything)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #9
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;; SETTING RS to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 1 (to specify that we are sending actual data not a command on the D0-7 bus)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #7
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE

	;TODO: POP ANY REGISTER YOU PUSHED
	POP {R0-R3, PC}
    ENDFUNC
;#####################################################################################################################################################################







;#####################################################################################################################################################################
LCD_INIT    FUNCTION
	;This function executes the minimum needed LCD initialization measures
	;Only the necessary Commands are covered
	;Eventho there are so many more in the DataSheet

	;TODO: PUSH ANY NEEDED REGISTERS
  	PUSH {R0-R3, LR}

	;;;;;;;;;;;;;;;;; HARDWARE RESET (putting RST to high then low then high again) ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RESET PIN TO HIGH
	LDR r1, =GPIOB_ODR	
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #15
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second

	;TODO: RESET RESET PIN TO LOW
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #15
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second

	;TODO: SET RESET PIN TO HIGH AGAIN
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #15
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






	;;;;;;;;;;;;;;;;; PREPARATION FOR WRITE CYCLE SEQUENCE (setting CS to high, then configuring WR and RD, then resetting CS to low) ;;;;;;;;;;;;;;;;;;
	;TODO: SET CS PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #6
	STR r0, [r1]
    
    

	;TODO: SET WR PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #8
	STRH r0, [r1]

	;TODO: SET RD PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #9
	STRH r0, [r1]

    

	;TODO: SET CS PIN LOW
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #6
	MVN R3, R3
	AND r0, r0, R3
	STR r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SOFTWARE INITIALIZATION SEQUENCE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: ISSUE THE "SET CONTRAST" COMMAND, ITS HEX CODE IS 0xC5
	MOV R2, #0xC5
	BL LCD_COMMAND_WRITE

	;THIS COMMAND REQUIRES 2 PARAMETERS TO BE SENT AS DATA, THE VCOM H, AND THE VCOM L
	;WE WANT TO SET VCOM H TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 1111111 OR 0x7F HEXA
	;TODO: SEND THE FIRST PARAMETER (THE VCOM H) NEEDED BY THE COMMAND, WITH HEX 0x7F, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x7F
	BL LCD_DATA_WRITE

	;WE WANT TO SET VCOM L TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 00000000 OR 0x00 HEXA
	;TODO: SEND THE SECOND PARAMETER (THE VCOM L) NEEDED BY THE CONTRAST COMMAND, WITH HEX 0x00, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x00
	BL LCD_DATA_WRITE


	;MEMORY ACCESS CONTROL AKA MADCLT | DATASHEET PAGE 127
	;WE WANT TO SET MX (to draw from left to right) AND SET MV (to configure the TFT to be in horizontal landscape mode, not a vertical screen)
	;TODO: ISSUE THE COMMAND MEMORY ACCESS CONTROL, HEXCODE 0x36
	MOV R2, #0x36
	BL LCD_COMMAND_WRITE

	;TODO: SEND ONE NEEDED PARAMETER ONLY WITH MX AND MV SET TO 1. HOW WILL WE SEND PARAMETERS? AS DATA OR AS COMMAND?
	MOV R2, #0x68
	BL LCD_DATA_WRITE



	;COLMOD: PIXEL FORMAT SET | DATASHEET PAGE 134
	;THIS COMMAND LETS US CHOOSE WHETHER WE WANT TO USE 16-BIT COLORS OR 18-BIT COLORS.
	;WE WILL ALWAYS USE 16-BIT COLORS
	;TODO: ISSUE THE COMMAND COLMOD
	MOV R2, #0x3A
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE NEEDED PARAMETER WHICH CORRESPONDS TO 16-BIT RGB AND 16-BIT MCU INTERFACE FORMAT
	MOV R2, #0x55
	BL LCD_DATA_WRITE
	


	;SLEEP OUT | DATASHEET PAGE 101
	;TODO: ISSUE THE SLEEP OUT COMMAND TO EXIT SLEEP MODE (THIS COMMAND TAKES NO PARAMETERS, JUST SEND THE COMMAND)
	MOV R2, #0x11
	BL LCD_COMMAND_WRITE

	;NECESSARY TO WAIT 5ms BEFORE SENDING NEXT COMMAND
	;I WILL WAIT FOR 10MSEC TO BE SURE
	;TODO: DELAY FOR AT LEAST 10ms
	BL delay_1_second


	;DISPLAY ON | DATASHEET PAGE 109
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2, #0x29
	BL LCD_COMMAND_WRITE


	;COLOR INVERSION OFF | DATASHEET PAGE 105
	;NOTE: SOME TFTs HAS COLOR INVERTED BY DEFAULT, SO YOU WOULD HAVE TO INVERT THE COLOR MANUALLY SO COLORS APPEAR NATURAL
	;MEANING THAT IF THE COLORS ARE INVERTED WHILE YOU ALREADY TURNED OFF INVERSION, YOU HAVE TO TURN ON INVERSION NOT TURN IT OFF.
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2, #0x20
	BL LCD_COMMAND_WRITE



	;MEMORY WRITE | DATASHEET PAGE 245
	;WE NEED TO PREPARE OUR TFT TO SEND PIXEL DATA, MEMORY WRITE SHOULD ALWAYS BE ISSUED BEFORE ANY PIXEL DATA SENT
	;TODO: ISSUE MEMORY WRITE COMMAND
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE	


	;TODO: POP ALL PUSHED REGISTERS
	POP {R0-R3, PC}
    ENDFUNC
;#####################################################################################################################################################################









;#####################################################################################################################################################################
ADDRESS_SET     FUNCTION
	;THIS FUNCTION TAKES X1, X2, Y1, Y2
	;IT ISSUES COLUMN ADDRESS SET TO SPECIFY THE START AND END COLUMNS (X1 AND X2)
	;IT ISSUES PAGE ADDRESS SET TO SPECIFY THE START AND END PAGE (Y1 AND Y2)
	;THIS FUNCTION JUST MARKS THE PLAYGROUND WHERE WE WILL ACTUALLY DRAW OUR PIXELS, MAYBE TARGETTING EACH PIXEL AS IT IS.
	;R0 = X1
	;R1 = X2
	;R3 = Y1
	;R4 = Y2

	;PUSHING ANY NEEDED REGISTERS
	PUSH {R0-R4, LR}
	

	;COLUMN ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2A
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING COLUMN, AKA HIGHER 8-BITS OF X1)
	MOV R2, R0
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING COLUMN, AKA LOWER 8-BITS OF X1)
	MOV R2, R0
	BL LCD_DATA_WRITE


	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING COLUMN, AKA HIGHER 8-BITS OF X2)
	MOV R2, R1
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING COLUMN, AKA LOWER 8-BITS OF X2)
	MOV R2, R1
	BL LCD_DATA_WRITE



	;PAGE ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2B
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING PAGE, AKA HIGHER 8-BITS OF Y1)
	MOV R2, R3
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING PAGE, AKA LOWER 8-BITS OF Y1)
	MOV R2, R3
	BL LCD_DATA_WRITE


	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING PAGE, AKA HIGHER 8-BITS OF Y2)
	MOV R2, R4
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING PAGE, AKA LOWER 8-BITS OF Y2)
	MOV R2, R4
	BL LCD_DATA_WRITE

	;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


	;POPPING ALL REGISTERS I PUSHED
	POP {R0-R4, PC}
    ENDFUNC
;#####################################################################################################################################################################





;#####################################################################################################################################################################
DRAWPIXEL   FUNCTION
	PUSH {R0-R5, r10, LR}
	;THIS FUNCTION TAKES X AND Y AND A COLOR AND DRAWS THIS EXACT PIXEL
	;NOTE YOU HAVE TO CALL ADDRESS SET ON A SPECIFIC PIXEL WITH LENGTH 1 AND WIDTH 1 FROM THE STARTING COORDINATES OF THE PIXEL, THOSE STARTING COORDINATES ARE GIVEN AS PARAMETERS
	;THEN YOU SIMPLY ISSUE MEMORY WRITE COMMAND AND SEND THE COLOR
	;R0 = X
	;R1 = Y
	;R10 = COLOR

	;CHIP SELECT ACTIVE, WRITE LOW TO CS
	LDR r3, =GPIOB_ODR
	LDR r4, [r3]
	MOV R5, #1
	LSL R5, #6
	MVN R5, R5
	AND r4, r4, R5
	STR r4, [r3]

	;TODO: SETTING PARAMETERS FOR FUNC 'ADDRESS_SET' CALL, THEN CALL FUNCTION ADDRESS SET
	;NOTE YOU MIGHT WANT TO PERFORM PARAMETER REORDERING, AS ADDRESS SET FUNCTION TAKES X1, X2, Y1, Y2 IN R0, R1, R3, R4 BUT THIS FUNCTION TAKES X,Y IN R0 AND R1
	MOV R3, R1 ;Y1
	ADD R1, R0, #1 ;X2
	ADD R4, R3, #1 ;Y2
	BL ADDRESS_SET


	
	;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


	;SEND THE COLOR DATA | DATASHEET PAGE 114
	;HINT: WE SEND THE HIGHER 8-BITS OF THE COLOR FIRST, THEN THE LOWER 8-BITS
	;HINT: WE SEND THE COLOR OF ONLY 1 PIXEL BY 2 DATA WRITES, THE FIRST TO SEND THE HIGHER 8-BITS OF THE COLOR, THE SECOND TO SEND THE LOWER 8-BITS OF THE COLOR
	;REMINDER: WE USE 16-BIT PER PIXEL COLOR
	;TODO: SEND THE SINGLE COLOR, PASSED IN R10
	MOV R2, R10
	LSR R2, #8
	BL LCD_DATA_WRITE
	MOV R2, R10
	BL LCD_DATA_WRITE


	
	POP {R0-R5, r10, PC}
    ENDFUNC
;#####################################################################################################################################################################



	B skipped
	LTORG
skipped



;##########################################################################################################################################
DRAW_RECTANGLE_FILLED   FUNCTION
	;TODO: IMPLEMENT THIS FUNCTION ENTIRELY, AND SPECIFY THE ARGUMENTS IN COMMENTS, WE DRAW A RECTANGLE BY SPECIFYING ITS TOP-LEFT AND LOWER-RIGHT POINTS, THEN FILL IT WITH THE SAME COLOR
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10
	
	
	PUSH {R0-R12, LR}
	
	push{r0-r4}


	PUSH {R1}
	PUSH {R3}
	
	pop {r1}
	pop {r3}
	
	;THE NEXT FUNCTION TAKES x1, x2, y1, y2
	;R0 = x1
	;R1 = x2
	;R3 = y1
	;R4 = y2
	bl ADDRESS_SET
	
	pop{r0-r4}
	

	SUBS R3, R3, R0
	add r3, r3, #1
	SUBS R4, R4, R1
	add r4, r4, #1
	MUL R3, R3, R4


;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


RECT_FILL_LOOP
	MOV R2, R10
	LSR R2, #8
	BL LCD_DATA_WRITE
	MOV R2, R10
	BL LCD_DATA_WRITE

	SUBS R3, R3, #1
	CMP R3, #0
	BGT RECT_FILL_LOOP


END_RECT_FILL
	POP {R0-R12, PC}

    ENDFUNC
;#####################################################################################################################################################################





;#####################################################################################################################################################################
SEGMENT_POSITIONS_TIME FUNCTION
	PUSH{R2-R12, LR}
	MOV R1,#130
	CMP R5,#1
	BEQ First_pos
	CMP R5,#2
	BEQ Second_pos
	CMP R5,#3
	BEQ Third_pos
	CMP R5,#4
	BEQ Fourth_pos
	CMP R5,#5
	BEQ Fifth_pos
	CMP R6,#6
	BEQ Sixth_pos
First_pos 		;TENS OF HOUR
	MOV R0,#20
	B FINAL
Second_pos		;ONES OF HOUR
	MOV R0,#70
	B FINAL
Third_pos		;TENS OF MINUTE
	MOV R0,#160
	B FINAL
Fourth_pos		;ONES OF MINUTE
	MOV R0,#210
	B FINAL
Fifth_pos		;TENS OF SECOND
	MOV R0,#250
	B FINAL
Sixth_pos		;ONES OF SECOND
	MOV R0,#285
	B FINAL
FINAL
	POP {R2-R12, PC}
	ENDFUNC
;#####################################################################################################################################################################





;#####################################################################################################################################################################
DRAW_9_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTB_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTF_SMALL
	BL DRAW_SEGMENTG_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_8_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTB_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTF_SMALL
	BL DRAW_SEGMENTG_SMALL
	BL DRAW_SEGMENTE_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_7_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTF_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_6_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTB_SMALL
	BL DRAW_SEGMENTE_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTF_SMALL
	BL DRAW_SEGMENTG_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_5_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTB_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTF_SMALL
	BL DRAW_SEGMENTG_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_4_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTB_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTF_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC
	
	
DRAW_1_TO_9_SMALL FUNCTION
	
	PUSH {LR}
    CMP R2, #0
    BEQ DRAW_0_SMALL
    CMP R2, #1
    BEQ DRAW_1_SMALL
    CMP R2, #2
    BEQ DRAW_2_SMALL
    CMP R2, #3
    BEQ DRAW_3_SMALL
    CMP R2, #4
    BEQ DRAW_4_SMALL
    CMP R2, #5
    BEQ DRAW_5_SMALL
    CMP R2, #6
    BEQ DRAW_6_SMALL
    CMP R2, #7
    BEQ DRAW_7_SMALL
    CMP R2, #8
    BEQ DRAW_8_SMALL
    CMP R2, #9
    BEQ DRAW_9_SMALL
    pop {PC}
	endfunc
DRAW_3_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTF_SMALL
	BL DRAW_SEGMENTG_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_2_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTE_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTD_SMALL
	BL DRAW_SEGMENTG_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_1_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTF_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_0_SMALL FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTF_SMALL
	BL DRAW_SEGMENTA_SMALL
	BL DRAW_SEGMENTB_SMALL
	BL DRAW_SEGMENTC_SMALL
	BL DRAW_SEGMENTE_SMALL
	BL DRAW_SEGMENTG_SMALL
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_COLLEN FUNCTION
	PUSH{R0-R12, LR}
	
	MOV R0,#120
	MOV R1,#150
	
	ADD R3,R0,#20
	ADD R4,R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	MOV R0,#120
	MOV R1,#190
	ADD R3,R0,#20
	ADD R4,R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
;#####################################################################################################################################################################



;############################################################################################################################################
DRAW_9 FUNCTION
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTB
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTF
	BL DRAW_SEGMENTG
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_8 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTB
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTF
	BL DRAW_SEGMENTG
	BL DRAW_SEGMENTE
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_7 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTF
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_6 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTB
	BL DRAW_SEGMENTE
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTF
	BL DRAW_SEGMENTG
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_5 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTB
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTF
	BL DRAW_SEGMENTG
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_4 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTB
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTF
	
	POP {R0-R12, PC}
	ENDFUNC
	
	
DRAW_1_TO_9 FUNCTION
	
	PUSH {LR}
    CMP R2, #0
    BEQ DRAW_0
    CMP R2, #1
    BEQ DRAW_1
    CMP R2, #2
    BEQ DRAW_2
    CMP R2, #3
    BEQ DRAW_3
    CMP R2, #4
    BEQ DRAW_4
    CMP R2, #5
    BEQ DRAW_5
    CMP R2, #6
    BEQ DRAW_6
    CMP R2, #7
    BEQ DRAW_7
    CMP R2, #8
    BEQ DRAW_8
    CMP R2, #9
    BEQ DRAW_9
    pop {PC}
	endfunc
DRAW_3 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTF
	BL DRAW_SEGMENTG
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_2 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTE
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTD
	BL DRAW_SEGMENTG
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_1 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTF
	
	POP {R0-R12, PC}
	ENDFUNC

DRAW_0 FUNCTION 
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH{R0-R12, LR}
	
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTF
	BL DRAW_SEGMENTA
	BL DRAW_SEGMENTB
	BL DRAW_SEGMENTC
	BL DRAW_SEGMENTE
	BL DRAW_SEGMENTG 
	
	POP {R0-R12, PC}
	ENDFUNC



;################################################################################################################################################3



;#####################################################################################################################################################################
DRAW_SEGMENTG FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R3, R0,#30
	ADD R4, R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTF FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R0,R0,#21
	ADD R3, R0,#9
	ADD R4, R1,#50
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTE FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#20
	ADD R3, R0,#9
	ADD R4, R1,#40
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTD FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#40
	ADD R3, R0,#30
	ADD R4, R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTC FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R0,R0,#21
	ADD R1,R1,#50
	ADD R3, R0,#9
	ADD R4, R1,#50
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTB FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#60
	ADD R3, R0,#9
	ADD R4, R1,#40
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTA FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#80
	ADD R3, R0,#30
	ADD R4, R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
;####################################################################################################################################################



;####################################################################################################################################################
;FOR SECONDS
DRAW_SEGMENTG_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R3, R0,#25
	ADD R4, R1,#8
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTF_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R0,R0,#17
	ADD R3, R0,#8
	ADD R4, R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTE_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#8
	ADD R3, R0,#8
	ADD R4, R1,#8
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTD_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#16
	ADD R3, R0,#25
	ADD R4, R1,#8
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTC_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R0,R0,#17
	ADD R1,R1,#20
	ADD R3, R0,#8
	ADD R4, R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTB_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#34
	ADD R3, R0,#8
	ADD R4, R1,#16
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC
	
DRAW_SEGMENTA_SMALL FUNCTION
	PUSH{R0-R12, LR}
	
	ADD R1,R1,#32
	ADD R3, R0,#25
	ADD R4, R1,#8
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12, PC}
	ENDFUNC

;####################################################################################################3
; FOR DRAWING DATE

DRAW_LINE_BETWEEN_DATETIME FUNCTION
	PUSH{R0-R12,LR}
	
	MOV R0,#0
	MOV R1,#118
	MOV R3,#320
	MOV R4,#122
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R12,PC}
	ENDFUNC	

DRAW_DASHES_BETWEEN_DATE FUNCTION
	PUSH{R0-R12,LR}
	
	;FIRST DASH(BETWEEN DAY AND MONTH)
	MOV R0,#135
	MOV R1,#30
	ADD R3,R0,#10
	ADD R4,R1,#10
	BL DRAW_RECTANGLE_FILLED
	
	;SECOND DASH(BETWEEN MONTH AND YEAR)
	MOV R0,#185
	MOV R1,#30
	ADD R3,R0,#10
	ADD R4,R1,#10
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R12,PC}
	ENDFUNC	
	

SEGMENT_POSITIONS_DATE FUNCTION
	PUSH{R0-R12,LR}
	
	MOV R1,#20
	CMP R5,#1
	BEQ First_poss
	CMP R5,#2
	BEQ Second_poss
	CMP R5,#3
	BEQ Third_poss
	CMP R5,#4
	BEQ Fourth_poss
	CMP R5,#5
	BEQ Fifth_poss
	CMP R5,#6
	BEQ Sixth_poss
	CMP R5,#7
	BEQ Seventh_poss
	CMP R5,#8
	BEQ Eightth_poss
	
First_poss 		;TENS OF DAY
	MOV R0,#100
	B FINALL
Second_poss		;ONES OF DAY
	MOV R0,#130
	B FINALL
Third_poss		;TENS OF MONTH
	MOV R0,#150
	B FINALL
Fourth_poss		;ONES OF MONTH
	MOV R0,#180
	B FINALL
Fifth_poss		;THOUSANDS OF YEAR
	MOV R0,#200
	B FINALL
Sixth_poss		;HUNDREDS OF YEAR
	MOV R0,#230
	B FINALL
Seventh_poss		;TENS OF YEAR
	MOV R0,#260
	B FINALL
Eightth_poss		;ONES OF YEAR
	MOV R0,#290
	B FINALL
	
FINALL	
	POP{R0-R12,PC}
	ENDFUNC



;#####################################################################################################



;#####################################################################################################################################################################
SETUP   FUNCTION
	;THIS FUNCTION ENABLES PORT E, MARKS IT AS OUTPUT, CONFIGURES SOME GPIO
	;THEN FINALLY IT CALLS LCD_INIT (HINT, USE THIS SETUP FUNCTION DIRECTLY IN THE MAIN)
	PUSH {R0-R12, LR}

    BL PORTA_CONF    

	BL LCD_INIT

	POP {R0-R12, PC}

    ENDFUNC
;#####################################################################################################################################################################

rtc_setup FUNCTION
    ; Enable power clock
    PUSH {R0-R12, LR}
    LDR R0, =0x4002101C       ; RCC_APB1ENR address
    LDR R1, [R0]
    ORR R1, R1, #0x10000000	; Enable PWR clock (Bit 28)
	ORR R1, R1, #0x08000000 	
    STR R1, [R0]

    ; Unlock backup domain
    LDR R0, =0x40007000	; PWR_CR address
    LDR R1, [R0]
    ORR R1, R1, #0x0100        ; Disable backup domain protection
    STR R1, [R0]
	; Reset Backup Domain
	LDR R0, =0x40021020        ; RCC_BDCR address
	LDR R1, [R0]
	ORR R1, R1, #0x10000       ; Set BDRST (Bit 16)
	STR R1, [R0]
	BIC R1, R1, #0x10000       ; Clear BDRST
	STR R1, [R0]

    ; Enable LSI oscillator
    LDR R0, =0x40021024        ; RCC_CSR address
    LDR R1, [R0]
    ORR R1, R1, #0x01          ; Enable LSI (Bit 0)
    STR R1, [R0]
	BL delay_1_second  
Wait_LSI_Ready
    LDR R1, [R0]
    TST R1, #0x02              ; Check LSI ready flag (Bit 1)
   
               ; Timeout counter
    BEQ Wait_LSI_Ready


    ; Select LSI as RTC clock source
    LDR R0, =0x40021020        ; RCC_BDCR address
    LDR R1, [R0]
    BIC R1, R1, #0x0300        ; Clear RTCSEL (Bits 8-9)
    ORR R1, R1, #0x0200        ; Set RTCSEL to LSI (10)
    ORR R1, R1, #0x8000        ; Enable RTC (Bit 15)
    STR R1, [R0]

  
    ; Enter RTC configuration mode
    LDR R0, =0x40002800        ; RTC base address
    LDR R1, [R0,#0x04]
    ORR R1, R1, #0x10          ; Set CNF bit (Bit 4)
    STR R1, [R0,#0x04]

    ; Set prescaler for LSI (40 kHz / 1 Hz - 1 = 39999)
    LDR R2, =39999           ; Prescaler value (0x9C3F)
	MOV R3, R2, LSR #16      ; Extract higher bits
	STR R3, [R0, #0x08]      ; Write to RTC_PRLH
	MOV R3, R2, LSL #16
	MOV R3, R3, LSR #16      ; Extract lower bits
	STR R3, [R0, #0x0C]      ; Write to RTC_PRLL

    ; Initialize RTC counter to 21 minutes 35 seconds (1295 seconds)
    

    ; Exit RTC configuration mode
    LDR R1, [R0,#0x04]
    BIC R1, R1, #0x10          ; Clear CNF bit
    STR R1, [R0,#0x04]

    POP {R0-R12, PC}
    ENDFUNC



;########################################################################################################################################################
0
;########################################################################################################################################################
read_rtc FUNCTION
    ; Read RTC counter (32-bit)
    PUSH {R4, R2, LR}

    ; Read high part of the counter (RTC_CNTH)
    LDR R0, =0x40002818        ; RTC_CNTH address
    LDRH R1, [R0]              ; Read high 16 bits
    ; Read low part of the counter (RTC_CNTL)
    LDR R0, =0x4000281C        ; RTC_CNTL address
    LDRH R2, [R0]              ; Read low 16 bits

    ; Combine high and low into a full 32-bit value
    LSL R1, R1, #16            ; Shift high bits to the upper 16 bits
    ORR R3, R1, R2             ; Combine high and low bits into 32-bit counter (R3)

    ; Convert to hours, minutes, seconds
    MOV R4, #3600              ; Hours divisor
    UDIV R0, R3, R4            ; R0 = hours (counter / 3600)
    MLS R3, R0, R4, R3         ; R3 = remaining seconds (counter % 3600)

    MOV R4, #60                ; Minutes divisor
    UDIV R1, R3, R4            ; R1 = minutes (remaining seconds / 60)
    MLS R3, R1, R4, R3         ; R3 = seconds (remaining seconds % 60)

    ; Return hours in R0, minutes in R1, and seconds in R3
    POP {R4, R2, PC}           ; Restore registers and return

ENDFUNC





;########################################################################################################################################################

;########################################################################################################################################################
PORTA_CONF  FUNCTION
    PUSH {R0-R2, LR}
    ; Enable GPIOA clock
    LDR R0, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R1, [R0]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R1, R1, R2, LSL #2        ; Set bit 2 to enable GPIOA clock
    STR R1, [R0]                 ; Write the updated value back to RCC_APB2ENR
    
    ; Configure PORT A AS OUTPUT (LOWER 8 PINS)
    LDR R0, =GPIOA_CRL                  
    MOV R2, #0x33333333     ;ALL 8 LOWER PINS OF PORT A AS OUTPUT WITH MAX SPEED OF 50 MHZ
    STR R2, [R0]

    ; Configure PORT A AS OUTPUT (HIGHER 8 PINS)
    LDR R0, =GPIOA_CRH           ; Address of GPIOC_CRH register
    MOV R2, #0x33333333     ;ALL 8 LOWER PINS OF PORT A AS OUTPUT WITH MAX SPEED OF 50 MHZ
    STR R2, [R0]                 ; Write the updated value back to GPIOC_CRH



    ; Enable GPIOC clock
    LDR R0, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R1, [R0]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R1, R1, R2, LSL #4        ; Set bit 4 to enable GPIOC clock
    STR R1, [R0]                 ; Write the updated value back to RCC_APB2ENR
    
    ; Configure PC13 as input pull up 
    LDR R0, =GPIOC_CRH           ; Address of GPIOC_CRH register
    LDR R1, [R0]                 ; Read the current value of GPIOC_CRH
    MOV R1, #0x88888888      ; Set mode bits for pin 13 (input mode)
    STR R1, [R0]                 ; Write the updated value back to GPIOC_CRH

	LDR R0, =GPIOC_ODR
	MOV R1, #0x00
	STR R1, [R0]


    ; Enable GPIOB clock
    LDR R0, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R1, [R0]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R1, R1, R2, LSL #3        ; Set bit 3 to enable GPIOB clock
    STR R1, [R0]                 ; Write the updated value back to RCC_APB2ENR
    
    
    LDR R0, =GPIOB_CRL           ; Address of GPIOC_CRL register
    MOV R1, #0x33333333      ; Set mode bits for pin 13 (output mode, max speed 50 MHz)
    STR R1, [R0]                 ; Write the updated value back to GPIOC_CRH


    LDR R0, =GPIOB_CRH           ; Address of GPIOC_CRL register
    MOV R1, #0x33333333      ; Set mode bits for pin 13 (output mode, max speed 50 MHz)
    STR R1, [R0]                 ; Write the updated value back to GPIOC_CRH







    POP{R0-R2, PC}

    ENDFUNC










delay_1_second FUNCTION
    PUSH {R0-R12, LR}               ; Push R4 and Link Register (LR) onto the stack
    LDR R0, =INTERVAL           ; Load the delay count
DelayInner_Loop
        SUBS R0, #1             ; Decrement the delay count
		cmp	R0, #0
        BGT DelayInner_Loop     ; Branch until the count becomes zero
    
    POP {R0-R12, PC}                ; Pop R4 and return from subroutine
	ENDFUNC

	
	





delay_10_MILLIsecond FUNCTION
    PUSH {R0-R12, LR}               ; Push R4 and Link Register (LR) onto the stack
    LDR R0, =INTERVAL           ; Load the delay count
DelayInner_Loop2
        SUBS R0, #1000             ; Decrement the delay count
		cmp	R0, #0
        BGT DelayInner_Loop2     ; Branch until the count becomes zero
    
    POP {R0-R12, PC}                ; Pop R4 and return from subroutine
	ENDFUNC



	END