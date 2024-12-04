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
	
;Constantes
	.equ	SIZE, 5
/* Secção com código aplicacional (programa)
 */
	.text
main:
	; salva LR se função não folha
	push	lr
	ldr		r0, n1_addr
	mov		r1, #SIZE * 2
	bl 		primo
	; retorna desempilhando endereço de retorno se função não folha
	pop		pc
	; retorna transferindo LR para PC se função folha
	;mov		pc, lr

n1_addr:
	.word 	n1

/*
int ehPrimo(int n) {
    if (n <= 1)    return 0;
    for (int i = 2; i <= n / 2; i++) {
        if (n % i == 0)
            return 0;
    }
    return 1;
}*/

;   input: r0 = n
;   output: r0 = primo(n)
primo:
    ; prólogo
    push    lr
    push    r4      ; n
    push    r5      ; i
    push    r6      ; n/2

	mov		r0, #10

    ; iniciação de variáveis locais
    mov     r4, r0  	; r4 = n
    mov     r5, #2  	; i = 2
    lsr     r6, r0, #1	; r6 = n/2

	;corpo da função
	b		primo_body

;	if (n <= 1) return 0;
primo_body:
	mov		r0, #1
	cmp 	r0, r4
	bhs  	primo_body_for		; n > 1
	mov 	r0, #0
	b		primo_end
/*
	for (int i = 2; i <= n/2; i++) {
        if (n % i == 0)
            return 0;
    }
    return 1;
*/
primo_body_for:
	cmp r6, r5					; i > n/2
	bhs primo_body_for_end
	b	primo_body_for_if

primo_body_for_if:	
	mov r0, r4
	mov r1, r5
	bl	resto	; IN: r0 e r1, OUT: r0, r0 % r1 = r0	
	mov r1, #0		
	cmp r0, r1
	bzs primo_body_for_if_end	; n % i == 0 
	b	primo_body_for_update

primo_body_for_if_end:
	mov r0, #0
	b	primo_end

primo_body_for_update:
	add r5, r5, #1
	b	primo_body_for

primo_body_for_end:
	mov r0, #1
	b	primo_end

primo_end:
    pop     r6
    pop     r5
    pop     r4
    pop     lr
	b		.

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
n1:
	.space	SIZE * 2

/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:

