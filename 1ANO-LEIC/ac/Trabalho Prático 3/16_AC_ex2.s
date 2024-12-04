; Compilation statement:
; > p16as -s .text=0x3000 -s .stack=0x7FF0 16_AC_ex2.s
	.text
ex2:
; Valores iniciais
; PC= 0x3000, SP= 0x8000
; R0= 0xA055, R1= 0x1000
; R2= 0x0080
;
	movt 	r0, #0xFD
	strb 	r0, [r1, #0]
	strb	r2, [r1, #1]
	push	r1
	ldrb	r3, [r1, #0]
	lsl		r1, r1, #3
	ldrb	r3, [r1, #0]
	pop 	r4
	b		.
main:
	mov		r0, #0x55
	movt	r0, #0xA0
	mov		r1, #0x00
	movt 	r1, #0x10
	mov		r2, #0x80
	ldr		sp, stack_top_addr
	b 		ex2
stack_top_addr:
	.word stack_top
	
	.equ STACK_SIZE, 16
	.stack
	.space STACK_SIZE
stack_top:
