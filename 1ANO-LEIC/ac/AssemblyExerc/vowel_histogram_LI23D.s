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
	
/* 	Constantes */
	.equ	SIZE, 5
	.equ	MINUS1, -1

/* Secção com código aplicacional (programa)
 */
	.text
/*
void main ( void ){
	fill_zero(occurences1, SIZE * 2);
	fill_zero(occurences2, SIZE * 2);
	vowel_histogram ( phrase1 , 7, occurrences1 );
	vowel_histogram ( phrase2 , 50, occurrences2 );
}
*/
main:
	; salva LR se fun��o n�o folha
	push	lr
	ldr		r0, occurrence1_addr
	mov		r1, #SIZE * 2
	bl 		fill_zero				; fill_zero(occurrences1, SIZE * 2)
	ldr		r0, occurrence2_addr
	mov		r1, #SIZE * 2
	bl 		fill_zero				; fill_zero(occurrences1, SIZE * 2)
	ldr		r0, phrase1_addr
	mov		r1, #7
	ldr		r2, occurrence1_addr
	bl		vowel_histogram		; vowel_histogram(phrase1, 7, occurences1);
	ldr		r0, phrase2_addr
	mov		r1, #50
	ldr		r2, occurrence2_addr
	bl		vowel_histogram		; vowel_histogram(phrase2, 50, occurrences2);	
	; retorna desempilhando endere�o de retorno se fun��o n�o folha
	pop		pc
occurrence1_addr:
	.word 	occurrences1
occurrence2_addr:
	.word 	occurrences2
phrase1_addr:
	.word 	phrase1
phrase2_addr:
	.word 	phrase2
	
/*
void vowel_histogram ( char phrase [], uint16_t max_letters , 
							uint16_t occurrences [5] ) {
	int16_t idx ;
	uint16_t i;
	for ( i = 0; phrase [i]!= '\0 ' && i < max_letters ; i++ ) {
		if ( ( idx = which_vowel ( phrase [i] ) ) != -1 ) {
			occurrences [ idx ]++;
		}
	}
}*/
vowel_histogram:
	push	lr
	push	r4			; phrase
	push	r5			; max_letters
	push	r6			; occurrences
	push	r7			; i
	push	r8
	mov		r4, r0
	mov		r5, r1	
	mov		r6, r2
	mov		r7, #0		; i = 0
	mov		r8, #MINUS1 & 0xFF
	movt	r8, #MINUS1 >> 8
	b 		vowel_histogram_for_ctrl
vowel_histogram_for_body:
	bl		which_vowel	; which_vowel(phrase[i])
	cmp		r0, r8
	beq		vowel_histogram_for_update
	lsl		r0, r0, #1
	ldrb	r1, [r6, r0]	; r1 = occurrences[idx]
	add		r1, r1, #1		; occurrences[idx]++
	strb	r1, [r6, r0]	; occurrences[idx] = r1
vowel_histogram_for_update:
	add		r7, r7, #1		; i++
vowel_histogram_for_ctrl:
	ldrb	r0, [r4, r7]	; r0 = phrase[i]
	and		r0, r0, r0		; phrase[i] != '\0'
	bzs		vowel_histogram_end
	cmp		r7, r5			; i < max_letters
	blo 	vowel_histogram_for_body
vowel_histogram_end:
	pop		r8
	pop		r7
	pop		r6
	pop		r5
	pop		r4
	pop		pc
	
/*
int16_t which_vowel ( char letter ) {
	int16_t i;
	switch ( letter ) {
		case 'a' : i = 0; break ;
		case 'e' : i = 1; break ;
		case 'i' : i = 2; break ;
		case 'o' : i = 3; break ;
		case 'u' : i = 4; break ;
		default : i = -1;
	}
	return i;
}
*/
which_vowel:
	mov		r1, #'a'
	cmp		r0, r1
	bne		which_vowel_case_e
	mov		r0, #0
	b 		which_vowel_ret
which_vowel_case_e:
	mov		r1, #'e'
	cmp		r0, r1
	bne 	which_vowel_case_i
	mov		r0, #1
	b 		which_vowel_ret
which_vowel_case_i:
	mov		r1, #'i'
	cmp		r0, r1
	bne 	which_vowel_case_o
	mov		r0, #2
	b 		which_vowel_ret
which_vowel_case_o:
	mov		r1, #'o'
	cmp		r0, r1
	bne 	which_vowel_case_u
	mov		r0, #3
	b 		which_vowel_ret
which_vowel_case_u:
	mov		r1, #'u'
	cmp		r0, r1
	bne 	which_vowel_default
	mov		r0, #4
	b 		which_vowel_ret
which_vowel_default:
	mov		r0, #0xFF
	movt	r0, #0xFF
which_vowel_ret:
	mov		pc, lr


/* void fill_zero(uint8_t a[], uint16_t size) {
		for (uint16_t i = 0; i < size; i++) 
			a[i] = 0;
	}
*/
fill_zero:
	mov		r2, #0 			; i = 0
	mov		r3, #0 			; val = 0
	b 		fill_zero_while_ctrl
fill_zero_while_body:
	strb	r3, [r0, r2]	; a[i] = 0
	add		r2, r2, #1		; i++
fill_zero_while_ctrl:
	cmp		r2, r1			; i < size
	blo		fill_zero_while_body
	mov		pc, lr
	
/*
# define SIZE 5
uint16_t occurrences1 [ SIZE ];
uint16_t occurrences2 [ SIZE ];
uint8_t phrase1 [] = "hello , world ";
uint8_t phrase2 [] = "the quick brown fox jumps over the lazy dog";
*/	
/* Dados globais do programa iniciados
 */ 
	.data
occurrences1:
	.space	SIZE * 2
occurrences2:
	.space	SIZE * 2
phrase1:
	.asciz	"hello, world"
phrase2:
	.asciz 	"the quick brown fox jumps over the lazy dog"
	
	
/* Stack: pilha com dados tempor�rios
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
