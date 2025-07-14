GPIOA_IDR	       EQU 0x40010808

GPIOA_CRL	       EQU 0x40010800
GPIOB_IDR	       EQU 0x40010C08
GPIOA_ODR	       EQU 0x4001080C
RCC_APB2ENR        EQU 0x40021000
RCC_APB1ENR        EQU 0x40021000
TIM2_ARR           EQU 0x40000000
TIM2_PSC           EQU 0x40000028
TIM2_DIER          EQU 0x40000000
TIM2_CR1           EQU 0x40000000
TIM2_SR            EQU 0x40000000
;RCC_CR             EQU 0x40021000
RCC_CFGR           EQU 0x40021000
FLASH_ACR          EQU 0x40022000

		           AREA Bolum3, CODE, READONLY	                 
                   THUMB
				   EXTERN TIM2_IRQHandler
				   EXPORT _main
_main  
    ;GPIO A CLOCK ON
                   LDR      r2,=0x20000260 
                   MOV      r0,#0x04
                   LDR      r1,=RCC_APB2ENR  
                   STR      r0,[r1,#0x18]
    ;  pa3 out
                   MOV      r0,#0x3000
                   LDR      r1,=GPIOA_CRL  
                   STR      r0,[r1,#0x00] 
;*****************************************************************************CLOCK CONFIGURATION 72MHZ				   
				     ;1014:     FLASH->ACR |= FLASH_ACR_PRFTBE; 
  ;1015:  
  ;1016:     /* Flash 2 wait state */ 
                   LDR      r0,=FLASH_ACR  
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x10
                   LDR      r1,=FLASH_ACR  
                   STR      r0,[r1,#0x00]
  ;1017:     FLASH->ACR &= (uint32_t)((uint32_t)~FLASH_ACR_LATENCY); 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   BIC      r0,r0,#0x03
                   STR      r0,[r1,#0x00]
  ;1018:     FLASH->ACR |= (uint32_t)FLASH_ACR_LATENCY_2;     
  ;1019:  
  ;1020:   
  ;1021:     /* HCLK = SYSCLK */ 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x02
                   STR      r0,[r1,#0x00]
	     ;5:                         RCC->CR |= 0x00030000;//Pll ON 
     ;6:            // while(!(RCC->CR & 0x20000))//hse ON
                   LDR      r0,=RCC_CR
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x10000
                   LDR      r1,=RCC_CR
                   STR      r0,[r1,#0x00] 				   
  ;12:       RCC->CFGR |= 0x00000400;  //apb1 /2 DIVIDE 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x400                                              
                   STR      r0,[r1,#0x04]		
  ;1054:     RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_PLLSRC | RCC_CFGR_PLLXTPRE | 
  ;1055:                                         RCC_CFGR_PLLMULL)); 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   BIC      r0,r0,#0x3F0000
                   STR      r0,[r1,#0x04]				   		   
    ;10:       RCC->CFGR |= 0x001C0000;  //PLLMUL X9 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x1C0000
                   STR      r0,[r1,#0x04]
    ;13:       RCC->CFGR |= 0x00000002; //PLL   System clock
    ;14:                          
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x02
                   STR      r0,[r1,#0x04]
	;10:       RCC->CFGR |= 0x001C0000;  //PLL entry clock source
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x10000
                   STR      r0,[r1,#0x04]			   
				   ;  1060:     RCC->CR |= RCC_CR_PLLON; 
 ; 1061:  
 ; 1062:     /* Wait till PLL is ready */ PLLON: PLL enable
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x1000000
                   STR      r0,[r1,#0x00]
	;11:       RCC->CFGR |= 0x00000080;  //ahb prescaler 
       ;            MOV      r0,r1
      ;             LDR      r0,[r0,#0x04]
      ;             ORR      r0,r0,#0x90
     ;              STR      r0,[r1,#0x04]
;*****************************************************************************CLOCK CONFIGURATION 72MHZ	

;*****************************************************************************TIMER CONFIGURATION 	
    ;        __disable_irq(); 
                   CPSID    I 
    ;         RCC->APB1ENR =0x1;// timer2 aktif 
                   MOV      r0,#0x1
                   LDR      r1,=RCC_APB1ENR  
                   STR      r0,[r1,#0x1C]
    ;        TIM2->ARR = 0xffff;  
                   MOV      r0,#0xFFFF
                   LDR      r1,=TIM2_ARR
                   STR      r0,[r1,#0x2C]
    ;         TIM2->PSC = 54;             10HZ BLINK
                   MOV      r0,#54
                   STR      r0,[r1,#0x28]
    ;        TIM2->DIER = 0x1; 
                   MOV      r0,#0x1
                   STR      r0,[r1,#0x0C]
    ;         TIM2->CR1 = 0x1;  
                   MOV      r0,#0x1
				   STR      r0,[r1,#0x00]
;*****************************************************************************TIMER CONFIGURATION 				   
    ;        NVIC_EnableIRQ(TIM2_IRQn); //TIMx_CR1.CEN 
;*****************************************************************************INTERRUPT CONFIGURATION                    
                   MOV      r0,#0x1C
  ;   if ((int32_t)(IRQn) >= 0) 
  ;   { 		   
                   CMP      r0,#0x00
                   BLT      SKIP ;
                   AND      r2,r0,#0x1F
                   MOV      r1,#0x01
                   LSLS     r1,r1,r2
                   LSRS     r2,r0,#5
                   LSLS     r2,r2,#2
                   ADD      r2,r2,#0xE000E000
                   STR      r1,[r2,#0x100] 				   				   
SKIP 	           NOP                   
    ;         __enable_irq();

				   CPSIE    I
;*****************************************************************************INTERRUPT CONFIGURATION				   
    ;         while(1) 
	
	;     23:         TIM2->SR =0x0;//interrupt FLAG ON
                   ;BL TIM2_IRQHandler
	
while              B        while	 
			       ALIGN
	               END