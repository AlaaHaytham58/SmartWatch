	AREA MYDATA, DATA, READWRITE
	AREA	MYCODE, CODE, READONLY
	
	EXPORT StopWatch_MAIN
	IMPORT Digits_Main
	import DRAW_COLLEN
		
StopWatch_MAIN FUNCTION
;	PUSH{r0-r12,LR}
;	;CMP R7,#0
;	;BNE Timer 
;	mov r0,#0 ;seconds1
;	mov r1,#0 ;seconds2
;	mov r2,#0 ;min 1
;	mov r3,#0 ;min 2
;	
;	
;	mov r5,#40
;	mov r6,#120
;	mov r7,r0
;	BL Digits_Main

;	mov r5,#100
;	mov r6,#120
;	mov r7,r1
;	BL Digits_Main
;	
;	MOV R0,#170
;	MOV R1,#150
;	bl DRAW_COLLEN
;	
;	mov r5,#190
;	mov r6,#120
;	mov r7,r2
;	BL Digits_Main
;		

;	mov r5,#260
;	mov r6,#120
;	mov r7,r3
;	BL Digits_Main
;sloop	
;	BL delay_1_second
;	BL delay_1_second
;	
;	add r0,r0,#1
;	cmp r0,#10
;	BNE sec
;	mov r0,#0
;	add r1,#1
;	cmp r1,#6
;	BNE sec
;	mov r1,#0
;	add r2,#1
;	cmp r2,#10
;	BNE sec
;sec	
;	mov r5,#40
;	mov r6,#120
;	mov r7,r0
;	BL Digits_Main

;	mov r5,#100
;	mov r6,#120
;	mov r7,r1
;	BL Digits_Main
;	
;	MOV R0,#170
;	MOV R1,#150
;	bl DRAW_COLLEN
;	
;	mov r5,#190
;	mov r6,#120
;	mov r7,r2
;	BL Digits_Main
;		

;	mov r5,#260
;	mov r6,#120
;	mov r7,r3
;	BL Digits_Main
;	
;	;check stop button
;	b sloop
;	;TIMER
;	;MOV 
;;TIMER	 
;	POP{R0-R12,PC} 
;	 ENDFUNC
	 end