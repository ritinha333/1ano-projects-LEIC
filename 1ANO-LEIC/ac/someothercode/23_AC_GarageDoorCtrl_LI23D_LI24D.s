	.section .startup
	; sec��o com c�digo de arranque
	b	_start
	ldr	pc, ISR_ADDR
_start:
	ldr	sp, STACK_TOP_ADDR
    mov r0, pc
    add lr, r0, #4
	ldr	pc, MAIN_ADDR
    b   .

STACK_TOP_ADDR:
	.word	stack_top
MAIN_ADDR:
	.word	main
ISR_ADDR:
	.word	isr

/*--------------------------------------------
 * Defini��o de constantes
 *--------------------------------------------*/
	; Definicoes dos portos paralelos
	.equ	INPORT_ADDRESS, 	0xFF80
	.equ	OUTPORT_ADDRESS, 	0xFFC0
	
	; Definicoes do circuito pTC
	.equ	PTC_ADDRESS,  0xFF40			; Endereco do circuito pTC
	.equ	PTC_TCR, 0						; Deslocamento do registo TCR do pTC
	.equ	PTC_TMR, 2						; Deslocamento do registo TMR do pTC
	.equ	PTC_TC,  4						; Deslocamento do registo TC do pTC
	.equ	PTC_TIR, 6						; Deslocamento do registo TIR do pTC

	.equ	PTC_CMD_START, 0				; Comando para iniciar a contagem no pTC
	.equ	PTC_CMD_STOP, 1				; Comando para parar a contagem no pTC
	.equ	SYSCLK_FREQ, 99				; Intervalo de contagem do circuito pTC
	.equ	CPSR_BIT_I, 0b010000			; Mascara para o bit I do registo CPSR
	
	; Definicoes aplicacionais
	.equ	B_MSK, 				0x1
	.equ	SA_MSK,				0x2
	.equ	SF_MSK, 				0x4
	.equ	SO_MSK,				0x8
	.equ	B_POS,					0
	.equ	SA_POS,				1
	.equ	SF_POS,				2
	.equ	SO_POS,				3
	
	.equ	ONOFF_MSK,				0x1
	.equ	ABREFECHA_MSK,		0x2
	
	.equ	STATE_MSK,				0xE0
	.equ	STATE_POS,				5
	
	.equ	FECHADO_ST,			0
	.equ	ABERTO_ST,				2
	.equ	ABRIR_ST,				4
	.equ	FECHAR_ST,				6
	.equ	PARADO_ABRIR_ST,		8
	.equ	PARADO_FECHAR_ST,	10
	
	.equ 	TIMEOUT, 				30 ; 30 segundos (sysclk period = 1s)
	.text
	; sec��o com c�digo aplicacional
	
/*
uint16_t main() {
	uint8_t state = FECHAR_ST;
	for(;;) {
		uint8_t inport_img = inport_read();
		switch (state) {
		case FECHADO_ST:
			break;
		case ABERTO_ST:
			break;
		case ABRIR_ST:
			break;
		case FECHAR_ST:
			break;
		case PARADO_ABRIR_ST:
			break;
		case PARADO_FECHAR_ST:
			break;
	}
	return 0;
}
*/
main:
	push	lr
	push	r4						; state
	push	r5						; inport_img
	push	r6						; clock_ref
	mov		r4, #FECHAR_ST
	mov		r0, #SYSCLK_FREQ
	bl		sysclk_init
	mrs		r0, cpsr
	mov		r1, #CPSR_BIT_I
	orr		r0, r0, r1
	msr		cpsr, r0	
main_loop:
	lsr		r0, r4, #1
	bl		print_state
	bl		inport_read			; R0 = inport_read()
	mov		r5, r0					; R5 = inport_img
	add		pc, r4, pc
cases_table:
	b		case_fechado
	b 		case_aberto
	b 		case_abrir
	b 		case_fechar
	b 		case_parado_abrir
	b 	 	case_parado_fechar
case_fechado:
	mov		r0, r5
	bl		get_button
	bl		detect_falling_edge
	and		r0, r0, r0
	beq		main_loop
	mov		r4, #ABRIR_ST
	b 		main_loop
case_aberto:
case_parado_abrir:
	mov		r0, r5
	bl		get_button
	bl		detect_falling_edge
	and		r0, r0, r0
	bne		case_aberto_l0
	mov		r0, r6
	bl		get_time
	bl		timeout
	and		r0, r0, r0
	beq		main_loop	
case_aberto_l0:
	mov		r4, #FECHAR_ST
	b 		main_loop
case_parado_fechar:
	mov		r0, r5
	bl		get_button
	bl		detect_falling_edge
	and		r0, r0, r0
	beq		case_parado_fechar_l0
	mov		r4, #ABRIR_ST
	b 		main_loop
case_parado_fechar_l0:
	mov 	r0, r6
	bl		get_time
	bl		timeout
	and 	r0, r0, r0
	beq		main_loop
	mov		r4, #FECHAR_ST
	b 		main_loop
case_abrir:
	mov		r0, r5
	bl		get_sa
	and		r0, r0, r0
	beq		case_abrir_l0
	bl		para
	bl		get_time_ref
	mov		r6, r0
	mov		r4, #ABERTO_ST
	b 		main_loop
case_abrir_l0:
	bl		abre
	mov		r0, r5
	bl		get_button
	bl		detect_falling_edge
	and		r0, r0, r0
	beq		main_loop
	bl		para
	bl		get_time_ref
	mov		r6, r0
	mov		r4, #PARADO_ABRIR_ST
	b 		main_loop
case_fechar:
	mov		r0, r5
	bl		get_so
	and		r0, r0, r0
	beq		case_fechar_l0
	mov		r4, #ABRIR_ST
	b 		main_loop
case_fechar_l0:
	mov 	r0, r5
	bl		get_sf
	and		r0, r0, r0
	beq		case_fechar_l1
	bl		para
	mov		r4, #FECHADO_ST
	b 		main_loop
case_fechar_l1:
	bl 		fecha
	mov		r0, r5
	bl		get_button
	bl		detect_falling_edge
	and		r0, r0, r0
	beq		main_loop
	bl		para
	bl 		get_time_ref
	mov		r6, r0
	mov		r4, #PARADO_FECHAR_ST
	b 		main_loop
	
	pop		r6
	pop		r5
	pop		r4
	pop		pc
	
	
; Camada aplicacional

; uint8_t get_button(uint8_t inport_val);
get_button:
	mov		r1, #B_MSK
	and		r0, r0, r1
	lsr		r0, r0, #B_POS
	mov		pc, lr

; uint8_t get_sa(uint8_t inport_val);
get_sa:
	mov		r1, #SA_MSK
	and		r0, r0, r1
	lsr		r0, r0, #SA_POS
	mov		pc, lr

; uint8_t get_sf(uint8_t inport_val);
get_sf:
	mov		r1, #SF_MSK
	and		r0, r0, r1
	lsr		r0, r0, #SF_POS
	mov		pc, lr

; uint8_t get_so(uint8_t inport_val);
get_so:
	mov		r1, #SO_MSK
	and		r0, r0, r1
	lsr		r0, r0, #SO_POS
	mov		pc, lr

; void abre();
abre:
	push	lr
	mov		r0, #ONOFF_MSK + ABREFECHA_MSK
	bl		outport_set_bits
	pop		pc
	
; void fecha();
fecha:
	push	lr	
	mov		r0, #ONOFF_MSK + ABREFECHA_MSK
	mov		r1, #ONOFF_MSK
	bl		outport_write_bits
	pop		pc
	
; void para();
para:
	push	lr
	mov		r0, #ONOFF_MSK
	bl		outport_clear_bits
	pop		pc
	
; uint8_t timeout(uint16_t time);
timeout:
	mov		r1, r0
	mov		r2, #TIMEOUT & 0xFF
	movt	r2, #(TIMEOUT >> 8) & 0xFF
	mov		r0, #0
	cmp		r1, r2
	blo		timeout_l0
	mov		r0, #1
timeout_l0:
	mov		pc, lr
	
; uint16_t get_time(uint16_t time_ref);
get_time:
; ToDo

; uint16_t get_time_ref()
get_time_ref:
; ToDo
	
; void print_state(uint8_t state);
print_state:
	push	lr
	lsl		r1, r0, #STATE_POS
	mov		r0, #STATE_MSK
	bl		outport_write_bits
	pop		pc
	
/*
uint8_t b_last;
uint8_t detect_falling_edge(uint8_t b_now) {
	uint8_t falling_edge = b_last == 1 && b_now == 0;
	b_last = b_now;
	return falling_edge;
}
*/
detect_falling_edge:
	mov		r1, r0
	mov		r0, #0						; falling_edge = FALSE
	ldr		r2, B_LAST_ADDR
	bzc		detect_falling_edge_l0	; b_now == 0
	ldrb	r3, [r2]					; R3 = domain_last
	and		r3, r3, r3
	bzs		detect_falling_edge_l0	; b_last == 1
	mov		r0, #1						; falling_edge = TRUE
detect_falling_edge_l0:
	strb	r1, [r2]					; b_last = b_now
	mov		pc, lr						; return falling_edge
B_LAST_ADDR:
	.word	b_last
	
; Rotina:    isr
; Descricao: Incrementa o valor da vari�vel global sysclk.
; Entradas:  -
; Saidas:    -
; Efeitos:   *** Para completar ***
isr:
; ToDo

; Rotina:    sysclk_init
; Descricao: Inicia uma nova contagem no periferico pTC com o intervalo de
;            contagem recebido em R0, em ticks, limpando eventuais pedidos de
;            interrupcao pendentes e iniciando com o valor zero a variavel
;            global sysclk.
;            Interface exemplo: void sysclk_init( uint8_t interval );
; Entradas:  R0 - Valor do novo intervalo de contagem, em ticks.
; Saidas:    -
; Efeitos:   Inicia a contagem no periferico a partir do valor zero, limpando
;            eventuais pedidos de interrupcao pendentes e iniciando com o
;            valor zero a variavel global sysclk
sysclk_init:
; ToDo
	
; Rotina:    sysclk_get_ticks
; Descricao: Devolve o valor corrente da vari�vel global sysclk.
;            Interface exemplo: uint16_t sysclk_get_ticks ( );
; Entradas:  -
; Saidas:    *** Para completar ***
; Efeitos:   -
sysclk_get_ticks:
; ToDo

; Gestor de perif�rico para o Pico Timer/Counter (pTC)
;

; Rotina:    ptc_init
; Descricao: Faz a iniciacao do perif�rico pTC, habilitando o seu funcionamento
;            em modo continuo e com o intervalo de contagem recebido em R0, em
;            ticks.
;            Interface exemplo: void ptc_init( uint8_t interval );
; Entradas:  R0 - Valor do novo intervalo de contagem, em ticks.
; Saidas:    -
; Efeitos:   Inicia a contagem no periferico a partir do valor zero, limpando
;            o pedido de interrupcao eventualmente pendente.
ptc_init:
    push    lr
	ldr	r1, PTC_ADDR
	mov	r2, #PTC_CMD_STOP
	strb	r2, [r1, #PTC_TCR]
	strb	r0, [r1, #PTC_TMR]
    bl  ptc_clr_irq
	mov	r2, #PTC_CMD_START
	strb	r2, [r1, #PTC_TCR]
	pop pc

; Rotina:    ptc_start
; Descricao: Habilita a contagem no periferico pTC.
;            Interface exemplo: void ptc_start( );
; Entradas:  -
; Saidas:    -
; Efeitos:   -
ptc_start:
	ldr	r0, PTC_ADDR
	mov	r1, #PTC_CMD_START
	strb	r1, [r0, #PTC_TCR]
	mov	pc, lr

; Rotina:    ptc_stop
; Descricao: Para a contagem no periferico pTC.
;            Interface exemplo: void ptc_stop( );
; Entradas:  -
; Saidas:    -
; Efeitos:   O valor do registo TC do periferico e colocado a zero.
ptc_stop:
	ldr	r0, PTC_ADDR
	mov	r1, #PTC_CMD_STOP
	strb	r1, [r0, #PTC_TCR]
	mov	pc, lr

; Rotina:    ptc_get_value
; Descricao: Devolve o valor corrente da contagem do periferico pTC.
;            Interface exemplo: uint8_t ptc_get_value( );
; Entradas:  -
; Saidas:    R0 - O valor corrente do registo TC do periferico.
; Efeitos:   -
ptc_get_value:
	ldr	r1, PTC_ADDR
	ldrb	r0, [r1, #PTC_TC]
	mov	pc, lr

; Rotina:    ptc_clr_irq
; Descricao: Sinaliza o periferico pTC que foi atendido um pedido de
;            interrup��o.
;            Interface exemplo: void ptc_clr_irq( );
; Entradas:  -
; Saidas:    -
; Efeitos:   -
ptc_clr_irq:
	ldr	r0, PTC_ADDR
	strb	r1, [r0, #PTC_TIR]
	mov	pc, lr

PTC_ADDR:
	.word	PTC_ADDRESS

/*--------------------------------------------
 * Implementa��o da API para portos paralelos
 *--------------------------------------------*/
; Gestor de perif�rico para o porto de entrada
;

; Rotina:    inport_read
; Descricao: Adquire e devolve o valor corrente do porto de entrada.
;            Interface exemplo: uint8_t inport_read( );
; Entradas:  -
; Saidas:    R0 - valor adquirido do porto de entrada
; Efeitos:   -
inport_read:
	ldr	r1, INPORT_ADDR
	ldrb	r0, [r1, #0]
	mov	pc, lr

INPORT_ADDR:
	.word	INPORT_ADDRESS

; Gestor de perif�rico para o porto de sa�da
;

; Rotina:    outport_set_bits
; Descricao: Atribui o valor logico 1 aos bits do porto de saida identificados
;            com o valor 1 em R0. O valor dos outros bits nao e alterado.
;            Interface exemplo: void outport_set_bits( uint8_t pins_mask );
; Entradas:  R0 - Mascara com a especificacao do indice dos bits a alterar.
; Saidas:    -
; Efeitos:   Altera o valor da variavel global outport_img.
outport_set_bits:
	push	lr
	ldr	r1, outport_img_addr
	ldrb	r2, [r1, #0]
	orr	r0, r2, r0
	strb	r0, [r1, #0]
	bl	outport_write
	pop	pc

; Rotina:    outport_clear_bits
; Descricao: Atribui o valor logico 0 aos bits do porto de saida identificados
;            com o valor 1 em R0. O valor dos outros bits nao e alterado.
;            Interface exemplo: void outport_clear_bits( uint8_t pins_mask );
; Entradas:  R0 - Mascara com a especificacao do indice dos bits a alterar.
; Saidas:    -
; Efeitos:   Altera o valor da variavel global outport_img.
outport_clear_bits:
	push	lr
	ldr	r1, outport_img_addr
	ldrb	r2, [r1, #0]
	mvn	r0, r0
	and	r0, r2, r0
	strb	r0, [r1]
	bl	outport_write
	pop	pc

/* 
Atribui aos bits do porto de sa�da identificados com o valor l�gico um em pins_mask o valor dos bits correspondentes de value. O valor dos restantes bits n�o � alterado.
void outport_write_bits ( uint8_t pins_mask , uint8_t value );
*/
outport_write_bits:
	push	lr
	and		r1, r1, r0 ; filtra os bits em value de acordo com pins_mask
	ldr		r2, outport_img_addr
	ldrb	r3, [r2]
	mvn		r0, r0
	and		r0, r0, r3
	orr		r0, r0, r1
	strb	r0, [r2]
	bl		outport_write
	pop		pc

; Rotina:    outport_init
; Descricao: Faz a iniciacao do porto de saida, nele estabelecendo o valor
;            recebido em R0.
;            Interface exemplo: void outport_init( uint8_t value );
; Entradas:  R0 - Valor a atribuir ao porto de saida.
; Saidas:    -
; Efeitos:   Altera o valor da variavel global outport_img.
outport_init:
	push	lr
	ldr	r1, outport_img_addr
	strb	r0, [r1]
	bl	outport_write
	pop	pc

outport_img_addr:
	.word	outport_img

; Rotina:    outport_write
; Descricao: Escreve no porto de saida o valor recebido em R0.
;            Interface exemplo: void outport_write( uint8_t value );
; Entradas:  R0 - valor a atribuir ao porto de saida.
; Saidas:    -
; Efeitos:   -
outport_write:
	ldr	r1, OUTPORT_ADDR
	strb	r0, [r1, #0]
	mov	pc, lr

OUTPORT_ADDR:
	.word	OUTPORT_ADDRESS

	.data
	; sec��o com dados globais iniciados e n�o iniciados
outport_img:
	.space		1
b_last:					; Last registered value of button B
	.space		1
	.align
sysclk:
	.space		2
	
	.equ STACK_SIZE, 64
	.section .stack
	; sec��o stack para armazenamento de dados tempor�rios
	.space	STACK_SIZE
stack_top:
