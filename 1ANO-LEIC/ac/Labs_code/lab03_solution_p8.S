; Ficheiro:  lab03.S
; Descricao: Programa para a realização da 3a atividade laboratorial de
;            Arquitetura de Computadores.
; Autor:     Tiago M Dias (tiago.dias@isel.pt)
; Data:      18-04-2024

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ	STACK_SIZE, 64                ; Dimensao do stack

; *** Início de zona para completar ***
	.equ	INPORT_ADDRESS, 		0xFF80 
	.equ	OUTPORT_ADDRESS,		0xFFC0
; *** Final de zona para completar  ***
; Constantes relacionadas com o porto de entrada
	.equ	TIMES_MASK, 			0x7
	.equ	TIMES_POS,				0
	.equ	BLINK_ENA_MASK,		0x80
; Constantes relacionadas com o porto de saída
	.equ	APP_ON_MASK, 			0x80
	.equ	BLINK_MASK, 			1

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;
	.section startup
	ldr	sp, stack_top_addr
    mov r0, pc
    add lr, r0, #4
	ldr	pc, main_addr
    b   .

stack_top_addr:
	.word	stack_top
main_addr:
	.word	main

; Seccao:    text
; Descricao: Guarda o código do programa
;
	.text

; Rotina:    main
; Descricao: Pisca um led do porto de saída a um ritmo estabelecido por três bits do porto de entrada. A ação de pisca é controlada por um bit do porto de entrada (transita modo pisca, apagado, por cada transição de OFF para ON do bit do porto de entrada). Pisca com modo pisca a 1; apaga com modo pisca a 0. Um bit do porto de saída é colocado a 1 indicando que a aplicação está em execução.
; Entradas:  
; Saidas:    
; Efeitos:   
main:
	push	lr
	push	r4						; Guarda tempo de pisca
	; Inicia porto de saída, blink_ena_last e blink_mode
	mov		r0, #APP_ON_MASK
	bl		outport_write
	ldr		r0, blink_ena_last_addr
	mov		r1, #0
	strb	r1, [r0]
	ldr		r0, blink_mode_addr
	strb	r1, [r0]
loop:
	bl		inport_read
	mov		r4, r0					; Guarda temporariamente imagem do porto de entrada
	bl		detect_falling_edge
	and 	r0, r0, r0				; Flag Z afetada de acordo com o retorno de detect_falling_edge
	ldr		r0, blink_mode_addr
	ldrb	r1, [r0]				; R1 = modo pisca
	bzs		main_l0				; Alterna modo de pisca se deteta transição de OFF para ON
	mov		r2, #1					
	eor		r1, r1, r2
	strb	r1, [r0]
main_l0:
	and		r1, r1, r1				
	bzs		loop					; Mantém apagado se modo pisca igual a 0
	mov		r0, #TIMES_MASK
	and		r0, r4, r0				; Filtra os 3 bits do índice times
	lsl		r0, r0, #TIMES_POS		; e coloca-os nos bits de menor peso (para a localização deste exercício é redundante)
	ldr		r1, times_addr			; Obtém endereço base de array times
	ldrb	r4, [r1, r0]			; Obtém tempo de pisca e preserva em registo Callee Saved Register (segundo as convenções é preservado com a chamada de outras funções)
	mov		r0, #APP_ON_MASK + BLINK_MASK
	bl		outport_write			; Coloca led Blink aceso + led APP ON
	mov		r0, r4
	bl		sleep					; Aguarda led aceso no tempo estabelecido
	mov		r0, #APP_ON_MASK
	bl 		outport_write			; Coloca led blink apagado + led APP ON
	mov		r0, r4
	bl		sleep					; Aguarda led apagado no tempo estabelecido
	b		loop
	pop		r4
	pop		pc
	
times_addr:
	.word	times
blink_mode_addr:
	.word	blink_mode

/*
uint8_t detect_falling_edge(uint8_t inport_val) {
	uint8_t domain_now = (inport_val & MASK_DOMAIN) >> POS_DOMAIN;
	uint8_t falling_edge = domain_last == 1 && domain_now == 0;
	domain_last = domain_now;
	return falling_edge;
}
*/
detect_falling_edge:
	; uint8_t blink_ena_now = (inport_val & BLINK_ENA_MASK) >> BLINK_ENA_POS;
	mov		r1, #BLINK_ENA_MASK
	and		r1, r0, r1				; R1 = blink_ena_now
	mov		r0, #0					; falling_edge = FALSE
	; uint8_t falling_edge = blink_ena_last == 1 && blink_ena_now == 0;
	ldr		r2, blink_ena_last_addr
	bzc		detect_falling_edge_l0 ; blink_ena_now == 0
	ldrb	r3, [r2]				; R3 = blink_ena_last
	and		r3, r3, r3
	bzs		detect_falling_edge_l0 ; blink_ena_last == 1
	mov		r0, #1					; falling_edge = TRUE
detect_falling_edge_l0:
	strb	r1, [r2]
	mov		pc, lr					; return falling_edge
	
blink_ena_last_addr:
	.word	blink_ena_last
	
; Rotina:    inport_read
; Descricao: *** Para completar ***
; Entradas:  -
; Saidas:    r0 - *** Para completar ***
; Efeitos:   r1 - *** Para completar ***
inport_read:
	mov		r1, #INPORT_ADDRESS & 0xFF
	movt	r1, #INPORT_ADDRESS >> 8 & 0xFF
	ldrb	r0, [r1, #0]
	mov		pc, lr

; Rotina:    outport_write
; Descricao: *** Para completar ***
; Entradas:  r0 - *** Para completar ***
; Saidas:    -
; Efeitos:   r1 - *** Para completar ***
outport_write:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	strb	r0, [r1, #0]
	mov		pc, lr

; Rotina:    sleep
; Descricao: *** Para completar ***
; Entradas:  *** Para completar ***
; Saidas:    *** Para completar ***
; Efeitos:   *** Para completar ***
sleep:
	and	r0, r0, r0
	beq	sleep_end
sleep_outer_loop:
	mov	r1, #0x3E
	movt	r1, #0x03
sleep_inner_loop:
	sub	r1, r1, #1
	bne	sleep_inner_loop
	sub	r0, r0, #1
	bne	sleep_outer_loop
sleep_end:
	mov	pc, lr

; Seccao:    data
; Descricao: Guarda as variáveis globais
;
	.data
times:
	.byte	5, 10, 15, 20, 25, 30, 35, 40
blink_ena_last:
	.space	1
blink_mode:
	.space	1

; Seccao:    stack
; Descricao: Implementa a pilha com o tamanho definido pelo simbolo STACK_SIZE
;
	.stack
	.space	STACK_SIZE
stack_top:
