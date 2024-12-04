/* Secção de arranque: código de inicialização
 * 1. Estabelece vetores (entry point após reset e de interrupção)
 * 2. Inicia stack pointer
 * 3. Chama main
 * 4. Retém a execução do CPU após o retorno do main
 */
	.section .startup
	b		_start
	b 		.
_start:
	ldr		sp, stack_top_addr
	mov		r0, pc
	add		lr, r0, #4
	ldr		pc, main_addr
	b 		.	
stack_top_addr:
	.word stack_top
main_addr:
	.word	main
	
    ;-----------------------------------------------
    ; Constantes
    ;-----------------------------------------------
    .equ UINT16_MIN, 0      ; 0x0000 


/* Secção com código aplicacional (programa)
 */
	.text
main:
	; salva LR se função não folha
	push	lr

	; retorna desempilhando endereço de retorno se função não folha	(pop	pc)

	; retorna transferindo LR para PC se função folha
	mov		pc, lr

; In: R0 = a, R1 = n
; Out: R0 = indíce do maior absoluto
indexof_max:
    ; prólogo
    push lr
    push r4 ; a
    push r5 ; val
    push r6 ; idx
    push r7 ; i
    push r8 ; n

    ; iniciação de variáveis locais
    mov r4, r0                  ; R4=a
    lsl r8, r1, #1              ; R8=n
    mov r6, #0                  ; R6=idx
    mov r7, #0                  ; R7=i
    mov r5, #UINT16_MIN & 0xFF  ; R5=val
    movt r5, #UINT16_MIN >> 8   ;

    ; corpo da função
    b idxofmax_whilecond

idxofmax_whilebody:
    ldr r0, [r4, r7]
    bl abs
    cmp r5, r0
    bhs idxofmax_endif
    mov r5, r0
    mov r6, r7
idxofmax_endif:
    add r7, r7, #2
idxofmax_whilecond:
    cmp r7, r8
    blo idxofmax_whilebody
    ; epílogo e retorno
    lsr r0, r6, #1
    pop r8
    pop r7
    pop r6
    pop r5
    pop r4
    pop pc

; In: R0=v
; Out: R0=abs(v)
abs:
    mov r1, #0
    cmp r0, r1
    bge abs_endif
    sub r0, r1, r0
abs_endif:
    mov pc, lr

/*
INPUT: R0, R1
OUTPUT: R0
R0 % R1 = R0
*/
resto:
	cmp r0, r1 
	bhs resto_end 
	sub r0, r0, r1
	b	resto
resto_end:
	mov pc, lr 

/* Dados globais do programa iniciados
 */ 
	.data

/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
