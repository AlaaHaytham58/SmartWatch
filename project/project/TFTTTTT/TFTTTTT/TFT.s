	AREA MYDATA, DATA, READONLY

RCC_BASE EQU 0x40021000
RCC_APB2ENR EQU RCC_BASE + 0x18 ;this register is responsible for enabling certain ports, by making the clock affect the target port.

GPIOA_BASE EQU 0x40010800	;Base of port E
;this is where you write your data as an output into the port
GPIOA_ODR	EQU GPIOA_BASE+0x0C   	;output register of port E, PE0 - PE15
GPIOA_CRL	EQU GPIOA_BASE+0x00		;this is where you configure the port's direction as output
GPIOA_CRH   EQU GPIOA_BASE+0x04	


;GPIOC_BASE EQU 0x40020800
;GPIOC_PUPDR EQU GPIOC_BASE + 0x0C
;GPIOC_IDR EQU GPIOC_BASE + 0x10

RST_PIN EQU 8
CS_PIN EQU 9
RS_PIN EQU 10
WR_PIN EQU 11
RD_PIN EQU 12


AFIO_BASE		EQU		0x40010000   ;in TA's code but we dont know why
AFIO_MAPR	EQU		AFIO_BASE + 0x04   ;in TA's code but we dont know why

INTERVAL EQU 0x186004		;just a number to perform the delay. this number takes roughly 1 second to decrement until it reaches 0


;the following are pins connected from the TFT to our EasyMX board
;RD = PE10		Read pin	--> to read from touch screen input 
;WR = PE11		Write pin	--> to write data/command to display
;RS = PE12		Command pin	--> to choose command or data to write
;CS = PE15		Chip Select	--> to enable the TFT, lol	(active low)
;RST= PE8		Reset		--> to reset the TFT (active low)
;D0-7 = PE0-7	Data BUS	--> Put your command or data on this bus


;just some color codes, 16-bit colors coded in RGB 565
BLACK	EQU   	0x0000
BLUE 	EQU  	0x001F
RED  	EQU  	0xF800
RED2   	EQU 	0x4000
GREEN 	EQU  	0x07E0
CYAN  	EQU  	0x07FF
MAGENTA EQU 	0xF81F
YELLOW	EQU  	0xFFE0
WHITE 	EQU  	0xFF1F
GREEN2 	EQU 	0x2FA4
CYAN2 	EQU  	0x07FF

	
	AREA	MYCODE, CODE, READONLY
		
	EXPORT __main
ENTRY
	
__main FUNCTION

	;This is the main funcion, you should only call two functions, one that sets up the TFT
	;And the other that draws a rectangle over the entire screen (ie from (0,0) to (320,240)) with a certain color of your choice

	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10

	;CALL FUNCTION SETUP
	BL SETUP
	
	;mov r0,#0
	;mov r1,#0
	;MOV R3,#320
	;mov r4,#240
	;mov r10,BLACK
	;BL DRAW_RECTANGLE_FILLED
	
	mov r5,#0
	mov r6,#0

	ldr r10, =BLACK
	BL ZERO
	
	mov r5,#80	
	mov r6,#0
	MOV R7,#4
	ldr r10, =BLACK
	BL ONE
	

	
	
	;ldr r10, =RED

	;mov r0, #0
	;mov r1, #0
	;mov r3, #320
	;mov r4, #80
	
	;bl DRAW_RECTANGLE_FILLED
	
	
	;ldr r10, =BLACK
	;mov r0, #0
	;mov r1, #80
	;mov r3, #320
	;mov r4, #160
	
	;bl DRAW_RECTANGLE_FILLED
	

	;ldr r10, =BLUE
	;mov r0, #0
	;mov r1, #160
	;mov r3, #320
	;mov r4, #240
	
	;bl DRAW_RECTANGLE_FILLED

	
;	ldr r10, =GREEN
;	mov r0, #150
;	mov r1, #100
;	mov r3, #170
;	mov r4, #140
;	
;	bl DRAW_RECTANGLE_FILLED
	

	
	
	
	

	;BL LCD_INIT
	;FINAL TODO: DRAW THE ENTIRE SCREEN WITH A CERTAIN COLOR

	;TODO: draw egypt
	


	ENDFUNC










;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ FUNCTIONS' DEFINITIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



	



;#####################################################################################################################################################################
LCD_WRITE FUNCTION
	;this function takes what is inside r2 and writes it to the tft
	;this function writes 8 bits only
	;later we will choose whether those 8 bits are considered a command, or just pure data
	;your job is to just write 8-bits (regardless if data or command) to PE0-7 and set WR appropriately
	;arguments: R2 = data to be written to the D0-7 bus

	;TODO: PUSH THE NEEDED REGISTERS TO SAVE THEIR CONTENTS. HINT: Push any register you will modify inside the function, and LR 
	PUSH{R0-R12, LR}
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 0 ;;;;;;;;;;;;;;;;;;;;;
	;TODO: RESET WR TO 0
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<WR_PIN)
	STR R1,[R0]
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDR R0, =GPIOA_ODR         ; Load address of GPIOA_ODR
	LDR R1, [R0]               ; Load current value of GPIOA_ODR
	BIC R1, R1, #0xFF          ; Clear bits 0-7
	ORR R1, R1, R2             ; Set the lower 8 bits of R2
	STR R1, [R0]               ; Store the new value back to GPIOA_ODR



	;;;;;;;;;;;;; HERE YOU PUT YOUR DATA which is in R2 TO PE0-7 ;;;;;;;;;;;;;;;;;
	;TODO: SET PE0-7 WITH THE LOWER 8-bits of R2
	;only write the lower byte to PE0-7

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET WR TO 1 AGAIN (ie make a rising edge)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<WR_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	POP{R0-R12, PC}
	;TODO: POP THE REGISTERS YOU JUST PUSHED, and PC
	ENDFUNC
	
;#####################################################################################################################################################################











