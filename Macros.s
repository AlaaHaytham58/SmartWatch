	AREA	MYCODE, CODE, READONLY
		;EXPORT CHECK_PIN
		;EXPORT SET_PIN
		;EXPORT CLEAR_PIN
		MACRO
		CHECK_PIN $BASE_ADDRESS, $OFFSET, $PIN_NUMBER
		LDR R0, =$BASE_ADDRESS   ; Load the base address
		LDR R1, =$OFFSET         ; Load the offset
		ADD R0, R0, R1          ; Calculate the address of the register
		LDR R4, [R0]            ; Load the value of the register
		MOV R3, #1              ; Load 1 into R3
		LSL R3, R3, $PIN_NUMBER   ; Shift left to create the mask for the pin
		AND R4, R4, R3          ; AND the register value with the mask
    ; Result in R4: if R4 is non-zero, the pin is set
		MEND
		END

; Macro to set a specific pin high
		MACRO
		SET_PIN $BASE_ADDRESS, $OFFSET, $PIN_NUMBER
		LDR R0, =$BASE_ADDRESS   ; Load the base address
		LDR R1, =$OFFSET         ; Load the offset
		ADD R0, R0, R1          ; Calculate the address of the register
		LDR R4, [R0]            ; Load the current value of the register
		MOV R3, #1              ; Load 1 into R3
		LSL R3, R3, $PIN_NUMBER   ; Shift left to create the mask for the pin
		ORR R4, R4, R3          ; Set the pin high
		STR R4, [R0]            ; Store the updated value back to the register
		MEND
		END
	
; Macro to clear a specific pin (set it low)
		MACRO
		CLEAR_PIN $BASE_ADDRESS, $OFFSET, $PIN_NUMBER
		LDR R0, =$BASE_ADDRESS   ; Load the base address
		LDR R1, =$OFFSET         ; Load the offset
		ADD R0, R0, R1          ; Calculate the address of the register
		LDR R4, [R0]            ; Load the current value of the register
		MOV R3, #1              ; Load 1 into R3
		LSL R3, R3,$PIN_NUMBER   ; Shift left to create the mask for the pin
		MVN R3, R3              ; Invert the mask
		AND R4, R4, R3          ; Clear the specific pin
		STR R4, [R0]            ; Store the updated value back to the register
		MEND
		END
		