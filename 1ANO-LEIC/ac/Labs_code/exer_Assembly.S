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

;# define SIZE 5
;Constantes do programa
    .equ SIZE, 5
    .equ MINUS1, 0xFFFF ; -1

	.text
main:
/*void main ( void ) {
fill_zero(occurrences1, SIZE * 2);
fill_zero(occurrences2, SIZE * 2);
vowel_histogram ( phrase1 , 7 , occurrences1 ) ;
vowel_histogram ( phrase2 , 50 , occurrences2 ) ;
}*/
	; salva LR se função não folha
	push	lr
    ;preparar o r0 e o r1, pois na chamada de fill_zero precisamos desses registos
    ldr r0, occurrences1_addr
    mov r1, #SIZE * 2
    bl  fill_zero       ;chamar fill_zero(occurrences1, SIZE * 2)
    ldr r0, occurrences2_addr
    mov r1, #SIZE * 2       ;iniciamos novamente pois quando é feita a chamada a função esse valor é perdido(?)
    bl fill_zero
    ldr r0, phrase1_addr
    mov r1, #7
    ldr r2, occurrences1_addr
    bl vowel_histogram          ;efetuar a chamada à função vowel_histogram(phrase1, 7, occurrences1)
    ldr r0, phrase2_addr
    mov r1, #50
    ldr r2, occurrences2_addr
    bl vowel_histogram          ;efetuar a chamada à função vowel_histogram(phrase2, 50, occurrences2)
	; retorna desempilhando endereço de retorno se função não folha
	pop		pc
	; retorna transferindo LR para PC se função folha
	; mov pc, lr

occurrences1_addr:
    .word occurrences1      ;label que corresponde a uma label em memória

occurrences2_addr:
    .word occurrences2      ;label que corresponde a uma label em memória

phrase1_addr:
    .word phrase1

phrase2_addr:
    .word phrase2
/*
i no seu tempo de vida tem operações relacionadas com chamadas à função 
void vowel_histogram ( char phrase [] , uint16_t max_letters , uint16_t occurrences [5] ) {
int16_t idx ;
uint16_t i ;
    for( i = 0; phrase [ i ]!= '\0 ' && i < max_letters ; i ++ ) {
        if ( ( idx = which_vowel ( phrase [ i ] ) ) != -1 ) {
            occurrences [ idx ]++;
}
}
}*/

vowel_histogram:
    push lr
    push r4     ;phrase
    push r5     ;max_letters
    push r6     ;occurrences
    push r7     ;i
    push r8
    mov r4, r0      ;
    mov r5, r1      ;transferência de valores
    mov r6, r2      ;
    mov r7, #0      ;i = 0
    mov r8, #MINUS1 & 0xFF
    movt r8, #MINUS1 >> 8
    b   vowel_histogram_for_ctrl

vowel_histogram_for_ctrl:
    ldrb    r0, [r4, r7]        ;r0 = phrase[i]
    and     r0, r0, r0              ;phrase [i] = '\0'
    bzs     vowel_histogram_end     ;se esta der falso salta logo para o fim -> a expressão deu zero
    cmp     r7, r5                  ; and -> && i < max_letters
    blo     vowel_histogram_for_body

vowel_histogram_for_body:
    ;não vale fazer ldrb r0, [r4, r7] pois r0 já tem esse valor!, é um registo da função 
    bl which_vowel      ;which_vowel(phrase[i])
    cmp r0, r8
    beq vowel_histogram_update
    lsl r0, r0, #1
    ldrb r1, [r6, r0]       ; r1 = occurrences[idx]
    add r1, r1, #1          ; occurrences[idx]++
    strb r1, [r6, r0]       ; occurrences[idx] = r1
vowel_histogram_update:
    add r7, r7, #1      ;i++

vowel_histogram_end:
    pop r8
    pop r7
    pop r6
    pop r5
    pop r4
    pop pc

;void fill_zero(uint8_t a[], uint16_t size); preencher byte a byte a zero pois precisamos de ter valores inicias no occurrences
;   for(uint16_t i = 0, i < SIZE, i++)
;       a[i] = 0
fill_zero:
    mov r2, #0      ;i = 0
    mov r3, #0      ;val = 0
    b   fill_zero_while_ctrl
fill_zero_while_body:
    strb r3, [r0, r2]   ;a[i] = 0, escreve em memória o conteúdo dado por r0 e um indice dado por r2
    add r2, r2, #1      ;i++

fill_zero_while_ctrl:
    cmp r2, r1      ;i - SIZE -> i < SIZE
    blo fill_zero_while_body
    mov pc, lr
	
 /*
Variáveis globais - Dados globais do programa iniciados e não iniciadas(só precisam de alocar espaço)
uint16_t occurrences1 [ SIZE ];
uint16_t occurrences2 [ SIZE ];
uint8_t phrase1 [] = "hello , world "; string pois acaba em zero
uint8_t phrase2 [] = "the quick brown fox jumps over the lazy dog ";
 */
	.data
occurrences1:           ;como temos um valor a 16 bits significa que temos uma word.
                        ; Se queremos occurrences de size siginfia que temos 5 words, logo 5 * 2 bytes
    .space  SIZE * 2

occurrences2:
    .space SIZE * 2

phrase1:
    .asciz "hello , world"

phrase2:
    .asciz "the quick brown fox jumps over the lazy dog"

/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
