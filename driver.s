;RS = A8 -> Selects command register when low, and data register when high
;R/W = A9 -> Low to write to the register; High to read from the register
;EN = A0 ->Sends data to data pins when a high to low pulse is given
;DB0=D4 ,DB1=D5 ,DB2=D6 ,DB3=D7 ,DB4=E0 ,DB5=E1 ,DB6=E2 ,DB7=E3

; ******* Constants *******
;Delay interval
;The delay loop takes 313 nsec to execute at 16MHz
;Time delay = DELAY_INTERVAL * 313 nsec
;Overheads are ignored

DELAY_INTERVAL	EQU	0x186004 ;0.5sec Delay
SETUP_DELAY	EQU	0x3E8 ;3.13 microsec Delay
DELAY_50S EQU 0x9858190 ; 50sec Delay
DELAY_5S EQU 0xF3C028

; **************************

; ******* Register definitions *******

;As per STM32F407 datasheet and reference manual

RCC_AHB1ENR	EQU	0x40023830	;Clock control for AHB1 peripherals (includes GPIO)

;GPIO-A control registers
GPIOA_MODER		EQU	0x40020000	;set GPIO pin mode as Input/Output/Analog
GPIOA_OTYPER	EQU	0x40020004	;Set GPIO pin type as push-pull or open drain
GPIOA_OSPEEDR	EQU 0x40020008	;Set GPIO pin switching speed
GPIOA_PUPDR		EQU	0x4002000C	;Set GPIO pin pull-up/pull-down
GPIOA_ODR		EQU	0x40020014	;GPIO pin output data

;GPIO-D control registers
GPIOD_MODER		EQU	0x40020C00	;set GPIO pin mode as Input/Output/Analog
GPIOD_OTYPER	EQU	0x40020C04	;Set GPIO pin type as push-pull or open drain
GPIOD_OSPEEDR	EQU 0x40020C08	;Set GPIO pin switching speed
GPIOD_PUPDR		EQU	0x40020C0C	;Set GPIO pin pull-up/pull-down
GPIOD_ODR		EQU	0x40020C14	;GPIO pin output data
	
;GPIO-E control registers
GPIOE_MODER		EQU	0x40021000	;set GPIO pin mode as Input/Output/Analog
GPIOE_OTYPER	EQU	0x40021004	;Set GPIO pin type as push-pull or open drain
GPIOE_OSPEEDR	EQU 0x40021008	;Set GPIO pin switching speed
GPIOE_PUPDR		EQU	0x4002100C	;Set GPIO pin pull-up/pull-down
GPIOE_ODR		EQU	0x40021014	;GPIO pin output data

; **************************

; Export functions so they can be called from other file

	EXPORT SystemInit
	EXPORT __main

	AREA	MYCODE, CODE, READONLY
		
; **************************

SystemInit FUNCTION

	; Enable GPIO clock
	LDR		R1, =RCC_AHB1ENR	;Pseudo-load address in R1
	LDR		R0, [R1]			;Copy contents at address in R1 to R0
	ORR.W 	R0, R0, #0x19		;Bitwise OR entire word in R0, result in R0
	STR		R0, [R1]			;Store R0 contents to address in R1
	
;D Port Initialization
	; Set mode as output
	LDR		R1, =GPIOD_MODER	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0x00005500	
	ORR.W	R0, R0, R2				;Mode bits set to '01' makes the pin mode as output
	LDR		R2, =0xFFFF55FF
	AND.W	R0, R0, R2		;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]
	
	; Set type as push-pull	(Default)
	LDR		R1, =GPIOD_OTYPER	;Type bit '0' configures pin for push-pull
	LDR		R0, [R1]
	LDR		R2, =0xFFFFFF0F
	AND.W 	R0, R0, R2	
	STR		R0, [R1]
	
	; Set Speed slow
	LDR		R1, =GPIOD_OSPEEDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0xFFFF00FF
	AND.W 	R0, R0, R2				;Speed bits set to '00' configures pin for slow speed
	STR		R0, [R1]	
	
	; Set pull-up
	LDR		R1, =GPIOD_PUPDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0x00005500		;Mode bits set to '01' makes the pin mode as pullup
	ORR.W	R0, R0, R2
	LDR		R2, =0xFFFF55FF
	AND.W	R0, R0, R2				;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]
	
	;E Port Initialization
	; Set mode as output
	LDR		R1, =GPIOE_MODER	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0x00000055
	ORR.W 	R0, R0, R2				;Mode bits set to '01' makes the pin mode as output
	LDR		R2, =0xFFFFFF55
	AND.W	R0, R0, R2				;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]

	; Set type as push-pull	(Default)
	LDR		R1, =GPIOE_OTYPER	;Type bit '0' configures pin for push-pull
	LDR		R0, [R1]
	LDR		R2, =0xFFFFFFF0
	AND.W 	R0, R0,  R2
	STR		R0, [R1]
	
	; Set Speed slow
	LDR		R1, =GPIOE_OSPEEDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0xFFFFFF00
	AND.W 	R0, R0, R2				;Speed bits set to '00' configures pin for slow speed
	STR		R0, [R1]	
	
	; Set pull-up
	LDR		R1, =GPIOE_PUPDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0x00000055		;Mode bits set to '01' makes the pin mode as pullup
	ORR.W 	R0, R0, R2				
	LDR		R2, =0xFFFFFF55
	AND.W	R0, R0, R2				;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]

	;A Port Initialization
	; Set mode as output
	LDR		R1, =GPIOA_MODER	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0x00050001
	ORR.W 	R0, R0, R2				;Mode bits set to '01' makes the pin mode as output
	LDR		R2, =0xFFF5FFFD
	AND.W	R0, R0, R2				;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]

	; Set type as push-pull	(Default)
	LDR		R1, =GPIOA_OTYPER	;Type bit '0' configures pin for push-pull
	LDR		R0, [R1]
	LDR		R2, =0xFFFFFCFE
	AND.W 	R0, R0,  R2
	STR		R0, [R1]
	
	; Set Speed slow
	LDR		R1, =GPIOA_OSPEEDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0xFFF0FFFC
	AND.W 	R0, R0, R2				;Speed bits set to '00' configures pin for slow speed
	STR		R0, [R1]	
	
	; Set pull-up
	LDR		R1, =GPIOA_PUPDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	LDR		R2, =0x00050001		;Mode bits set to '01' makes the pin mode as pullup
	ORR.W 	R0, R0, R2				
	LDR		R2, =0xFFF5FFFD
	AND.W	R0, R0, R2				;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]

	BX		LR					;Return from function
			
	ENDFUNC
	
