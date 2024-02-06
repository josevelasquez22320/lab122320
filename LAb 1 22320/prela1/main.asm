;UNIVERSIDAD DEL VALLE DE GUATEMALA
;IE2023: PROGRAMACIÓN DE MICROCONTROLADORES
;Lab1.asm
;AUTOR: Jose Andrés Velásquez García  
;PROYECTO: Contador binario de 4 bits
;HARDWARE: ATMEGA328P
;CREADO: 30/01/2024
;ÚLTIMA MODIFICACIÓN: 31/01/2024 10:54
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
	LDI R16, (1 << CLKPCE)	;PRESCALER ENABLE
	STS CLKPR, R16

	LDI R16, 0X03			;16MHz / 8
	STS CLKPR, R16			;FREC: 2MHz


	LDI R16, 0x1F			;TOMAR PC0 - PC4 entradas
	OUT PORTC, R16			;GUARDAR PORT DEFAULT SALIDA

	LDI R16, 0x20
	OUT DDRC, R16			;TODOS LOS PC0 - PC4 ENTRADAS PC5 SALIDA

	;LEDS
	LDI R16, 0x3F
	OUT DDRB, R16			;PB0 - PB5 SALIDA
	
	LDI R19, 0X00			;MUESTRA EL VALOR


LOOP:
	IN R16, PINC			;LEE REGISTRO PORTC
	SBRS R16, PC0			;LEE PC0 AUMENTA SI ES 1 SI NO SALTA INS
	RJMP INCREASE			;LLAMA INCREASE

	IN R17, PINC
	SBRS R17, PC1			;LEE PC1 BAJA SI = 1 SI NO SALTA A INS
	RJMP DECREASE
	
	OUT PORTB, R19			;MOSTRAR VALOR
	RJMP LOOP


;**********
;ACCIONES
DELAYBOUNCE:
	LDI R16, 0			;ESPERA ALGUN TIEMPO
	LDI R17, 0
	DELAY:
		DEC R16				;BAJA EN R16
		BRNE DELAY			;SI R16 NO = 0 REGRESA A DELAY
		DEC R17
		BRNE DELAY
	
	SBIS PINC, (PC1 & PC0)	;SALTA INSTR SI EL REGISRO = 1
	RJMP DELAYBOUNCE
	RJMP LOOP

INCREASE:
;R19 como contador
	INC R19					
	CPI R19, 15
	BREQ LOOP
	RJMP DELAYBOUNCE

DECREASE:
	DEC R19
	CPI R19, 0
	BREQ LOOP
	RJMP DELAYBOUNCE
