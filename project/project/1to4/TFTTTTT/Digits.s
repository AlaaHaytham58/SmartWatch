	AREA MYDATA, DATA, READWRITE
	AREA	MYCODE, CODE, READONLY
	;IMPORT LCD_DATA_WRITE
	;IMPORT ADDRESS_SET
	INCLUDE Setup.s
	EXPORT Digits_Main
	export DRAW_RECTANGLE_FILLED
	export DRAW_COLLEN

;ENDFN
;	POP {R0-R12, PC}
;	ENDFUNC


;ENTRY
Digits_Main	FUNCTION
	 
	PUSH {R0-R12, LR}
	cmp r7,#0
	BEQ.W ZERO
	
	cmp r7,#1
	BEQ.W ONE
	
	cmp r7,#2
	BEQ.W TWO
	
	cmp r7,#3
	BEQ.W THREE
	
	cmp r7,#4
	BEQ.W FOUR
	
	cmp r7,#5
	BEQ.W FIVE
	
	cmp r7,#6
	BEQ.W SIX
	
	cmp r7,#7
	BEQ.W SEVEN
	
	cmp r7,#8
	BEQ.W EIGHT
	
	cmp r7,#9
	BEQ.W NINE
	
	BGT.W DIVIDE_DIGIT
;	cmp r7,#6
;	BEQ SIX
	b last
;	
;	cmp r7,#7
;	BEQ SEVEN
;	
;	cmp r7,#8
;	BEQ EIGHT
	
;	cmp r7,#9
;	BEQ NINE
	
ZERO 
	ldr r10,= RED
	BL Horizontal_Segment1
	
	ldr r10,= BLACK
	bl Horizontal_Segment2
	
	ldr r10,= RED
	bl Horizontal_Segment3	
	
	bl Vertical_Segment1
	bl Vertical_Segment2
	bl Vertical_Segment3
	bl Vertical_Segment4
	b last
ONE 
	ldr r10,= RED
	bl Vertical_Segment1

	
	ldr r10,= RED
	bl Vertical_Segment2
	
	ldr r10,= BLACK
	bl Vertical_Segment3
	bl Vertical_Segment4
	bl Horizontal_Segment1
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	b last
	
TWO
	
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Horizontal_Segment3
	ldr r10,= RED
	bl Vertical_Segment1
	ldr r10,= RED
	bl Vertical_Segment4
	
	ldr r10,= BLACK
	bl Vertical_Segment2
	bl Vertical_Segment3
	b last
	
THREE 
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Horizontal_Segment3
	ldr r10,= RED
	
	bl Vertical_Segment1
	ldr r10,= RED
	bl Vertical_Segment2
	
	ldr r10,= BLACK
	bl Vertical_Segment3
	bl Vertical_Segment4
	
	b last
	
FOUR
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Vertical_Segment1
	ldr r10,= RED
	bl Vertical_Segment2
	ldr r10,= RED
	bl Vertical_Segment3
	
	ldr r10,= BLACK
	bl Horizontal_Segment1
	bl Horizontal_Segment3
	bl Vertical_Segment4
	b last
	
FIVE 
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Horizontal_Segment3
	ldr r10,= RED
	bl Vertical_Segment3
	ldr r10,= RED
	bl Vertical_Segment2
	
	ldr r10,= BLACK
	bl Vertical_Segment1
	bl Vertical_Segment4
	b last
SIX
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Horizontal_Segment3
	ldr r10,= RED
	bl Vertical_Segment3
	ldr r10,= RED
	bl Vertical_Segment2
	ldr r10,= RED
	bl Vertical_Segment4
	
	ldr r10,= BLACK
	bl Vertical_Segment1
	B last

SEVEN
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Vertical_Segment1
	ldr r10,= RED
	bl Vertical_Segment2
	
	ldr r10,= BLACK
	bl Vertical_Segment3
	bl Vertical_Segment4
	bl Horizontal_Segment2
	bl Horizontal_Segment3
	B last

EIGHT
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Horizontal_Segment3
	ldr r10,= RED
	bl Vertical_Segment1
	ldr r10,= RED
	bl Vertical_Segment2
	ldr r10,= RED
	bl Vertical_Segment3
	ldr r10,= RED
	bl Vertical_Segment4
	B last
	
NINE
	ldr r10,= RED
	bl Horizontal_Segment1
	ldr r10,= RED
	bl Horizontal_Segment2
	ldr r10,= RED
	bl Horizontal_Segment3
	ldr r10,= RED
	bl Vertical_Segment1
	ldr r10,= RED
	bl Vertical_Segment2
	ldr r10,= RED
	bl Vertical_Segment3
	ldr r10,= BLACK
	bl Vertical_Segment4
	B last

;r7=number
;output:  r9 left most (tens)  r7 (units)
DIVIDE_DIGIT
	MOV R9,#0
	mov r8,r7  ;; store the original number

LOOP_DIVIDE_DIGIT
	SUBS R7,R7,#10
	ADD R9,R9,#1
	CMP r7,#9
	bgt LOOP_DIVIDE_DIGIT
	
	
	CMP R9,#6
	BNE NORM
	MOV R9,#0
	MOV R8,#0
	;printing units
NORM
	mov r5,#20
	mov r6,#10
	bl Digits_Main
	
	;printing tens
	mov r5,#90
	mov r6,#10
	mov r7,r9
	bl Digits_Main
	
	mov r7,r8
	
last
	POP {R0-R12,PC}
	ENDFUNC
	
DRAW_COLLEN FUNCTION
	PUSH{R0-R12, LR}
	ldr r10,= RED
	ADD R3,R0,#20
	ADD R4,R1,#20
	BL DRAW_RECTANGLE_FILLED
	
	ADD R1,#40
	ADD R3,R0,#20
	ADD R4,R1,#20
	ldr r10,= RED
	BL DRAW_RECTANGLE_FILLED
	
	POP {R0-R12,PC}
	ENDFUNC
;ZERO function
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	BL Horizontal_Segment1
;	
;	ldr r10,= BLACK
;	bl Horizontal_Segment2
;	
;	ldr r10,= RED
;	bl Horizontal_Segment3	
;	
;	bl Vertical_Segment1
;	bl Vertical_Segment2
;	bl Vertical_Segment3
;	bl Vertical_Segment4
;	POP {r0-r12,PC}
;	ENDFUNC

;ONE FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Vertical_Segment1

;	
;	ldr r10,= RED
;	bl Vertical_Segment2
;	
;	ldr r10,= BLACK
;	bl Vertical_Segment3
;	bl Vertical_Segment4
;	bl Horizontal_Segment1
;	bl Horizontal_Segment2
;	bl Horizontal_Segment3
;	
;	POP {r0-r12, PC}
;	ENDFUNC

;TWO FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Horizontal_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment4
;	
;	
;	ldr r10,= BLACK
;	bl Vertical_Segment2
;	bl Vertical_Segment3
;	
;	POP {r0-r12, PC}
;	ENDFUNC

;THREE FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Horizontal_Segment3
;	ldr r10,= RED
;	
;	bl Vertical_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment2
;	
;	ldr r10,= BLACK
;	bl Vertical_Segment3
;	bl Vertical_Segment4
;	
;	POP {r0-r12, PC}
;	ENDFUNC

;FOUR FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Vertical_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment2
;	ldr r10,= RED
;	bl Vertical_Segment3
;	
;	ldr r10,= BLACK
;	bl Horizontal_Segment1
;	bl Horizontal_Segment3
;	bl Vertical_Segment4
;	POP {r0-r12, PC}
;	ENDFUNC
	
;FIVE FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Horizontal_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment2
;	
;	ldr r10,= BLACK
;	bl Vertical_Segment1
;	bl Vertical_Segment4
;	
;	POP {r0-r12, PC}
;	ENDFUNC
	
;SIX FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Horizontal_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment2
;	ldr r10,= RED
;	bl Vertical_Segment4
;	
;	ldr r10,= BLACK
;	bl Vertical_Segment1
;	
;	
;	POP {r0-r12, PC}
;	ENDFUNC
;SEVEN FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment2
;	
;	ldr r10,= BLACK
;	bl Vertical_Segment3
;	bl Vertical_Segment4
;	bl Horizontal_Segment2
;	bl Horizontal_Segment3
;	
;	
;	POP {r0-r12, PC}
;	ENDFUNC
;EIGHT FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Horizontal_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment2
;	ldr r10,= RED
;	bl Vertical_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment4
;	
;	POP {r0-r12,PC}
;	ENDFUNC

;NINE FUNCTION
;	PUSH {R0-R12, LR}
;	ldr r10,= RED
;	bl Horizontal_Segment1
;	ldr r10,= RED
;	bl Horizontal_Segment2
;	ldr r10,= RED
;	bl Horizontal_Segment3
;	ldr r10,= RED
;	bl Vertical_Segment1
;	ldr r10,= RED
;	bl Vertical_Segment2
;	ldr r10,= RED
;	bl Vertical_Segment3
;	ldr r10,= BLACK
;	bl Vertical_Segment4
;	POP {r0-r12,PC}
;	ENDFUNC

	
DRAW_RECTANGLE_FILLED FUNCTION
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
	ENDFUNC
;##########################################################################################################################################



Horizontal_Segment1 FUNCTION
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

Horizontal_Segment2 FUNCTION
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
	
	
	
Horizontal_Segment3 FUNCTION
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
	
Vertical_Segment1 FUNCTION
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

Vertical_Segment2 FUNCTION
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
	
	
Vertical_Segment3 FUNCTION
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

Vertical_Segment4 FUNCTION
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
	END

	LTORG
	end