__main FUNCTION
	
INITIALIZE
		
		BL COMMAND
		
		;Enable 8-bit Databus, Set 2 lines, and Select font size 5x7
		LDR		R1, =GPIOD_ODR
		LDR		R0, [R1]
		ORR.W 	R0, R0, #0x0080
		AND.W	R0, R0, #0xFFFFFF8F
		LDR		R2, =GPIOE_ODR
		LDR		R3, [R2]
		ORR.W 	R3, R3, #0x0003
		AND.W	R3, R3, #0xFFFFFFF3
		STR		R0, [R1]
		STR		R3, [R2]
		BL LATCH
		BL LATCH
		BL LATCH
		BL LATCH
		
		;Display ON Cursor Blink
		LDR		R1, =GPIOD_ODR
		LDR		R0, [R1]
		ORR.W 	R0, R0, #0x00F0
		LDR		R2, =GPIOE_ODR
		LDR		R3, [R2]
		AND.W	R3, R3, #0xFFFFFFF0
		STR		R0, [R1]
		STR		R3, [R2]
		LDR		R2, =DELAY_INTERVAL
		
		BL	DELAY
		
		;Set cursor to first position
		LDR		R1, =GPIOD_ODR
		LDR		R0, [R1]
		ORR.W 	R0, R0, #0x0010
		AND.W	R0,	R0, #0xFFFFFF1F
		LDR		R2, =GPIOE_ODR
		LDR		R3, [R2]
		AND.W	R3, R3, #0xFFFFFFF0
		STR		R0, [R1]
		STR		R3, [R2]
		LDR		R2, =DELAY_INTERVAL
		
		BL DELAY
		
		;B GOTOBLINK
		
HELLO
        DCB       "Hello ARM....",0

		
		BL DATA
		
		BL LATCH
		
		ADR   	R4, HELLO          ;; "address in register"
LOOP        
		LDRB  	R7, [R4], #1        ; Get next byte and post-index r4
        CMP   	R7, #0              ; Stop when we hit a null
		BEQ	FINISH
		BL WRITEDATA
		BL LATCH
		B	LOOP
		
		
COMMAND
		; To send value to command register
		PUSH 	{LR}
		LDR		R1, =GPIOA_ODR
		LDR		R0, [R1]
		LDR 	R2, =0xFCFE	;reset RS=0, RW=0 ,E=0
		AND.W 	R0, R0, R2	
		STR		R0, [R1]
		LDR		R2,=10
		BL	DELAY
		POP		{PC}
		
DATA
		; To send value to command register
		PUSH 	{LR}
		LDR		R1, =GPIOA_ODR
		LDR		R0, [R1]
		LDR 	R2, =0xFDFE	;reset RW=0 ,E=0
		AND.W 	R0, R0, R2	
		LDR 	R2, =0x0100	;set RS=1
		ORR.W 	R0, R0, R2	
		STR		R0, [R1]
		LDR		R2,=10
		BL	DELAY
		POP		{PC}
		
WRITEDATA
		PUSH 	{LR}
		MOV.W	R8, R7
		AND.W	R8, R8, #0x0000000F
		MOV.W	R8, R8, LSL #4
		MOV.W	R9, R7
		AND.W	R9, R9, #0x000000F0
		MOV.W	R9, R9, LSR #4
		
		LDR		R1, =GPIOD_ODR
		LDR		R2, =GPIOE_ODR
		STR		R8, [R1]
		STR		R9, [R2]
		LDR		R2, =DELAY_INTERVAL
		BL DELAY
		POP		{PC}
		
		

LATCH
		PUSH 	{LR}
		LDR		R1, =GPIOA_ODR
		LDR		R0, [R1]
		LDR 	R2, =0xFFFE
		AND.W 	R0, R0, R2				;EN=0
		STR		R0, [R1]
		LDR		R2, =10
		BL		DELAY
		LDR		R1, =GPIOA_ODR
		LDR		R0, [R1]
		LDR 	R2, =0x0001
		ORR.W 	R0, R0, R2				;EN=1
		STR		R0, [R1]
		LDR		R2, =10
		BL		DELAY
		POP		{PC}
	
FINISH	
		LDR 	 R2, =DELAY_5S
		BL DELAY
		B GOTOBLINK
				
DELAY
		PUSH 	{LR}
DE		SUBS	R2, R2, #1
		LDR		R3, =0 
		CMP 	R2, R3
		BNE		DE
		POP		{PC}
		
GOTOBLINK
		B INITIALIZE
	
	ENDFUNC
	END