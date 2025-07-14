;konfigurasyon kismi
                       
                       THUMB
			 
Baslama_adresi         EQU  0x20000100
			 
	                   AREA Bolum1, DATA, READONLY
                       THUMB  
						   
                       DCD Baslama_adresi;START ADRESS
					   DCD Resetleme_fonksiyonu;RESET FUNC
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
					   DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
					   DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved

                       ; External Interrupts
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
					   DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
					   DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
					   DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
					   DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved
                       DCD     0                          ; Reserved						   
					   DCD TIM2_IRQHandler 
                       
	
                       AREA    |.text|, CODE, READONLY
						   
Default_Handler        PROC
	
                       EXPORT   TIM2_IRQHandler              [WEAK] 
						   						   
TIM2_IRQHandler 					   
					   B        .                     
					   ENDP		   	
					   
                       ALIGN

					   AREA Bolum2, CODE, READONLY   
					   ENTRY

Resetleme_fonksiyonu					   
                       IMPORT _main	
						   
					   B _main	

                       END