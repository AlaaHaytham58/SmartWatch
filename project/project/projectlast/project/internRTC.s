;==================RTC_ENABLER=====================;
	INCLUDE Setup.s
RTC_INIT 	FUNCTION
	PUSH{R0-R12, LR}
;	1) Set PWREN (28) and BKPEN (27) in RCC_APB1ENR
	ldr r0, =RCC_APB2ENR
	ldr r1, [r0]
	
	orr r1, r1, #(1 << 27) ;BKPEN 
	orr r1, r1, #(1 << 28) ;PWREN 
	str r1, [r0]
	
;	2) Set DBP bit 8 in PWR_CR
	ldr r0, =PWR_CR
	ldr r1, [r0]
	orr r1, r1, #(1 << 8)
	str r1, [r0]
	
;	3) Set LSEON bit 0 in RCC_BDCR
	ldr r0, =RCC_BDCR
	ldr r1, [r0]
	orr r1,r1,#1
	str r1, [r0]

;	4) Poll until LSERDY bit 1 in RCC_BDCR is set 1
Poll_LSE_Loop
	mov r2, r1
	and r2,r2, #(1<<1)
	
	cmp r2,#0
	beq Poll_LSE_Loop
	
;	5)select RTC clk (LSE) source  
	ldr r0, =RCC_BDCR
	ldr r1, [r0]
	
	bic r1,r1,#0x0300 ;clear bit 8,9
	orr r1,r1, #(1 << 8) 
	str r1, [r0]
	
;	6) Enable RTC Clk
	ldr r0, =RCC_BDCR
	ldr r1, [r0]
	
	orr r1, r1, #(1 << 15)
	str r1, [r0]
	
;	7) Poll bit 5 RTOFF in RTC_CRL
Poll_RTOFF_Loop
	ldr r0, =RTC_CRL
	ldr r1, [r0]
	
	and r1,r1 , #(1 << 5)
	cmp r1, #0
	beq Poll_RTOFF_Loop

Poll_RSF_Loop
	ldr r0, =RTC_CRL
	ldr r1, [r0]
	
	and r1, r1, #(1 << 3)
	cmp r1, #0
	beq Poll_RSF_Loop
	
;	8) Set the CNF bit 4 RTC_CRL
	ldr r1, [r0]
	orr r1,r1, #(1 << 4)
	str r1, [r0]
	
	;9) write 7FFFh in RTC_PRLL
	ldr r0, =RTC_PRLL
	mov r1, #0x7FFF
	str r1, [r0]
	
	; Set Counter reg to 7 pm
	;ldr, r0, =RTC_CNTL
	;ldr r1, =INITIAL_TIME
	;str r1, [r0]
	
	;10) Clear the CNF bit 4 RTC_CRL to exit configuration mode
	ldr r0, =RTC_CRL
	ldr r1, [r0]
	
	bic r1, r1, #(1 << 4)
	str r1, [r0]
	
	
	
	POP{R0-R12,PC}
	ENDFUNC
	end