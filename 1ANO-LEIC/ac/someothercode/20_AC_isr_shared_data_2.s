	.section .startup
	; secção com código de arranque
	b		_start	
	ldr		pc, isr_addr	    
_start:
	ldr		sp, stack_top_addr
	mov		r0, pc
	add		lr, r0, #4
	ldr		pc, main_addr
	b		.
main_addr:
	.word main
stack_top_addr:
	.word stack_top
isr_addr:
	.word isr

/*--------------------------------------------
 * Definição de constantes
 *--------------------------------------------*/
	.equ	SDP16_OUTPORT_ADDR, 	0xFFC0
	.equ	SDP16_INPORT_ADDR, 	0xFF80
	.equ	IE_ENA, 				0x10
	.equ	FE_MASK,				0x80
	.equ	IRQ_MASK,				0x08
	
	.text
	; secção com código aplicacional
	
main:
	push	lr
	mov		r0, #12
	mov		r1, #59
	mov		r2, #55
	bl		set_time_of_day
	mov		r0, #IRQ_MASK
	bl 		outport_set_bits
	mov 	r0, #IE_ENA
	msr		cpsr, r0
	
main_loop:
	mov		r0, #100
	bl		sleep
	bl		inport_read
	bl 		detect_falling_edge
	and		r0, r0, r0
	bzs		main_loop
	mov		r0, #IRQ_MASK
	bl 		outport_clear_bits
	; novo valor para a hora do dia
	mov		r0, #0
	mov		r1, #0
	mov		r2, #0
	bl		set_time_of_day
	b 		main_loop
	pop		pc
	
isr:
	push	lr
	push	r0
	push	r1
	push	r2
	push	r3
	
	; clear IRQ
	mov		r0, #IRQ_MASK
	bl		outport_set_bits
	
	mov		r2, #60
	ldr		r0, second_addr
	ldrb	r1, [r0]
	add		r1, r1, #1
	strb	r1, [r0]
	cmp		r1, r2
	bne		isr_end
	mov		r1, #0
	strb	r1, [r0]
	ldr		r0, minute_addr
	ldrb	r1, [r0]
	add		r1, r1, #1	
	strb	r1, [r0]
	cmp		r1, r2
	bne		isr_end
	mov		r1, #0
	strb	r1, [r0]
	ldr		r0, hour_addr
	ldrb	r1, [r0]
	add		r1, r1, #1
	mov		r2, #24
	cmp		r1, r2
	bne		isr_l0
	mov		r1, #0
isr_l0:
	strb	r1, [r0]
isr_end:
	pop		r3
	pop		r2
	pop		r1
	pop		r0
	pop		lr
	movs	pc, lr

; R0 = hour_new; R1 = minute_new; R2 = second_new
set_time_of_day:
	push	r4
	push	r5
	push	r6
	
	ldr		r3, hour_addr
	ldr		r4, minute_addr
	ldr		r5, second_addr
	
	mov		r6, #0
	msr		cpsr, r6
	strb	r0, [r3]
	strb	r1, [r4]
	strb	r2, [r5]
	mov		r6, #IE_ENA
	msr		cpsr, r6

	pop 	r6
	pop		r5
	pop		r4
	mov		pc, lr
	
hour_addr:
	.word	hour
minute_addr:
	.word	minute
second_addr:
	.word	second

detect_falling_edge:
	; uint8_t fe_now = (inport_val & FE_MASK) >> FE_POS;
	mov		r1, #FE_MASK
	and		r1, r0, r1				; R1 = fe_now
	mov		r0, #0					; falling_edge = FALSE
	; uint8_t falling_edge = fe_last == 1 && fe_now == 0;
	ldr		r2, fe_last_addr
	bzc		detect_falling_edge_l0 ; fe_now == 0
	ldrb	r3, [r2]				; R3 = fe_last
	and		r3, r3, r3
	bzs		detect_falling_edge_l0 ; fe_last == 1
	mov		r0, #1					; falling_edge = TRUE
detect_falling_edge_l0:
	strb	r1, [r2]
	mov		pc, lr					; return falling_edge
	
fe_last_addr:
	.word	fe_last

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

/*--------------------------------------------
 * Implementação da API para portos paralelos
 *--------------------------------------------*/
/*
Devolve o valor atual do estado dos bits do porto de entrada.
uint16_t inport_read ( );
*/
inport_read:
	ldr		r0, inport_addr
	ldrb	r0, [r0]
	mov		pc, lr

inport_addr:
	.word	SDP16_INPORT_ADDR

/* 
Faz a iniciação do porto, atribuindo o valor value aos seus bits.
void outport_write ( uint8_t value );
*/
outport_write:
	ldr		r1, outport_addr
	strb	r0, [r1]
	; save value to image port
	ldr		r1, outport_img_addr
	strb	r0, [r1]
	mov		pc, lr	

outport_addr:
	.word	SDP16_OUTPORT_ADDR

/* Atribui o valor lógico um aos pinos do porto de saída identificados com o valor um em pins_mask. O valor dos restantes bits não é alterado.
void outport_set_bits ( uint8_t pins_mask ); 
*/
outport_set_bits:
	push	lr
	ldr		r1, outport_img_addr
	ldrb	r1, [r1]
	orr		r0, r0, r1
	bl		outport_write
	pop		pc

/*
Atribui o valor lógico zero aos pinos do porto de saída identificados com o valor um em pins_mask. O valor dos restantes bits não é alterado.
void outport_clear_bits ( uint8_t pins_mask );
*/
outport_clear_bits:
	push 	lr
	ldr		r1, outport_img_addr
	ldrb	r1, [r1]
	mvn		r0, r0
	and		r0, r0, r1
	bl		outport_write
	pop		pc
	
/* 
Atribui aos bits do porto de saída identificados com o valor lógico um em pins_mask o valor dos bits correspondentes de value. O valor dos restantes bits não é alterado.
void outport_write_bits ( uint8_t pins_mask , uint8_t value );
*/
outport_write_bits:
	push	lr
	and		r1, r1, r0 ; filtra os bits em value de acordo com pins_mask
	ldr		r2, outport_img_addr
	ldrb	r2, [r2]
	mvn		r0, r0
	and		r0, r0, r2
	orr		r0, r0, r1
	bl		outport_write
	pop		pc

outport_img_addr:
	.word	outport_img

	.data
	; secção com dados globais iniciados e não iniciados
outport_img:
	.space		1
hour:
	.space		1
minute:
	.space		1
second:
	.space		1
fe_last:
	.space		1
	
	.equ STACK_SIZE, 64
	.section .stack
	; secção stack para armazenamento de dados temporários
	.space	STACK_SIZE
stack_top:
