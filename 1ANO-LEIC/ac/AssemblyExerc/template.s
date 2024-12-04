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
	
/* Secção com código aplicacional (programa)
 */
	.text
main:
	; salva LR se função não folha
	push	lr

	; retorna desempilhando endereço de retorno se função não folha
	pop		pc
	; retorna transferindo LR para PC se função folha
	mov		pc, lr
	
/* Dados globais do programa iniciados
 */ 
	.data

/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
