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
	.text
main:
	; salva LR se função não folha
	push	lr

	; retorna desempilhando endereço de retorno se função não folha
	pop		pc
	; retorna transferindo LR para PC se função folha
	; mov pc, lr
	
/* Dados globais do programa iniciados e não iniciadas(só precisam de alocar espaço)
 */ 
	.data

/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
