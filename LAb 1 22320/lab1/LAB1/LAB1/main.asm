;********************************
;UNIVERSIDAD DEL VALLE DE GUATEMALA
;IE2023: PROGRAMACI�N DE MICROCONTROLADORES
;Lab1.asm
;AUTOR: Jose Andr�s Vel�squez Garc�a  
;PROYECTO: Contadores binarios de 4 BITS y sumador
;HARDWARE: ATMEGA328P
;CREADO: 30/01/2024
;�LTIMA MODSIICACI�N: 5/02/2024 16:37:23
;********************************

.INCLUDE "M328PDEF.INC"
.CSEG
.ORG 0X00

;STACK POINTER
;********************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17

;****************************
SETUP:
;AUMENTAR Y LED DE ACARREO 
	LDI R16, (1 << CLKPCE)	;PRESCALER
	STS CLKPR, R16

	LDI R16, 0X03			;16MHz
	STS CLKPR, R16			;FREC: 2MHz

	LDI R16, 0x1F			;TOMAR PC0 - PC4 entradas
	OUT PORTC, R16			;GUARDAR PORT DEFAULT SALIDA

	LDI R16, 0x20
	OUT DDRC, R16			;TODOS LOS PC0 - PC4 ENTRADAS PC5 SALIDA

	;LEDS
	LDI R16, 0x3F
	OUT DDRB, R16			;PB0 - PB5 SALIDA

	LDI R17, 0xFC			;PD2 - PD7 SALIDA
	OUT DDRD, R17
	
	LDI R19, 0x00			;MOSTRAR VALOR
	LDI R20, 0x00
	LDI R23, 0x00
	LDI R25, 0x00


LOOP:
	CALL COUNTER1
	CALL COUNTER2
	RJMP LOOP


;***********************************
;COUNTERS
COUNTER1:
	IN R16, PINC			;LEE EL REGISTRO DE PORTC
	SBRS R16, PC0			;LEE PC0 AUMENTA SI ES 1 SALTA AL SIGUENTE INS
	RJMP INCREASE1			

	IN R17, PINC
	SBRS R17, PC1			;LEE PC1 AUMENTA SI ES 1 SALTA AL SIGUENTE INS
	RJMP DECREASE1
	OUT PORTB, R19			
	RET

COUNTER2:
	IN R21, PINC			;LEE PORTC
	SBRS R21, PC2			;LEE PC0 INCREASE SI ES 1 SALTA INS
	RJMP INCREASE2			;INCREASE

	IN R22, PINC
	SBRS R22, PC3			;LEER PC1 DECREASE SI ES 1 SALTA INS
	RJMP DECREASE2
	OUT PORTD, R23			;MOSTRAR COUNTER2
	RET

;*******************************
;DELAY
DELAYBOUNCE:
	LDI R16, 0			
	LDI R17, 0
	
	DELAY:
		DEC R16				;DECREASE R16
		BRNE DELAY			;SI R16 NO ES 0 REGRESAR AL DELAY
		DEC R17
		BRNE DELAY
	
	SBI PINC, (PC1 & PC0 & PC2 & PC3 & PC4)	;ES SALTA INS SI REGESTER ES 1
	RJMP DELAYBOUNCE
	RJMP LOOP

;**********************************
;ACCIONES
INCREASE1:
	CPI R19, 15				;SI COUNT ES 15
	BREQ LOOP				;SI COUNT ES 15 VA A LOOP Y NO A INC 
	INC R19					;R19 SOLO PARA CONTAR
	RJMP DELAYBOUNCE

DECREASE1:
	CPI R19, 0				;SI COUNTER ES ZERO
	BREQ LOOP				;SI ES ZERO REGRESAR A LOOP Y NO A DEC 
	DEC R19
	RJMP DELAYBOUNCE

INCREASE2:
	CPI R20, 15				;SI COUNT ES 15
	BREQ LOOP				;SI COUNT ES 15 A LOOP NO INC 
	INC R20					;R20 CONTADOR
	CALL SHSESL
	RJMP DELAYBOUNCE

DECREASE2:
	CPI R20, 0				;SI COUNTER ES ZERO
	BREQ LOOP				;SI ES ZERO REGRESA LOOP NO DEC 
	DEC R20
	CALL SHSESL
	RJMP DELAYBOUNCE

SHSESL:
	MOV R23, R20			;R20 A R23
	LSL R23
	LSL R23					
	RET
