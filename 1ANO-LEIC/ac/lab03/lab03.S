; Ficheiro:  lab03.S
; Descricao: Programa para a realização da 3a atividade laboratorial de
;            Arquitetura de Computadores.
; Autor:     Tiago M Dias (tiago.dias@isel.pt)
; Data:      18-04-2024

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ	STACK_SIZE, 64                ; Dimensao do stack

; *** Início de zona para completar ***
	.equ	INPORT_ADDRESS, 0xFF80  		; Endereço inicial do porto de entrada SDP16
	.equ	OUTPORT_ADDRESS, 0xFFC0       	; Endereço inicial do porto de saída SDP16
; *** Final de zona para completar  ***

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;
	.section startup
	ldr		sp, stack_top_addr
    mov 	r0, pc
    add 	lr, r0, #4
	ldr		pc, main_addr
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
; Descricao: Faz a leitura e escrita nos portos paralelos, de entrada e saída respetivamente, da placa SDP16
; Entradas:  *** Para completar ***
; Saidas:    *** Para completar ***
; Efeitos:   *** Para completar ***
main:
	push	lr
	mov		r3, #0 ; var aux = 0
	mov		r0, #0xFF
	bl		outport_write
	mov		r0, #0x00
	bl		outport_write
loop:
	mov 	r0, #1
	bl 		sleep
	mov 	r0, #0x80		
	bl 		outport_write
	bl		inport_read
	mov 	r2, r0			;read_prev	
	mov 	r1, #0x80	
	and		r0, r0, r1
	bne 	testSW 
	b		loop
testSW:
	push 	lr
	mov 	r0, #0x80		
 	bl 		inport_read		; r0 = read_current
	cmp 	r2, r0			; caso r2 = 1 e r0 = 0 r2 - r0 = 1
	bge		loop 			; acaba o teste do bit de maior peso
	mov		r0, r3 			; r3 = 0 = r0 = aux
	bl 		test_aux			
	pop		pc


test_aux:
	push	lr
	mov 	r1, #0
	cmp 	r0, r1 ; comparo aux com 0, se for 0 apaga o outport e incrementa o aux, caso contrário faz a função pisca e decrementa aux
	beq		erase_outport
	sub		r3, r3, #1
	bl 		pisca
	pop 	pc

erase_outport:
	push 	lr
	add		r3, r3, #1
	mov 	r0, #0x00
	bl 		outport_write
	pop		pc

pisca:
	push	lr
	ldr 	r1, rithm_arr_addr
	ldrb 	r0, [r1, r2]
	bl 		sleep
	mov 	r0, #0x81	
	bl		outport_write
	pop		pc

; Rotina:    inport_read
; Descricao: Lê do porto de entrada o valor lá presente e coloca-o num registo
; Entradas:  -
; Saidas:    r0 - Byte lido do porto de entrada
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF
inport_read:
	mov		r1, #INPORT_ADDRESS & 0xFF
	movt	r1, #INPORT_ADDRESS >> 8 & 0xFF
	ldrb	r0, [r1, #0]
	mov		pc, lr

; Rotina:    outport_write
; Descricao: De acordo uma valor específico escreve um byte no porto de saída
; Entradas:  r0 - valor a escrever no porto
; Saidas:    -
; Efeitos:   r1 - Colocou r1 todo a 0xFFFF
outport_write:
	mov		r1, #OUTPORT_ADDRESS & 0xFF
	movt	r1, #OUTPORT_ADDRESS >> 8 & 0xFF
	strb	r0, [r1, #0]
	mov		pc, lr

; Rotina:    sleep
; Descricao: De acordo os valores presentes em r0 e r1, a rotina sleep fica em dois loops até que
;			 tanto r0 e r1 sejam zero e a flag z = 1, logo é uma rotina que faz o programa esperar
;			 ficando o mesmo em modo "repouso".
; Entradas:  r0
; Saidas:    -
; Efeitos:   r1 - Colocar r1 a 0x033E
sleep:
	and		r0, r0, r0			; r0 = r0 & r0
	beq		sleep_end			; if z = 1 then pc = label 
sleep_outer_loop:
	mov		r1, #0x3E			; r1 = 0x003E
	movt	r1, #0x03			; r1 = 0x033E
sleep_inner_loop:
	sub		r1, r1, #1			; r1 = 033E - 1 = 033D
	bne		sleep_inner_loop	; if z = 0 then pc = label (fica aqui até r1 ter o valor de 0)
	sub		r0, r0, #1			; r0 = r0 - 1
	bne		sleep_outer_loop	; if z = 0 then pc = label (fica aqui até r1 ter o valor de 0)
sleep_end:
	mov		pc, lr				; função folha

; Seccao:    data
; Descricao: Guarda as variáveis globais

rithm_arr_addr:
	.word rithm_arr

	.data

rithm_arr:
	.byte 	5, 10, 15, 20, 25, 30, 35, 40
; Seccao:    stack
; Descricao: Implementa a pilha com o tamanho definido pelo simbolo STACK_SIZE
;
	.stack
	.space	STACK_SIZE
stack_top:
