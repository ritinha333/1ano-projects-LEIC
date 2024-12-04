
/*
1.b) Os símbolos RED_SCALE, AMBAR_SCALE, GREEN_SCALE, WARNING_TIME e CRITICAL_TIME são todos
    constantes do programa, logo cada constante está codificada a 16 bits. Como no P16 a memória
    guarda informção a cada word (16 bits), vão ser necessárias 5 words em memória, que equivalem
    a 5(words) * 2bytes(16 bits) = 10 bytes

2) Todas as variavéis globais devem ser implementadas na secção .data independentemente se são
   inicializadas ou não
   A variável uint8_t color_histogram[3] como ocupa um byte na secção .data esta será implementada
   da seguinte forma: color_histogram: .space 3  (uma vez que esta irá alocar 3bytes que serão 
   preenchidos no decorrer do progroma).
   A variável uint16_t times[] = { 65535, 500, 301, 300, 299, 151, 150, 149, 1, 0}, já inicializada 
   irá para cada elemento precisar duma word para  representar, ficando implementada da seguinte
   forma: times: .word 65535, 500, 301, 300, 299, 151, 150, 149, 1, 0.

3.b) quantidade em bytes que a implementação do color_scale ocupa ?(por cada instrução)?

4.a) Damos preferência sempre à utilização dos registos de r0..r3 para utilização nas funções pois a 
    partir desse momento é preciso memória para os restantes registos, mas como a variável i é usada num 
    contexto local no ciclo 'for' para fazer a chamada função color_scale(), o seu tempo de vida depende 
    da chamada à função, logo devemos associá-la aos registos de r4..r12.
    Logo a afirmação está correta, uma vez que de acordo os standard's da linguagem Assembly para o P16.




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
	
    .equ    AUX, 3
    .equ    RED_SCALE, 2
    .equ    AMBAR_SCALE, 1
    .equ    GREEN_SCALE, 0
    .equ    WARNING_TIME, 300
    .equ    CRITICAL_TIME, 150

	.text
;r0 = i, r1 = colorhistogram
;
main:
	push	lr
    push    r4          ;colorhistogram
    push    r5          ;i
    push    r6          ;auxiliar
    ldr     r0, color_histogram_addr
    ldrb    r4, [r0]    
    mov     r5, #0      ;i = 0
    b while_main_ctrl
    
main_body:
    mov     r2, #10         ;size
    ldr     r0, times_addr   ;load do array times   
    bl      test_color_scale        ;salto para a função test_color_scale
    mov     r0, #0              ;retornar em r0 o valor 0 
    b       main_end            ;salto para main_end

while_main_body:
    add     r5, r5, #1      ;i++
    strb    r1, [r4, r5]    ;r1 = colorhistogram[i++]
    mov     r1, #0          ; r1 =  colorhistogram[i++] = 0
    b       while_main_ctrl
    b       main_body

while_main_ctrl:
    ldr     r6, aux_addr
    cmp     r5, r6              ;i - 3
    bhs     while_main_end      ; caso i >= 3 vai para o fim do while
    b       while_main_body     ; caso i < 3 faz o que está dentro do while

while_main_end:
    b       main_body

main_end:
    pop     r4
    pop     r5
	pop		pc

color_histogram_addr:
    .byte color_histogram
    .align 1

times_addr:
    .word times

;--------------------------------------------------------------
;r0 = t[], r1 = c[], r2 = size -> valores que são recebidos da chamada à função
;em test_color_scale -> parâmetros relacionados com a chamada à função = t[], size, i
;r4 = t[], r5 = size, r6 = i, r1 = colorhistogram (este parâmetro usa o retorno do bl de color_scale)

test_color_scale:
    push    lr
    push    r4      ;times
    push    r5      ;size
    push    r6      ;i

    ;transferência de dados
    mov     r4, r0      ;valor de times[]    
    mov     r5, r2      ;valor de size
    mov     r6, #0      ;i = 0 -> condição do for 
    b       test_color_scale_for_ctrl


test_color_scale_for_ctrl:
    cmp     r6, r5      ;i - size
    bge     test_color_scale_for_end        ;caso i >= size -> sai do ciclo
    b       test_color_scale_body

test_color_scale_body:
    ldr     r0, [r4, r6]        ;r0 = t[i]
    bl      color_scale         ;recebe em r0 o valor de t[i]
    strb    r1, [r0, #0]        ;escreve em memória colorhistogram [retorno de color_scale]
    add     r1, r1, #1          ;c[retorno color_scale]++
    b       test_color_scale_update

test_color_scale_update:
    add     r6, r6, #1

test_color_scale_for_end:
    pop     r6
    pop     r5
    pop     r4
    pop     pc


;retorno de test_color_scale vai em r0 == valor de t[i]
;parâmetros -> r0 = times[], r1 = c, r2 = GREEN_SCALE, r3 = CRITICAL_TIME, r4 = WARNING_TIME
;r5 = AMBAR_SCALE, r6= RED_SCALE

color_scale:        ;aqui preciso de fazer push e pop (preservar os registos) dos registos visto que é uma função folha?
    push    r4      ;WARNING_TIME
    push    r5      ;AMBAR_SCALE
    push    r6      ;RED_SCALE
    ldr     r2, green_scale_addr
    ldr     r3, critical_time_addr
    ldr     r4, warning_time_addr
    ldr     r5, ambar_scale_addr
    ldr     r6, red_scale_addr
    mov     r1, r2      ;c = GREEN_SCALE
    b       color_scale_first_if_ctrl

color_scale_first_if_ctrl:
    cmp     r0, r3
    blo     color_scale_second_if_ctrl
    cmp     r4, r0
    bhs     color_scale_second_if_ctrl
    mov     r1, r5
    b       color_scale_end

color_scale_second_if_ctrl:
    cmp     r0, r3
    bhs     color_scale_end
    mov     r0, r6
    b       color_scale_end

color_scale_end:
    pop     r4
    pop     r5
    pop     r6
    mov     r0, r1      ;r0 = c
    mov     pc, lr

;definição dos dados do programa

aux_addr:
    .word   AUX

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

;Dados globais do programa iniciados e não iniciadas(só precisam de alocar espaço)
 
	.data

color_histogram:
    .space AUX
    .align 1

times:
    .word 65535, 500, 301, 300, 299, 151, 150, 149, 1, 0

;Stack: pilha com dados temporários

	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:

