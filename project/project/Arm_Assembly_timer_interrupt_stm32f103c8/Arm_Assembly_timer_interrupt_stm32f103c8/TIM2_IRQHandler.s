GPIOA_ODR	       EQU 0x4001080C
	
				   AREA tim2_IRQHandler, READONLY, CODE
				   THUMB
                   EXPORT    TIM2_IRQHandler
                   EXTERN	 _main
 
TIM2_IRQHandler    PROC
;                 TIM2->SR =0x0;//interrupt FLAG ON
                   MOVS     r0,#0x00
                   MOV      r1,#0x40000000 
                   STR      r0,[r1,#0x10]
;                 GPIOA->ODR ^=0x0008;//toggle pa3 
                   LDR      r0,=GPIOA_ODR  
                   LDR      r0,[r0,#0x00]
                   EOR      r0,r0,#0x08
                   LDR      r1,=GPIOA_ODR  
                   STR      r0,[r1,#0x00] 	
				   
                   BX       lr	
				   ENDP
                   ALIGN
				   END	
                   					   