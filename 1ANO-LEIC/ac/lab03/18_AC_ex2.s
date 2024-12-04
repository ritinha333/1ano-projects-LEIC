	.section .startup
	; sec��o com c�digo de arranque
	b		_start	
	b 		.	    
_start:
	ldr		sp, addr_stack_top
	mov		r0, pc
	add		lr, r0, #4
	ldr		pc, addr_main
	b		.
addr_main:
	.word main
addr_stack_top:
	.word stack_top

/*--------------------------------------------
 * Defini��o de constantes
 *--------------------------------------------*/
	.equ	SDP16_INPORT_ADDR , 	0xFF80
	.equ	SDP16_OUTPORT_ADDR, 	0xFFC0
	.equ	MASK_VAL_OUT, 			0xFF
	.equ	MASK_VAL_IN, 			0xF0
	.equ	MASK_DOMAIN, 			0x01
	.equ	POS_VAL_IN, 			4
	.equ	POS_DOMAIN, 			0
	.equ	UNSIGNED, 				1
	.equ	SIGNED, 				0
	
	.text
	; sec��o com c�digo aplicacional
	
/*
#define UNSIGNED  1
#define SIGNED    0
uint16_t main() {
	uint8_t domain = UNSIGNED;
   while (1) {
      uint8_t port_val = inport_read();
      if (detect_falling_edge(port_val) == TRUE)
         domain = domain == UNSIGNED ? SIGNED : UNSIGNED;
      uint8_t val_out = get_valin(port_val);
      if (domain == SIGNED) {
         val_out = valin2z(val_out);
      }
      outport_write_bits(MASK_VAL_OUT, val_out);
   }
   return 0;
}
*/
main:
	push	lr
	push	r4						; port_val
	push	r5						; val_out
	push	r6						; domain
	mov		r6, #UNSIGNED
	ldr		r0, domain_last_addr
	mov		r1, #0
	strb	r1, [r0]
main_loop:
	bl		inport_read			; R0 = inport_read()
	mov		r4, r0					; port_val = R0
	bl		detect_falling_edge	; R0 = detect_falling_edge(port_val)
	and		r0, r0, r0
	bzs		main_l0				; if (detect_falling_edge(port_val) == TRUE)
	mov		r0, #1
	eor		r6, r6, r0				; domain = domain ^ 1;
main_l0:
	mov		r0, r4					; R0 = port_val
	bl		get_valin				; R0 = get_valin(port_val)
	mov		r5, r0					; val_out = R0
	mov		r0, #UNSIGNED
	cmp		r6, r0
	beq		main_print			; if (domain == SIGNED)
	mov		r0, r5
	bl		valin2z				; R0 = valin2z(val_out)	
	mov		r5, r0					; val_out = R0
main_print:
	mov		r0, #MASK_VAL_OUT 	; R0 = MASK_VAL_OUT
	mov		r1, r5					; R1 = val_out
	bl		outport_write_bits	; outport_write_bits(MASK_VAL_OUT, val_out)
	b 		main_loop
	pop		r6
	pop		r5
	pop		r4
	pop		pc
	
; uint8_t get_valin(uint8_t inport_val);
get_valin:
	mov		r1, #MASK_VAL_IN
	and		r0, r0, r1
	lsr		r0, r0, #POS_VAL_IN
	mov		pc, lr

/*
uint8_t detect_falling_edge(uint8_t inport_val) {
	uint8_t domain_now = (inport_val & MASK_DOMAIN) >> POS_DOMAIN;
	uint8_t falling_edge = domain_last == 1 && domain_now == 0;
	domain_last = domain_now;
	return falling_edge;
}
*/
detect_falling_edge:
	mov		r1, #MASK_DOMAIN				
	and		r1, r0, r1					; R1 = inport_val & MASK_DOMAIN
	lsr		r1, r1, #POS_DOMAIN		; R1 = R1 >> POS_DOMAIN
	mov		r0, #0						; falling_edge = FALSE
	ldr		r2, domain_last_addr
	bzc		detect_falling_edge_l0	; domain_now == 0
	ldrb	r3, [r2]					; R3 = domain_last
	and		r3, r3, r3
	bzs		detect_falling_edge_l0	; domain_last == 1
	mov		r0, #1						; falling_edge = TRUE
detect_falling_edge_l0:
	strb	r1, [r2]					; domain_last = domain_now
	mov		pc, lr						; return falling_edge
domain_last_addr:
	.word	domain_last
	
; uint8_t valin2z(uint8_t val);
valin2z:
	lsl		r0, r0, #12
	asr		r0, r0, #12
	mov		pc, lr

/*--------------------------------------------
 * Implementa��o da API para portos paralelos
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
Faz a inicia��o do porto, atribuindo o valor value aos seus bits.
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

/* Atribui o valor l�gico um aos pinos do porto de sa�da identificados com o valor um em pins_mask. O valor dos restantes bits n�o � alterado.
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
Atribui o valor l�gico zero aos pinos do porto de sa�da identificados com o valor um em pins_mask. O valor dos restantes bits n�o � alterado.
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
Atribui aos bits do porto de sa�da identificados com o valor l�gico um em pins_mask o valor dos bits correspondentes de value. O valor dos restantes bits n�o � alterado.
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
	; sec��o com dados globais iniciados e n�o iniciados
outport_img:
	.space		1
domain_last:
	.space		1
	
	.equ STACK_SIZE, 64
	.section .stack
	; sec��o stack para armazenamento de dados tempor�rios
	.space	STACK_SIZE
stack_top:
