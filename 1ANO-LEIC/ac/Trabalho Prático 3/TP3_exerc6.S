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
	.equ	OUTPORT_SEL_MASK, 	0x03
	
	.text

main:
	mov		r0, #0
	bl 		outport_write_words
loop:
    bl      inport_read         ; Lê os bits do porto de entrada
	mov		r2, r0
    mov     r1, #ARRAY_MASK     ; --------------------------
	and		r0, r0, r1			; Seleciona os bits de 3 a 5
	lsr		r0, r0, #ARRAY_POS	; --------------------------
    ldr     r1, array_addr      ; Carrega o valor da variável array_addr para r1
    ldrb    r0, [r1, r0]        ; Dependendo do valor
	bl		handle_writes
	b       loop



; Rotina:    inport_read
; Descricao: Lê do porto de entrada o valor lá presente e coloca-o num registo
; Entradas:  -
; Saidas:    r0 - Byte lido do porto de entrada
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF
inport_read:
	mov		r1, #INPORT_ADDRESS & 0xFF
	movt	r1, #INPORT_ADDRESS >> 8 & 0xFF
	ldrb 	r0, [r1, #1]
	mov		pc, lr

; Rotina:    outport_write
; Descricao: De acordo uma valor específico escreve um byte no porto de saída
; Entradas:  r0 - valor a escrever no porto
; Saidas:    -
; Efeitos:   r1 - Colocou r1 todo a 0xFFF

handle_writes:
	push lr
	mov     r1, #OUTPORT_SEL_MASK     	; --------------------------
	and		r2, r2, r1					; Seleciona os bits de 0 a 1
	mov		r3, #2
	cmp 	r2, r3
	beq		outport_write_words
	mov		r3, #3
	cmp		r2, r3
	beq		outport_write_words
	mov		r3, #1
	cmp 	r2, r3
	beq		outport_write_HIGH
outport_write_LOW:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	strb	r0, [r1, #0]
	pop 	pc
outport_write_words:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	str		r0, [r1, #0]
	pop 	pc
outport_write_HIGH:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	strb	r0, [r1, #1]
	pop 	pc		
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
