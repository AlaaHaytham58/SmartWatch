	AREA MYDATA, DATA, READWRITE
	;IMPORT BLACK
	
	AREA	MYCODE, CODE, READONLY
	import Digits_Main
	import DRAW_COLLEN
	import DRAW_RECTANGLE_FILLED 
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
	mov r0,#0
	mov r1,#0
	mov r3,#320
	mov r4,#240
	ldr r10, =BLACK
	bl DRAW_RECTANGLE_FILLED
	
	mov r5,#20
	mov r6,#10
	mov r7,#58
	BL Digits_Main

;	mov r5,#90
;	mov r6,#10
;	mov r7,#5
;	BL Digits_Main
	
	MOV R0,#160
	MOV R1,#30
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#10
	mov r7,#8
	BL Digits_Main
		

	mov r5,#260
	mov r6,#10
	mov r7,#1
	BL Digits_Main
	
	mov r7,#58 ;move current minutes in r7 to print it 
	
	mov r5,#20
	mov r6,#10
	
	
	;r12 ->seconds
loop1	
INCREMENT_SECONDS

	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	;BL delay_1_second
	ADD R12,R12,#1
	CMP R12,#59
	BEQ INCREMENT_MIN
	BNE INCREMENT_SECONDS
	
	
INCREMENT_MIN
	BL Digits_Main
	MOV R12,#0  ;restart the seconds
	ADD R7,R7,#1 ;increment the minutes 
	CMP R7,#59 ;compare minute to 59
	BGT INCREMENT_HOUR
    B INCREMENT_SECONDS
	
INCREMENT_HOUR 
	
	MOV R12,#0 ;restart the seoonds
	MOV R7,#60 ; restart the minutes
	ADD R10,R10,#1 ;increment houes
	CMP R10,#24
	BEQ OUTLOOP
	B INCREMENT_SECONDS
	B loop1
	
OUTLOOP
	MOV R10,#0
	MOV R11,#0
	MOV R12,#0
	endfunc	

	end
		
		
 ;DIVIDE THE DIGIT INTO 2 REGISTERS






;	B INCREMENT_SECONDS	

;DRAW_MIN
;	mov r5,#20
;	mov r6,#10
;	mov r7,#1
;	BL Digits_Main

;	mov r5,#90
;	mov r6,#10
;	mov r7,#5
;	BL Digits_Main
;	
;	
;		

;	ADD R3,R0,#20
;	ADD R4,R1,#20

;	mov r5,#190
;	mov r6,#10
;	mov r7,#2
;	BL Digits_Main
;	

;	mov r5,#260
;	mov r6,#10
;	mov r7,#1
;	BL Digits_Main
;	
;	
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#0

;	BL Digits_Main 
;	
;	
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#1


;	BL Digits_Main
;	
;	
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#2


;	BL Digits_Main
;	
;	
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#3


;	BL Digits_Main
;	
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#4


;	BL Digits_Main
	
;	
;	
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#5
;	
;	BL Digits_Main
;	
;	
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	bl delay_1_second
;	
;	mov r5,#0
;	mov r6,#0
;	mov r7,#6
;	;ldr r10, =BLACK
;	BL Digits_Main
;	
	

	;SET_PIN GPIOA_BASE, GPIO_ODR, #6
	

;	ENDFUNC

;SEGMENT_POSITIONS_TIME FUNCTION
;	;PUSH{R0-R4,R7-r12, LR}
;	MOV R6,#10
;	CMP R8,#1
;	BEQ First_pos
;	CMP R8,#2
;	BEQ Second_pos
;	CMP R8,#3
;	BEQ Third_pos
;	CMP R8,#4
;	BEQ Fourth_pos
;	CMP R8,#5
;	BEQ Fifth_pos
;	CMP R8,#6
;	BEQ Sixth_pos
;First_pos 		;TENS OF HOUR
;	MOV R5,#20
;	B FINAL
;Second_pos		;ONES OF HOUR
;	MOV R5,#70
;	B FINAL
;Third_pos		;TENS OF MINUTE
;	MOV R5,#160
;	B FINAL
;Fourth_pos		;ONES OF MINUTE
;	MOV R5,#210
;	B FINAL
;Fifth_pos		;TENS OF SECOND
;	MOV R5,#250
;	B FINAL
;Sixth_pos		;ONES OF SECOND
;	MOV R5,#285
;	B FINAL
;FINAL
;	;POP {R0-R4,r7-r12,PC}
;	ENDFUNC
