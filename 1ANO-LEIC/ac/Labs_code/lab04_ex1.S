; Ficheiro:  lab04_ex1.S
; Descricao: Programa para a realização da 4a atividade laboratorial de
;            Arquitetura de Computadores.
; Autor:     Tiago M Dias (tiago.dias@isel.pt)
; Data:      28-04-2024

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ	STACK_SIZE, 64                ; Dimensao do stack - 64 B

; *** Inicio de troco para completar ***
	.equ	ENABLE_EXTINT, 0x10         ; Endereço onde está a rotina de interrupção 
; *** Fim de troco para completar ***

	.equ	OUTPORT_ADDRESS, 0xFFC0       ; Endereco do porto de saida

	.equ	VAR_INIT_VAL, 0               ; Valor inicial de var

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;

; Para a execução do código presente entre a linha 24 e 33 é necessário o sistema estar pronto para atender a 
; rotinas de interrupção. Para tal alguns aspetos devem ser tomados em consideração.
; 1 - A flag I (Interrupt Enable) presente no registo CPSR deverá estar com o valor lógico '1'
; 2 - Deverá existir uma interrupção, ou seja, algum pedido pendente de interrupção

;nCS = A1
;nCLR = A2
	.section startup
	b		_start
	push	r0
	push	r1
	ldr		r0, var_addr_startup
	ldrb	r1, [r0, #0]
	add		r1, r1, #1
	strb	r1, [r0, #0]
	pop		r1
	pop		r0
	movs	pc, lr
_start:
	ldr		sp, stack_top_addr
    mov 	r0, pc
    add 	lr, r0, #4
	ldr		pc, main_addr
    b   .

stack_top_addr:
	.word	stack_top
main_addr:
	.word	main
var_addr_startup:
	.word	var

; Seccao:    text
; Descricao: Guarda o código do programa
;
	.text

; Rotina:    main
; Descricao: *** Para completar ***
; Entradas:  *** Para completar ***
; Saidas:    *** Para completar ***
; Efeitos:   *** Para completar ***
main:
	mov		r0, #VAR_INIT_VAL			; r0 = VAR_INIT_VAL = 0
	ldr		r1, var_addr_main			; r1 = var
	strb	r0, [r1, #0]				; addr r1 é escrito VAR_INIT_VAL
	bl		outport_write				; Chamada à rotina outport_write com o valor de r0
	mrs		r0, cpsr					; Salvaguardar as flags do programa antes de efetuar uma interrupção
	mov		r1, #ENABLE_EXTINT			; Colocar o endereço da rotina de interrupção em r1
	orr		r0, r0, r1					; Gera a flag I
	msr		cpsr, r0					; Coloca novamente as flags no registo CPSR, flag I = '1'
main_loop:
	ldr		r0, var_addr_main			; r0 = var
	ldrb	r0, [r0, #0]				; Load da parte baixa do valor var para o registo r0
	bl		outport_write				; Chamada à rotina outport_write com o valor de r0 
	b		main_loop					; Loop

var_addr_main:
	.word	var

; Rotina:    outport_write
; Descricao: Escreve num porto de saida a 8 bits o valor passado como argumento.
;            Interface exemplo: void outport_write( uint8_t value );
; Entradas:  r0 - valor a escrever no porto de saida
; Saidas:    -
; Efeitos:   r1 - guarda o endereco do porto alvo da escrita
outport_write:
	ldr	r1, outport_addr
	strb	r0, [r1, #0]
	mov	pc, lr

outport_addr:
	.word	OUTPORT_ADDRESS

; Seccao:    data
; Descricao: Guarda as variáveis globais
;
	.data
var:
	.space	1

; Seccao:    stack
; Descricao: Implementa a pilha com o tamanho definido pelo simbolo STACK_SIZE
;
	.stack
	.space	STACK_SIZE
stack_top:
