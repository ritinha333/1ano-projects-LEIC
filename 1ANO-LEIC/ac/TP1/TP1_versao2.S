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

	; //Constantes
	.equ    U_INT16_T_3, 3
	.equ    U_INT16_T_10, 10

    .equ    RED_SCALE, 2
    .equ    AMBAR_SCALE, 1
    .equ    GREEN_SCALE, 0
    .equ    WARNING_TIME, 300
    .equ    CRITICAL_TIME, 150

	.text

/* Output: r0 -> sempre 0
*/	
main:
	push	lr							; salva LR se função não folha
	push    r4							; i
    push    r5      					; color_histogram []   
    push    r6      					; u_int16_t = 3
	push	r7							; times
	push	r8							; size -> 10

main_body:
	mov		r4, #0						; i = 0	
	ldr		r0, color_histogram_addr
	ldrb	r5, [r0]					; r5 = color_histogram
	ldr		r6, u_int16_t_3_addr		; r6 = 3
	ldr		r7, times_addr				; r7 = times
	ldr		r8, u_int16_t_10_addr		; r8 = 10	// size

main_while:
	cmp		r4, r6						; se i >= 3 ent termina o while
	blo		main_while_end

main_while_body:
	add     r4, r4, #1      			; i++
    strb    r5, [r5, r4]    			; r5 = colorhistogram[i++]
    mov     r5, #0          			; r5 = colorhistogram[i++] = 0
	b		main_while

main_while_end:
	; test_color_scale (r0, r1, r2)
	mov		r0, r7 						; r0 = times
	mov		r1, r5						; r1 = colorhistogram
	mov		r2, r8						; r2 = 10  //size
	bl 		test_color_scale

main_end:
	mov		r0, #0						; retorna 0 em r0
	pop		r8
	pop		r7
	pop		r6
	pop 	r5
	pop		r4
	pop		pc							; retorna desempilhando endereço de retorno se função não folha

color_histogram_addr:
    .byte 	color_histogram
    .align 	1

times_addr:
    .word 	times

u_int16_t_3_addr:
    .word   U_INT16_T_3

u_int16_t_10_addr:
    .word   U_INT16_T_10

; -----------------------------------------------------------------------------------------------------------------------
/*
Input: r0 = uint_16 -> t
Output: r0 = uint_8 -> define qual scale
*/
color_scale:
	push	r4		;	t
	push 	r5		;	GREEN_SCALE
	push	r6		;	CRITICAL_TIME
	push	r7		;	WARNING_TIME
	mov		r4, r0	; 	r4 = r0 = t
	ldr		r5, green_scale_addr	;	r5 = GREEN_SCALE
	ldr		r6, critical_time_addr	; 	r6 = CRITICAL_TIME
	ldr		r7, warning_time_addr	;	r7 = WARNING_TIME
	b		color_scale_if

color_scale_if:
	cmp		r4, r6
	blo		color_scale_else_if		; se t < CRITICAL_TIME ent vai para o else if
	cmp		r7, r4					; caso contrário verifica o segundo boolean do if
	blo		color_scale_else_if		; se WARNING_TIME < t ent vai para o else if
	ldr		r5,	ambar_scale_addr	; caso contrario significa que a expressao boleana do if deu true, logo dizemos que c = ambar_scale
	b		color_scale_if_end		; termina o if

color_scale_else_if:
	cmp		r4, r6
	bhs		color_scale_if_end		; se t >= CRITICAL_TIME ent termina o if devolvendo r1 com Green Scale
	ldr		r5, red_scale_addr		; caso contrário ira devolver r1 com o valor de red Scale
	b		color_scale_if_end		; termina o if

color_scale_if_end:
	mov		r0, r5					; define r0 o valor de c
	b		color_scale_end			; termina a funcao

color_scale_end:
	pop		r7
	pop		r6
	pop 	r5
	pop		r4
	mov 	pc, lr					;	retorna para a instrucao seguinte onde a funcao (color_scale) foi chamada (para isso é necessário fazer bl do color scale)
; -----------------------------------------------------------------------------------------------------------------------
; Input: r0 = uint16_t array_t [] , r1 = uint8_t array_c [] , r2 = int16_t array_t_size
test_color_scale:
	push	r4						; i
	push	r5						; array_t []
	push	r6						; array_c []
	push	r7						; array_t_size
	mov		r4, #0					; i = 0
	mov		r5, r0					; r5 = array_t []
	mov		r6, r1					; r6 = array_c []
	mov		r7, r2					; r7 = array_t_size

test_color_scale_for:
	cmp		r4, r2 					; se i >= array_t_size termina a funcao
	blt		test_color_scale_end

test_color_scale_for_body:
	ldr		r0, [r5, r4]			; r0 = t[i]
	bl		color_scale				
	strb	r0, [r0, #0]			; escreve em memória colorhistogram [retorno de color_scale]
	add		r0, r0, #1				; c[retorno color_scale]++

test_color_scale_for_update:
	add		r4, r4, #1				; i++
	b		test_color_scale_for

test_color_scale_end:
	pop		r7
	pop		r6
	pop		r5
	pop 	r4
	mov		pc, lr

/* Defenicao dos dados do programa
*/

red_scale_addr:
    .word   RED_SCALE

ambar_scale_addr:
    .word   AMBAR_SCALE

green_scale_addr:
    .word   GREEN_SCALE

warning_time_addr:
    .word   WARNING_TIME

critical_time_addr:
    .word   CRITICAL_TIME

/* Dados globais do programa iniciados
 */ 
	.data

color_histogram:
    .space U_INT16_T_3
	.align 1

times:
    .word 65535, 500, 301, 300, 299, 151, 150, 149, 1, 0

/* Stack: pilha com dados temporários
 */
	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:
