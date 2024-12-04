
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

3.b) Para a implementação da função color_scale serão necessários 38 bytes em memória. Cada instrução
     no P16 é codificada a 16 bits -> temos 2 bytes por cada instrução. Como se tem 19 instruções serão 
     necessários 38 bytes em memória para a sua implementação. 

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
    .equ    SIZE, 10

	.text

;r0 = i, r1 = colorhistogram
main:
	push	lr
    push    r4          ;colorhistogram
    push    r5          ;i
    push    r6          ;auxiliar
    ldr		r0, color_histogram_addr
    ldrb    r4, [r0]
    mov     r4, r0
    mov     r5, #0                  ;i = 0
    b       while_main_ctrl
    
main_body:
    ldr     r2, size_addr           ;size
    ldr     r0, times_addr          ;load do array times
    mov     r1, r4                  ;passar o colorhistogram para o r1
    bl      test_color_scale        ;salto para a função test_color_scale
    mov     r0, #0                  ;retornar em r0 o valor 0 
    b       main_end                ;salto para main_end

while_main_body:
    add     r5, r5, #1          ;i++
    str     r4, [r4, r5]        ;r1 = colorhistogram[i++]
    mov     r1, #0
    str     r1, [r4, r5]        ; r1 =  colorhistogram[i++] = 0
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
    pop     r6
	pop		pc

;--------------------------------------------------------------
;r0 = t[], r1 = c[], r2 = size -> valores que são recebidos da chamada à função
;em test_color_scale -> parâmetros relacionados com a chamada à função = t[], size, i
;r4 = t[], r5 = size, r6 = i, r1 = colorhistogram (este parâmetro usa o retorno do bl de color_scale)

test_color_scale:
    push    lr
    push    r4      ;times[]
    push    r5      ;size
    push    r6      ;i
    push    r7      ;colorhistogram[]

    ;transferência de dados
    mov     r4, r0                          ;valor de times[]   
    mov     r7, r1                          ;valor de colorhistogram[]
    mov     r5, r2                          ;valor de size
    mov     r6, #0                          ;i = 0 -> condição do for 
    b       test_color_scale_for_ctrl

test_color_scale_body:
    ldr     r0, [r4, r6]                     ;r0 = t[i] -> está bem
    bl      color_scale                      ;recebe em r0 o valor de t 
    ldrb     r1, [r7, r0]                    ;valor com o indice t em color_histogram
    add      r1, r1, #1                      ;incrementar o valor desse indice por 1
    strb     r1, [r7, r0]                    ;escrever o valor incrementado em r1 para o arraay color_histogram[]
    b       test_color_scale_update

test_color_scale_update:
    add     r6, r6, #2

test_color_scale_for_ctrl:
    cmp     r6, r5      ;i - size
    bge     test_color_scale_for_end        ;caso i >= size -> sai do ciclo com sinal logo = bge
    b       test_color_scale_body

test_color_scale_for_end:
    pop     r7
    pop     r6
    pop     r5
    pop     r4
    pop     pc

color_histogram_addr:
    .byte color_histogram
    .align 1

times_addr:
    .word times

size_addr:
    .word   SIZE*2

;retorno de test_color_scale vai em r0 == valor de t[i]
;parâmetros -> r0 = t, r1 = c, r2 = auxiliar para constantes

color_scale:         
    ldr     r2, green_scale_addr
    mov     r1, r2      ;c = GREEN_SCALE

color_scale_first_if:
    ldr     r2, critical_time_addr
    cmp     r0, r2
    blo     color_scale_second_if
    ldr     r2, warning_time_addr
    cmp     r0, r2
    bhs     color_scale_second_if
    ldr     r2, ambar_scale_addr
    mov     r1, r2                  ;c = ambar_scale
    b       color_scale_end

color_scale_second_if:
    ldr     r2, critical_time_addr
    cmp     r0, r2
    bhs     color_scale_end
    ldr     r2, red_scale_addr
    mov     r1, r2                  ;c = red_scale
    b       color_scale_end

color_scale_end:
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
    .space 3
    .align 1

times:
    .word 65535, 500, 301, 300, 299, 151, 150, 149, 1, 0

;Stack: pilha com dados temporários

	.equ STACK_SIZE, 64
	.section .stack
	.space STACK_SIZE
stack_top:

