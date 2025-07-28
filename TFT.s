	AREA MYDATA, DATA, READWRITE
	;IMPORT BLACK
	
	AREA	MYCODE, CODE, READONLY
	import Digits_Main
	import DRAW_COLLEN
	import DRAW_RECTANGLE_FILLED 
	;import StopWatch_MAIN
	;IMPORT SETUP
	
	;INCLUDE stopwatch_timer.s
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
	;mov r3,#0 ;this line should not be present only for testing 
	;bl Buzzer_init
	;mov r3,#1
	;bl Buzzer_init
	
	mov r0,#0
	mov r1,#0
	mov r3,#320
	mov r4,#240
	ldr r10, =BLACK
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =RED  ;writing color
	ldr r11, =BLACK ;background
	
	;bl toggle_colors
	mov r5,#40
	mov r6,#5
	mov r7,#8      ;stores lower min in r12
	BL Digits_Main
	mov r2,#8
	
	mov r5,#100
	mov r6,#5
	mov r7,#5
	BL Digits_Main
	mov r3,#5
	
	MOV R0,#170
	MOV R1,#30
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#5
	mov r7,#8
	BL Digits_Main
	mov r4,#8	

	mov r5,#260
	mov r6,#5
	mov r7,#1
	BL Digits_Main
	mov r8,#1
	mov r12,#0   ;sec
	;mov r4,#1 ;;to trigger toggle only for now
	;bl StopWatch_MAIN
	;mov r2,#2   ;timer time 
	;bl TIMER_MAIN   ;trial timer
	b loop1
	
	
toggle_colors 

	mov r0,#0
	mov r1,#0
	mov r3,#320
	mov r4,#240
	ldr r10, =BLUE
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =MAGENTA
	ldr r11, =BLUE
	
	
	
	mov r5,#110
	mov r6,#5
	mov r7,r7
	BL Digits_Main

	
	MOV R0,#170
	MOV R1,#30
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#5
	mov r7,#8
	BL Digits_Main
		

	mov r5,#260
	mov r6,#5
	mov r7,#1
	BL Digits_Main

	;r12 ->seconds
loop1	
	cmp r4,#1 ;;should be trigered by sensor (check pin)   atdarb
	BEQ toggle_colors
INCREMENT_SECONDS	
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	add r12,r12,#1
	cmp r12,#60
	BNE sec33
	mov r12,#0
	add r2,r2,#1
	cmp r2,#10
	BNE sec33
	mov r2,#0
	add r3,r3,#1
	cmp r3,#6
	BNE sec33
	mov r3,#0
	add r4,r4,#1
	cmp r4,#10
	BNE sec33
	mov r4,#0
	add r8,r8,#1
	cmp r8,#3
	BNE sec33
	mov r8,#0
sec33
	mov r5,#40
	mov r6,#5
	mov r7,r2      ;stores lower min in r12
	BL Digits_Main
	mov r2,#8
	
	mov r5,#100
	mov r6,#5
	mov r7,r3
	BL Digits_Main

	
	MOV R0,#170
	MOV R1,#30
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#5
	mov r7,r4
	BL Digits_Main
	

	mov r5,#260
	mov r6,#5
	mov r7,r8
	BL Digits_Main
	
;	BL delay_1_second
;	BL delay_1_second
;	BL delay_1_second
;	;BL delay_1_second
;	ADD R12,R12,#1
;	CMP R12,#59
;	BEQ INCREMENT_MIN
;	BNE INCREMENT_SECONDS
;	
;	
;INCREMENT_MIN
;	BL Digits_Main
;	MOV R12,#0  ;restart the seconds
;	ADD R7,R7,#1 ;increment the minutes 
;	CMP R7,#59 ;compare minute to 59
;	BGT INCREMENT_HOUR
;    B INCREMENT_SECONDS
;	
;	
;	
;	
;INCREMENT_HOUR 
;	
;	MOV R12,#0 ;restart the seoonds
;	MOV R7,#60 ; restart the minutes
;	ADD R10,R10,#1 ;increment houes
;	CMP R10,#24
;	
	B INCREMENT_SECONDS
;	B loop1
	
;OUTLOOP
;	MOV R10,#0
;	MOV R11,#0
;	MOV R12,#0

	

	endfunc	
	
Buzzer_init function 
	push{R0-R12,LR}
	cmp r3,#0
	beq stop_buzzer

	
    LDR R0, =GPIOB_ODR
    MOV R2, #1

    MOV R1, #1
    LSL R1, R2
    STR R1, [R0]
    BL delay_1_second
	b end_buzzer
stop_buzzer
	LDR R0, =GPIOB_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<1)
	STR R1,[R0]
	BL delay_1_second
	
end_buzzer
	pop{R0-R12,PC}
	ENDFUNC

StopWatch_MAIN FUNCTION
	PUSH{r0-r12,LR}
	;CMP R7,#0
	;BNE Timer 
	mov r9,#0 ;seconds1
	mov r12,#0 ;seconds2
	mov r2,#0 ;min 1
	mov r3,#0 ;min 2
	
	
	mov r5,#40
	mov r6,#120
	mov r7,r9
	BL Digits_Main

	mov r5,#100
	mov r6,#120
	mov r7,r12
	BL Digits_Main
	
	MOV R0,#170
	MOV R1,#150
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#120
	mov r7,r2
	BL Digits_Main
		

	mov r5,#260
	mov r6,#120
	mov r7,r3
	BL Digits_Main
button1_check 
	LDR R8, =GPIOB_IDR   ; Load the address
	LDR R4, [R8]            ; Load the value of the register
	MOV R8, #1              ; Load 1 into R3
	LSL R8, R8, #13   ; Shift left to create the mask for the pin
	AND R4, R4, R8         ; AND the register value with the mask
	cmp R4,R8
	BNE button1_check 
sloop	
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	add r9,r9,#1
	cmp r9,#10
	BNE sec
	mov r9,#0
	add r12,#1
	cmp r12,#6
	BNE sec
	mov r12,#0
	add r2,#1
	cmp r2,#10
	BNE sec
sec	
	mov r5,#40
	mov r6,#120
	mov r7,r9
	BL Digits_Main

	mov r5,#100
	mov r6,#120
	mov r7,r12
	BL Digits_Main
	
	MOV R0,#170
	MOV R1,#150
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#120
	mov r7,r2
	BL Digits_Main
		

	mov r5,#260
	mov r6,#120
	mov r7,r3
	BL Digits_Main

	LDR R8, =GPIOB_ODR   ; Load the address
	LDR R4, [R8]            ; Load the value of the register
	MOV R8, #1              ; Load 1 into R3
	LSL R8, R8, #13   ; Shift left to create the mask for the pin
	AND R4, R4, R8         ; AND the register value with the mask
	cmp R4,R8
	BEQ stop
	;check stop button
	b sloop
stop		 
	POP{R0-R12,PC} 
	 ENDFUNC

TIMER_MAIN FUNCTION
	;R2 contains the wanted time 
	PUSH{r0-r12,LR}
	mov r9,#0 ;seconds1
	mov r12,#0 ;seconds2

	
	
	
	mov r5,#40
	mov r6,#120
	mov r7,r9
	BL Digits_Main

	mov r5,#100
	mov r6,#120
	mov r7,r12
	BL Digits_Main
	
	MOV R0,#170
	MOV R1,#150
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#120
	mov r7,r2
	BL Digits_Main
Tloop	
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	
	cmp r9,#0
	BEQ sc1
	sub r9,r9,#1
	b print   ;label at second drawing 
sc1	
	cmp r12,#0
	BEQ sch
	sub r12,r12,#1
	mov r9,#9      ;move to next whole
	b print 
sch
	cmp r2,#0
	BEQ trigger ;done 
	sub r2,r2,#1
	mov r12,#5
	mov r9,#9
print
	mov r5,#40
	mov r6,#120
	mov r7,r9
	BL Digits_Main

	mov r5,#100
	mov r6,#120
	mov r7,r12
	BL Digits_Main
	
	MOV R0,#170
	MOV R1,#150
	bl DRAW_COLLEN
	
	mov r5,#190
	mov r6,#120
	mov r7,r2
	BL Digits_Main
		

	b Tloop
trigger	;check stop button and buzzer on 
	mov r3,#1
	bl Buzzer_init
	POP{R0-R12,PC} 
	 ENDFUNC

;button1_check function 
;	push{R0-R12,LR}
;	
;		LDR R0, =GPIOB_ODR   ; Load the base address
;		LDR R4, [R0]            ; Load the value of the register
;		MOV R3, #1              ; Load 1 into R3
;		LSL R3, R3, #13   ; Shift left to create the mask for the pin
;		AND R4, R4, R3          ; AND the register value with the mask
;	pop{R0-R12,PC}
;    endfunc
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