;#####################################################################################################################################################################
LCD_COMMAND_WRITE FUNCTION
	;this function writes a command to the TFT, the command is read from R2
	;it writes LOW to RS first to specify that we are writing a command not data.
	;then it normally calls the function LCD_WRITE we just defined above
	;arguments: R2 = data to be written on D0-7 bus

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH{R0-R12, LR}

	

	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RD to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RD_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RS to 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 0 (to specify that we are writing commands not data on the D0-7 bus)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<RS_PIN)
	;AND R1, R1,R3
	STR R1,[R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ALL REGISTERS YOU PUSHED
	POP{R0-R12, PC}
	ENDFUNC

;#####################################################################################################################################################################






;#####################################################################################################################################################################
LCD_DATA_WRITE FUNCTION
	;this function writes Data to the TFT, the data is read from R2
	;it writes HIGH to RS first to specify that we are writing actual data not a command.
	;arguments: R2 = data

	;TODO: PUSH ANY NEEDED REGISTERS
	
	
	PUSH{R0-R12, LR}


	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RD to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RD_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	



	;;;;;;;;;;;;;;;;;;;; SETTING RS to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 1 (to specify that we are sending actual data not a command on the D0-7 bus)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RS_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ANY REGISTER YOU PUSHED
	POP{R0-R12, PC}
	ENDFUNC

;#####################################################################################################################################################################




; REVISE WITH YOUR TA THE LAST 3 FUNCTIONS (LCD_WRITE, LCD_COMMAND_WRITE AND LCD_DATA_WRITE BEFORE PROCEEDING)




;#####################################################################################################################################################################
LCD_INIT FUNCTION
	;This function executes the minimum needed LCD initialization measures
	;Only the necessary Commands are covered
	;Eventho there are so many more in the DataSheet

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH{R0-R12, LR}


	;;;;;;;;;;;;;;;;; HARDWARE RESET (putting RST to high then low then high again) ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RESET PIN TO HIGH
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RST_PIN)
	STR R1, [R0]


	;TODO: DELAY FOR SOME TIME (USE ANY FUNCTION AT THE BOTTOM OF THIS FILE)
	BL delay_half_second
	
	;TODO: RESET RESET PIN TO LOW
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<RST_PIN)
	STR R1,[R0]

	;TODO: DELAY FOR SOME TIME (USE ANY FUNCTION AT THE BOTTOM OF THIS FILE)
	BL delay_half_second

	;TODO: SET RESET PIN TO HIGH AGAIN
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RST_PIN)
	STR R1, [R0]

	;TODO: DELAY FOR SOME TIME (USE ANY FUNCTION AT THE BOTTOM OF THIS FILE)
	BL delay_half_second
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






	;;;;;;;;;;;;;;;;; PREPARATION FOR WRITE CYCLE SEQUENCE (setting CS to high, then configuring WR and RD, then resetting CS to low) ;;;;;;;;;;;;;;;;;;
	;TODO: SET CS PIN HIGH
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<CS_PIN)
	STR R1, [R0]

	;TODO: SET WR PIN HIGH
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<WR_PIN)
	STR R1, [R0]

	;TODO: SET RD PIN HIGH
	
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RD_PIN)
	STR R1, [R0]
	;TODO: SET CS PIN LOW
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<CS_PIN)
	STR R1,[R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SOFTWARE INITIALIZATION SEQUENCE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV R2, #0x01 ; Software Reset
	BL LCD_COMMAND_WRITE
	BL delay_1_second

	MOV R2, #0x28 ; Display OFF
	BL LCD_COMMAND_WRITE
	
	
	;ISSUE THE "SET CONTRAST" COMMAND, ITS HEX CODE IS 0xC5
	MOV R2, #0xC5 ;1100 0101
	BL LCD_COMMAND_WRITE

	;THIS COMMAND REQUIRES 2 PARAMETERS TO BE SENT AS DATA, THE VCOM H, AND THE VCOM L
	;WE WANT TO SET VCOM H TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 1111111 OR 0x7F HEXA
	;SEND THE FIRST PARAMETER (THE VCOM H) NEEDED BY THE COMMAND, WITH HEX 0x7F, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x7F ;0111 1111 0x7F
	BL LCD_DATA_WRITE

	;WE WANT TO SET VCOM L TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 00000000 OR 0x00 HEXA
	;SEND THE SECOND PARAMETER (THE VCOM L) NEEDED BY THE CONTRAST COMMAND, WITH HEX 0x00, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x00 ;00000
	BL LCD_DATA_WRITE


	;MEMORY ACCESS CONTROL AKA MADCLT | DATASHEET PAGE 127
	;WE WANT TO SET MX (to draw from left to right) AND SET MV (to configure the TFT to be in horizontal landscape mode, not a vertical screen)
	;TODO: ISSUE THE COMMAND MEMORY ACCESS CONTROL, HEXCODE 0x36
	MOV R2,#0x36 ;0011 0110
	BL LCD_COMMAND_WRITE


	;TODO: SEND ONE NEEDED PARAMETER ONLY WITH MX AND MV SET TO 1. HOW WILL WE SEND PARAMETERS? AS DATA OR AS COMMAND?
	MOV R2,#0x68 ;0110 0000 ;60
	BL LCD_DATA_WRITE
	
	
	;COLMOD: PIXEL FORMAT SET | DATASHEET PAGE 134
	;THIS COMMAND LETS US CHOOSE WHETHER WE WANT TO USE 16-BIT COLORS OR 18-BIT COLORS.
	;WE WILL ALWAYS USE 16-BIT COLORS
	;TODO: ISSUE THE COMMAND COLMOD
	MOV R2,#0x3A ;0011 1010
	BL LCD_COMMAND_WRITE


	;TODO: SEND THE NEEDED PARAMETER WHICH CORRESPONDS TO 16-BIT RGB AND 16-BIT MCU INTERFACE FORMAT
	MOV R2,#0x55 ;0101 0101
	BL LCD_DATA_WRITE
	

	;SLEEP OUT | DATASHEET PAGE 101
	;TODO: ISSUE THE SLEEP OUT COMMAND TO EXIT SLEEP MODE (THIS COMMAND TAKES NO PARAMETERS, JUST SEND THE COMMAND)
	MOV R2,#0x11 ;0001 0001
	BL LCD_COMMAND_WRITE


	;NECESSARY TO WAIT 5ms BEFORE SENDING NEXT COMMAND
	;I WILL WAIT FOR 10MSEC TO BE SURE
	;TODO: DELAY FOR AT LEAST 10ms
	BL delay_1_second ;half


	;DISPLAY ON | DATASHEET PAGE 109
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2,#0x29 ;0010 1001
	BL LCD_COMMAND_WRITE
	
	
	;COLOR INVERSION OFF | DATASHEET PAGE 105
	;NOTE: SOME TFTs HAS COLOR INVERTED BY DEFAULT, SO YOU WOULD HAVE TO INVERT THE COLOR MANUALLY SO COLORS APPEAR NATURAL
	;MEANING THAT IF THE COLORS ARE INVERTED WHILE YOU ALREADY TURNED OFF INVERSION, YOU HAVE TO TURN ON INVERSION NOT TURN IT OFF.
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2,#0x20 ;0010 0001
	BL LCD_COMMAND_WRITE


	;MEMORY WRITE | DATASHEET PAGE 245
	;WE NEED TO PREPARE OUR TFT TO SEND PIXEL DATA, MEMORY WRITE SHOULD ALWAYS BE ISSUED BEFORE ANY PIXEL DATA SENT
	;TODO: ISSUE MEMORY WRITE COMMAND
	MOV R2,#0x2C ;0010 1100
	BL LCD_COMMAND_WRITE


	;TODO: POP ALL PUSHED REGISTERS
	POP{R0-R12, PC}
	ENDFUNC


;#####################################################################################################################################################################






; REVISE THE FUNCTION LCD_INIT WITH YOUR TA BEFORE PROCEEDING






;#####################################################################################################################################################################
ADDRESS_SET FUNCTION
	;THIS FUNCTION TAKES X1, X2, Y1, Y2
	;IT ISSUES COLUMN ADDRESS SET TO SPECIFY THE START AND END COLUMNS (X1 AND X2)
	;IT ISSUES PAGE ADDRESS SET TO SPECIFY THE START AND END PAGE (Y1 AND Y2)
	;THIS FUNCTION JUST MARKS THE PLAYGROUND WHERE WE WILL ACTUALLY DRAW OUR PIXELS, MAYBE TARGETTING EACH PIXEL AS IT IS.
	;R0 = X1
	;R1 = X2
	;R3 = Y1
	;R4 = Y2

	;PUSHING ANY NEEDED REGISTERS
	PUSH {R0-R12, LR}
	

	;COLUMN ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2A ;0010 1010
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING COLUMN, AKA HIGHER 8-BITS OF X1)
	mov r5, r0, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE  
	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING COLUMN, AKA LOWER 8-BITS OF X1)
	mov r2, r0
	BL LCD_DATA_WRITE

	
	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING COLUMN, AKA HIGHER 8-BITS OF X2)
	mov r5, r1, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE  

	
	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING COLUMN, AKA LOWER 8-BITS OF X2)
	mov r2, r1
	BL LCD_DATA_WRITE

	;PAGE ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2B ;0010 1011
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING PAGE, AKA HIGHER 8-BITS OF Y1)
	mov r5, r3, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE  


	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING PAGE, AKA LOWER 8-BITS OF Y1)
	mov r2, r3
	BL LCD_DATA_WRITE
	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING PAGE, AKA HIGHER 8-BITS OF Y2)
	mov r5, r4, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING PAGE, AKA LOWER 8-BITS OF Y2)
	mov r2, r4
	BL LCD_DATA_WRITE

	;MEMORY WRITE
	MOV R2, #0x2C ;0010 1100
	BL LCD_COMMAND_WRITE


	;POPPING ALL REGISTERS I PUSHED
	POP {R0-R12, PC}
	
	ENDFUNC
;#####################################################################################################################################################################



;#####################################################################################################################################################################
DRAWPIXEL
	PUSH {R0-R4, r10, LR}
	;THIS FUNCTION TAKES X AND Y AND A COLOR AND DRAWS THIS EXACT PIXEL
	;NOTE YOU HAVE TO CALL ADDRESS SET ON A SPECIFIC PIXEL WITH LENGTH 1 AND WIDTH 1 FROM THE STARTING COORDINATES OF THE PIXEL, THOSE STARTING COORDINATES ARE GIVEN AS PARAMETERS
	;THEN YOU SIMPLY ISSUE MEMORY WRITE COMMAND AND SEND THE COLOR
	;R0 = X
	;R1 = Y
	;R10 = COLOR

	;CHIP SELECT ACTIVE, WRITE LOW TO CS
	LDR r3, =GPIOA_ODR
	LDR r4, [r3]
	AND r4, r4, #0xFFFF7FFF
	STR r4, [r3]

	;TODO: SETTING PARAMETERS FOR FUNC 'ADDRESS_SET' CALL, THEN CALL FUNCTION ADDRESS SET
	;NOTE YOU MIGHT WANT TO PERFORM PARAMETER REORDERING, AS ADDRESS SET FUNCTION TAKES X1, X2, Y1, Y2 IN R0, R1, R3, R4 BUT THIS FUNCTION TAKES X,Y IN R0 AND R1
	


	
	;MEMORY WRITE
	MOV R2, #0x2C ;0010 1100
	BL LCD_COMMAND_WRITE


	;SEND THE COLOR DATA | DATASHEET PAGE 114
	;HINT: WE SEND THE HIGHER 8-BITS OF THE COLOR FIRST, THEN THE LOWER 8-BITS
	;HINT: WE SEND THE COLOR OF ONLY 1 PIXEL BY 2 DATA WRITES, THE FIRST TO SEND THE HIGHER 8-BITS OF THE COLOR, THE SECOND TO SEND THE LOWER 8-BITS OF THE COLOR
	;REMINDER: WE USE 16-BIT PER PIXEL COLOR
	;TODO: SEND THE SINGLE COLOR, PASSED IN R10
	


	
	POP {R0-R4, r10, PC}
	ENDFUNC
;#####################################################################################################################################################################


;	REVISE THE PREVIOUS TWO FUNCTIONS (ADDRESS_SET AND DRAW_PIXEL) WITH YOUR TA BEFORE PROCEEDING








;##########################################################################################################################################
DRAW_RECTANGLE_FILLED
	;TODO: IMPLEMENT THIS FUNCTION ENTIRELY, AND SPECIFY THE ARGUMENTS IN COMMENTS, WE DRAW A RECTANGLE BY SPECIFYING ITS TOP-LEFT AND LOWER-RIGHT POINTS, THEN FILL IT WITH THE SAME COLOR
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10
	PUSH {R0-R12, LR}
	

	
	mov r9, r1
	mov r1, r3
	mov r3, r9
	
	BL ADDRESS_SET
	


	sub r11, r1, r0
	sub r12, r4, r3
	mul r11, r11, r12

loop

	mov r5, r10, lsr #8
	mov r2, r5
	BL LCD_DATA_WRITE
	mov r2, r10
	BL LCD_DATA_WRITE
	
	subs r11, #1
	bne loop
	
	POP {R0-R12, PC}
;##########################################################################################################################################
	ENDFUNC


Horizontal_Segment1
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH {R0-R12, LR}
	
	add r5,#5
	add r6,#5
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#30 
	
	mov r4,r1
	add r4,#5
	
	BL DRAW_RECTANGLE_FILLED
	POP {R0-R12, PC}
	ENDFUNC

Horizontal_Segment2
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH {R0-R12, LR}
	
	add r5,#5
	add r6,#45 ;40
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#30 ;x2
	
	mov r4,r1
	add r4,#5
	
	BL DRAW_RECTANGLE_FILLED
	POP {R0-R12, PC}
	ENDFUNC
	
	
	
Horizontal_Segment3
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	PUSH {R0-R12, LR}
	
	add r5,#5
	add r6,#90
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#30 
	
	mov r4,r1
	add r4,#5
	
	BL DRAW_RECTANGLE_FILLED
	POP {R0-R12, PC}
	ENDFUNC

	
	
	
	
	



Vertical_Segment1
	PUSH {r0-R12, LR}
	
	add r5,#5
	add r6,#15
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#5 ;R3 = X1 + 5
	
	mov r4,r1
	add r4,#35
	BL DRAW_RECTANGLE_FILLED
	POP {r0-r12, PC}
	ENDFUNC

Vertical_Segment2
	PUSH {r0-R12, LR}
	
	add r5,#5
	add r6,#55
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#5 ;R3 = X1 + 5
	
	mov r4,r1
	add r4,#35
	BL DRAW_RECTANGLE_FILLED
	POP {r0-r12, PC}
	ENDFUNC
	
	
Vertical_Segment3
	PUSH {r0-R12, LR}
	
	add r5,#45
	add r6,#15
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#5 ;R3 = X1 + 5
	
	mov r4,r1
	add r4,#35
	BL DRAW_RECTANGLE_FILLED
	POP {r0-r12, PC}
	ENDFUNC

Vertical_Segment4
	PUSH {r0-r12, LR}
	
	add r5,#45
	add r6,#55
	
	mov r0,r5 ;R0 = R5 = X1
	mov r1,r6 ;R1 = R6 = Y1
	
	mov r3,r0  ;R3 = X1
	add r3,#5 ;R3 = X1 + 5 =X2
	
	mov r4,r1
	add r4,#35
	BL DRAW_RECTANGLE_FILLED
	POP {r0-r12, PC}
	ENDFUNC


ZERO
	PUSH {R0-R12, LR}
	BL Horizontal_Segment1
	bl Horizontal_Segment3
	
	bl Vertical_Segment1
	bl Vertical_Segment2
	bl Vertical_Segment3
	bl Vertical_Segment4
	POP {r0-r12, PC}
	ENDFUNC
	
ONE
	PUSH {R0-R12, LR}
	bl Vertical_Segment1
	bl Vertical_Segment2
	POP {r0-r12, PC}
	ENDFUNC

TWO
	PUSH {R0-R12, LR}
	bl Horizontal_Segment1
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	
	bl Vertical_Segment1
	bl Vertical_Segment4
	POP {r0-r12, PC}
	ENDFUNC

THREE
	PUSH {R0-R12, LR}
	bl Horizontal_Segment1
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	
	bl Vertical_Segment1
	bl Vertical_Segment2
	POP {r0-r12, PC}
	ENDFUNC

FOUR
	PUSH {R0-R12, LR}
	bl Horizontal_Segment2
	
	bl Vertical_Segment1
	bl Vertical_Segment2
	bl Vertical_Segment3
	POP {r0-r12, PC}
	ENDFUNC
	
FIVE
	PUSH {R0-R12, LR}
	bl Horizontal_Segment1
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	
	bl Vertical_Segment3
	bl Vertical_Segment2
	POP {r0-r12, PC}
	ENDFUNC
	
SIX
	PUSH {R0-R12, LR}
	bl Horizontal_Segment1
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	
	bl Vertical_Segment3
	bl Vertical_Segment2
	bl Vertical_Segment4
	POP {r0-r12, PC}
	ENDFUNC
SEVEN
	PUSH {R0-R12, LR}
	bl Horizontal_Segment1
	
	bl Vertical_Segment1
	bl Vertical_Segment2
	POP {r0-r12, PC}
	ENDFUNC
EIGHT
	PUSH {R0-R12, LR}
	bl Horizontal_Segment1
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	
	bl Vertical_Segment1
	bl Vertical_Segment2
	bl Vertical_Segment3
	bl Vertical_Segment4
	POP {r0-r12,PC}
	ENDFUNC

;NINE
;	PUSH {R0-R12, LR}
;	bl Horizontal_Segment1
;	bl Horizontal_Segment2
;	bl Horizontal_Segment3
;	
;	bl Vertical_Segment1
;	bl Vertical_Segment2
;	bl Vertical_Segment3
;	POP {r0-r12, PC}
;	ENDFUNC


;DRAW_DIGIT
	;X1 = [] r5 reference
	;Y1 = [] r6	reference

	;COLOR = [] r10
	;PUSH {R0-R12, LR}
	
	;bl NUMBER_FIVE
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10
	;R7 = number 0-9
	;CMP r7,#0
	;BEQ	ZERO
	;CMP r7,#1
	;BEQ ONE
	;CMP R7,#2
	;BEQ TWO
	;CMP R7,#3
	;BEQ THREE
	;CMP R7,#4
	;BEQ FOUR
	
	
	
;ZERO
;	BL Horizontal_Segment1
;	bl Horizontal_Segment3
;	bl Vertical_Segment1
;	bl Vertical_Segment2
;	bl Vertical_Segment3
;	bl Vertical_Segment4
;	B ENDFN	
;ONE
	;bl Vertical_Segment1
;	bl Vertical_Segment2
;	B ENDFN
;TWO
;	bl Horizontal_Segment1
;	bl Horizontal_Segment2
;	bl Horizontal_Segment3
	
;	bl Vertical_Segment1
;	bl Vertical_Segment4
;	B ENDFN
;THREE
;	bl Horizontal_Segment1
;	bl Horizontal_Segment2
;	bl Horizontal_Segment3
;	bl Vertical_Segment1
;	bl Vertical_Segment2
;	B ENDFN
;FOUR
;	bl Horizontal_Segment2
;	bl Vertical_Segment1
;	bl Vertical_Segment2
;	bl Vertical_Segment3
;	B ENDFN

;ENDFN
;	POP {R0-R12, PC}
;	ENDFUNC






;#####################################################################################################################################################################
SETUP FUNCTION
	;THIS FUNCTION ENABLES PORT A, MARKS IT AS OUTPUT, CONFIGURES SOME GPIO
	;THEN FINALLY IT CALLS LCD_INIT (HINT, USE THIS SETUP FUNCTION DIRECTLY IN THE MAIN)
	PUSH {R0-R12, LR}

	;Enable GPIOA Clock
	LDR r1, =RCC_APB2ENR
	LDR r0, [r1]
	MOV R2, #1
	ORR r0, r0,r2, LSL #2
	STR r0, [r1]
	
	;Enable AFIO Clock
	LDR R1, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R0, [R1]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R0, R0, R2        		; Set bit 0 to enable afio
    STR R0, [R1]
	
	;
	LDR r0, =GPIOA_CRL
	mov r1, #0x33333333
	STR r1, [r0]
	
	LDR r0, =GPIOA_CRH
	mov r1, #0x33333333
	STR r1, [r0]
	
	BL LCD_INIT

	POP {R0-R12, PC}
	ENDFUNC
;#####################################################################################################################################################################






; HELPER DELAYS IN THE SYSTEM, YOU CAN USE THEM DIRECTLY


;##########################################################################################################################################
delay_1_second
	;this function just delays for 1 second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop
	SUBS r8, #1
	CMP r8, #0
	BGE delay_loop
	POP {R8, PC}
;##########################################################################################################################################




;##########################################################################################################################################
delay_half_second
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop1
	SUBS r8, #2
	CMP r8, #0
	BGE delay_loop1

	POP {R8, PC}
;##########################################################################################################################################


;##########################################################################################################################################
delay_milli_second
	;this function just delays for a millisecond
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop2
	SUBS r8, #1000
	CMP r8, #0
	BGE delay_loop2

	POP {R8, PC}
;##########################################################################################################################################



;##########################################################################################################################################
delay_10_milli_second
	;this function just delays for 10 millisecondS
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop3
	SUBS r8, #100
	CMP r8, #0
	BGE delay_loop3

	POP {R8, PC}
;##########################################################################################################################################
	END