	AREA MYDATA, DATA, READWRITE
	;IMPORT BLACK
	
	AREA	MYCODE, CODE, READONLY
	;import Digits_Main
	;IMPORT SETUP
	
	;IMPORT GPIOA_BASE
	;IMPORT GPIOA_ODR
	INCLUDE Macros.s
	;import RCC_APB2ENR
	;INCLUDE Setup.s
	;IMPORT CHECK_PIN
	;IMPORT SET_PIN
	;IMPORT CLEAR_PIN
	INCLUDE internRTC.s
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
loop1
	LDR R0,= GPIOB_IDR
	LDR R4, [R0]            ; Load the value of the register
	MOV R3, #1              ; Load 1 into R3
	LSL R3, R3, #12	   ; Shift left to create the mask for the pin
	AND R4, R4, R3       ; AND the register value with the mask
    
	LDR R0,= GPIOB_ODR
	cmp r4, #0
	BNE	 turnON
	
turnOFF
    LDR R1, [R0]
    BIC R1, R1, #(1 << 3)       ; Clear PB1
    STR R1, [R0]
	b loop1

;	LDR R4, [R0]            ; Load the current value of the register
;	MOV R3, #1              ; Load 1 into R3
;	LSL R3, R3, #1   ; Shift left to create the mask for the pin
;	MVN R3, R3              ; Invert the mask
;	AND R4, R4, R3          ; Clear the specific pin
;	STR R4, [R0]            ; Store the updated value back to the register
;	b loop1
turnON
	LDR R4, [R0]            ; Load the current value of the register
	MOV R3, #1              ; Load 1 into R3
	LSL R3, R3,#3    ; Shift left to create the mask for the pin
	ORR R4, R4, R3          ; Set the pin high
	STR R4, [R0]            ; Store the updated value back to the register
	b loop1
	;mov r5,#0
	;mov r6,#0
	;mov r7,#9

	;ldr r10, =BLACK
	;BL Digits_Main
;loop

;repeat
	;SET_PIN GPIOA_BASE, GPIO_ODR, #6
	

	ENDFUNC
