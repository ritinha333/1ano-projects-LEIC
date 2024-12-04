/* Sec��o de arranque: c�digo de inicializa��o
 * 1. Estabelece vetores (entry point ap�s reset e de interrup��o)
 * 2. Inicia stack pointer
 * 3. Chama main
 * 4. Ret�m a execução do CPU após o retorno do main
 */
	.section .startup	;código de boostrap, secção de arranque
	b		_start		
	b 		.			;salto para a própria instrução, PC-2
_start:
	ldr		sp, stack_top_addr	;iniciar o valor do stackpointer para o topo do stack, SP = mem[PC+8(4words)]
	mov		r0, pc				;colocar o valor do pc para o r0 
	add		lr, r0, #4			;Chamada do programcounter, passar para o linkregistor o valor ao qual o pc quer aceder
	ldr		pc, main_addr		;aceder a essa posição
	b 		.	
stack_top_addr:
	.word stack_top
main_addr:
	.word	main
	
/* Seccção com código aplicacional (programa)
 */

	.equ 	INPORT_ADDRESS, 	0xD000
	.equ 	OUTPORT_ADDRESS, 	0xD000
	.equ 	ARRAY_MASK, 		0x38
	.equ	ARRAY_POS, 			0x03
	
	.text

; Rotina:    main
; Descricao: Dependendo do valor presente dos bits 3 a 5 porto de entrada é indexado um array em memória ao qual 
;			 se obtem um valor que é escrito no porto de saída.
; Entradas:  -
; Saidas:  -
; Efeitos:
main: 
	mov		r0, #0				; R0 = 0
	bl 		outport_write_words	; recebe R0 e coloca o valor de r0 no Outport 0..15
main_loop:
    bl      inport_read         ; Lê os bits do porto de entrada
    mov     r1, #ARRAY_MASK     ; Coloca o valor de máscara(0x38 --> bits 3 a 5) em r1
	and		r0, r0, r1			; Seleciona os bits que queremos analisar, para isso faz-se um and e um lsr, para estarem localizados nos bits de menor peso.
	lsr		r0, r0, #ARRAY_POS	; De modo que estejam localizados nos bits de menor peso.
    ldr     r1, array_addr      ; Carrega o valor da variável array_addr para r1
    ldrb    r0, [r1, r0]        ; Dependendo do valor
    bl      outport_write_HIGH  ; Escreve o valor de r0 na parte alta do porto de saída
    b       main_loop



; Rotina:    inport_read
; Descricao: Lê do porto de entrada o valor lá presente e coloca-o num registo (byte-wise)
; Entradas:  -
; Saidas:    r0 - Byte lido do porto de entrada
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF

inport_read:
	mov		r1, #INPORT_ADDRESS & 0xFF
	movt	r1, #INPORT_ADDRESS >> 8 & 0xFF
	ldrb 	r0, [r1, #1]
	mov		pc, lr

; Rotina:    outport_write_words
; Descricao: De acordo uma valor específico escreve uma word no porto de saída (word-wise)
; Entradas:  r0 - valor a escrever no porto
; Saidas:    -
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF

outport_write_words:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	str		r0, [r1, #0]
	mov		pc, lr

; Rotina:    outport_write_LOW
; Descricao: De acordo uma valor presente em r0, escreve um byte na parte baixa do porto de saída (indexado em endereços par)
; Entradas:  r0 - valor a escrever no porto
; Saidas:    -
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF

outport_write_LOW:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	strb	r0, [r1, #0]
	mov		pc, lr

; Rotina:    outport_write_HIGH
; Descricao: De acordo uma valor presente em r0, escreve um byte na parte alta do porto de saída (indexado em endereços ímpar)
; Entradas:  r0 - valor a escrever no porto
; Saidas:    -
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF

outport_write_HIGH:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	strb	r0, [r1, #1]
	mov		pc, lr			

array_addr:
    .word array

/* Dados globais do programa iniciados e não iniciadas(só precisam de alocar espaço)
 */ 
	.data

array:
    .byte 1, 2, 4, 8, 16, 32, 64, 128
	
/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
