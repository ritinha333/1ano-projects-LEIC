; Ficheiro:  ap05.S
; Descricao: Programa de suporte a realizacao da 5a atividade laboratorial de
;            Arquitetura de Computadores.
; Autor:     Tiago M Dias (tiago.dias@isel.pt)
; Data:      03-05-2024

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ	CPSR_BIT_I, 0b010000          ; Mascara para o bit I do registo CPSR

	.equ	STACK_SIZE, 64                ; Dimensao do stack - 64 B

	; Definicoes do porto de entrada
	.equ	INPORT_ADDRESS, 0xFF80        ; Endereco do porto de entrada

	; Definicoes do porto de saida
	.equ	OUTPORT_ADDRESS, 0xFFC0       ; Endereco do porto de saida

	.equ	OUTPORT_INIT_VAL, 0           ; Valor inicial do porto de saida

	; Definicoes do circuito pTC
; *** Inicio de troco para completar ***
	.equ	PTC_ADDRESS,  0xFF40          ; Endereco do circuito pTC
; *** Fim de troco para completar ***

	.equ	PTC_TCR, 0                    ; Deslocamento do registo TCR do pTC
	.equ	PTC_TMR, 2                    ; Deslocamento do registo TMR do pTC
	.equ	PTC_TC,  4                    ; Deslocamento do registo TC do pTC
	.equ	PTC_TIR, 6                    ; Deslocamento do registo TIR do pTC

	.equ	PTC_CMD_START, 0              ; Comando para iniciar a contagem no pTC
	.equ	PTC_CMD_STOP, 1               ; Comando para parar a contagem no pTC

; *** Inicio de troco para completar ***
	.equ	SYSCLK_FREQ, 0x64             ; Intervalo de contagem do circuito pTC
                                          ; que suporta a implementação do sysclk
; *** Fim de troco para completar ***

	; Outras definicoes
	.equ	LED0_MASK, 1                  ; Mascara para o LED O0 da placa SDP16

; *** Inicio de troco para completar ***
	.equ	BLINK_TIME, 5                 ; ??
; *** Fim de troco para completar ***

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;
	.section startup
	b	_start
	ldr	pc, isr_addr
_start:
	ldr	sp, stack_top_addr
    mov r0, pc
    add lr, r0, #4
	ldr	pc, main_addr
    b   .

stack_top_addr:
	.word	stack_top
main_addr:
	.word	main
isr_addr:
	.word	isr

; Seccao:    text
; Descricao: Guarda o código do programa
;
	.text

; Rotina:    main
; Descricao: *** Para completar ***
; Entradas:  -
; Saidas:    -
; Efeitos:   *** Para completar ***
main:
	mov		r0, #OUTPORT_INIT_VAL
	bl		outport_init
	mov		r0, #SYSCLK_FREQ
	bl		sysclk_init
	mrs		r0, cpsr
	mov		r1, #CPSR_BIT_I
	orr		r0, r0, r1
	msr		cpsr, r0
main_loop:
	mov		r0, #LED0_MASK
	bl		outport_set_bits
	mov		r0, #BLINK_TIME
	bl		delay
	mov		r0, #LED0_MASK
	bl		outport_clear_bits
	mov		r0, #BLINK_TIME
	bl		delay
	b		main_loop

; Rotina:    delay
; Descricao: Rotina bloqueante que realiza uma espera por teste sucessivo
;            do valor da variável global sysclk. O tempo a esperar, em
;            centenas de milissegundos, e passado em R0.
;            Interface exemplo: void delay( uint16_t hms );
; Entradas:  *** Para completar ***
; Saidas:    -
; Efeitos:   -
delay:
; *** Inicio de troco para completar ***
	push	lr
	bl		sysclk_get_ticks			; Pulsos correntes
	mov		r1, #SYSCLK_FREQ			; Pulsos a atingir
	sub		r1, r1, r0
	cmp 	r1, r0
	bge		delay_l0				; sysclk > #SYSCLK_FREQ 
	mov		r0, r1
delay_l0:
	bl 		sysclk_init
	pop		pc
; *** Fim de troco para completar ***

; Rotina:    isr
; Descricao: Incrementa o valor da variável global sysclk.
; Entradas:  -
; Saidas:    -
; Efeitos:   *** Para completar ***
isr:
; *** Inicio de troco para completar ***
	push 	r0
	push 	r1
	ldr		r1, sysclk_addr
	add		r0, r1, #1
	str		r0, [r1, #0]			; Incrementa o valor da variável global sysclk
	pop		r1
	pop		r0
	movs 	pc, lr
; *** Fim de troco para completar ***

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
; *** Inicio de troco para completar ***
	push 	lr
	bl		ptc_init			; Recebe em r0 o valor do intervalo (do módulo para o TMR)
	mrs		r0, cpsr			; Caso haja algum pedido de interrupção é atendido, limpando todos os seus pedidos
	mov		r1, #CPSR_BIT_I
	orr		r0, r0, r1
	msr		cpsr, r0
	mov		r0, #0
	ldr		r1, sysclk_addr		; Inicializa a variável em memória sysclk a zero
	str		r0, [r1, #0]
	pop		pc
; *** Fim de troco para completar ***

; Rotina:    sysclk_get_ticks
; Descricao: Devolve o valor corrente da variável global sysclk.
;            Interface exemplo: uint16_t sysclk_get_ticks ( );
; Entradas:  -
; Saidas:    *** Para completar ***
; Efeitos:   -
sysclk_get_ticks:
; *** Inicio de troco para completar ***
	ldr		r0, sysclk_addr
	mov		pc, lr
; *** Fim de troco para completar ***

sysclk_addr:
	.word	sysclk
; Gestor de periférico para o porto de entrada
;

; Rotina:    inport_read
; Descricao: Adquire e devolve o valor corrente do porto de entrada.
;            Interface exemplo: uint8_t inport_read( );
; Entradas:  -
; Saidas:    R0 - valor adquirido do porto de entrada
; Efeitos:   -
inport_read:
	ldr		r1, inport_addr
	ldrb	r0, [r1, #0]
	mov		pc, lr

inport_addr:
	.word	INPORT_ADDRESS

; Gestor de periférico para o porto de saída
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
	ldr		r1, outport_img_addr
	ldrb	r2, [r1, #0]
	orr		r0, r2, r0
	strb	r0, [r1, #0]
	bl		outport_write
	pop		pc

; Rotina:    outport_clear_bits
; Descricao: Atribui o valor logico 0 aos bits do porto de saida identificados
;            com o valor 1 em R0. O valor dos outros bits nao e alterado.
;            Interface exemplo: void outport_clear_bits( uint8_t pins_mask );
; Entradas:  R0 - Mascara com a especificacao do indice dos bits a alterar.
; Saidas:    -
; Efeitos:   Altera o valor da variavel global outport_img.
outport_clear_bits:
	push	lr
	ldr		r1, outport_img_addr
	ldrb	r2, [r1, #0]
	mvn		r0, r0
	and		r0, r2, r0
	strb	r0, [r1]
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
	ldr		r1, outport_img_addr
	strb	r0, [r1]
	bl		outport_write
	pop		pc

outport_img_addr:
	.word	outport_img

; Rotina:    outport_write
; Descricao: Escreve no porto de saida o valor recebido em R0.
;            Interface exemplo: void outport_write( uint8_t value );
; Entradas:  R0 - valor a atribuir ao porto de saida.
; Saidas:    -
; Efeitos:   -
outport_write:
	ldr	r1, outport_addr
	strb	r0, [r1, #0]
	mov	pc, lr

outport_addr:
	.word	OUTPORT_ADDRESS

; Gestor de periférico para o Pico Timer/Counter (pTC)
;

; Rotina:    ptc_init
; Descricao: Faz a iniciacao do periférico pTC, habilitando o seu funcionamento
;            em modo continuo e com o intervalo de contagem recebido em R0, em
;            ticks.
;            Interface exemplo: void ptc_init( uint8_t interval );
; Entradas:  R0 - Valor do novo intervalo de contagem, em ticks.
; Saidas:    -
; Efeitos:   Inicia a contagem no periferico a partir do valor zero, limpando
;            o pedido de interrupcao eventualmente pendente.
ptc_init:
    push    lr
	ldr		r1, PTC_ADDR
	mov		r2, #PTC_CMD_STOP
	strb	r2, [r1, #PTC_TCR]
	strb	r0, [r1, #PTC_TMR]
    bl  	ptc_clr_irq
	mov		r2, #PTC_CMD_START
	strb	r2, [r1, #PTC_TCR]
	pop 	pc

; Rotina:    ptc_start
; Descricao: Habilita a contagem no periferico pTC.
;            Interface exemplo: void ptc_start( );
; Entradas:  -
; Saidas:    -
; Efeitos:   -
ptc_start:
	ldr		r0, PTC_ADDR
	mov		r1, #PTC_CMD_START
	strb	r1, [r0, #PTC_TCR]
	mov		pc, lr

; Rotina:    ptc_stop
; Descricao: Para a contagem no periferico pTC.
;            Interface exemplo: void ptc_stop( );
; Entradas:  -
; Saidas:    -
; Efeitos:   O valor do registo TC do periferico e colocado a zero.
ptc_stop:
	ldr		r0, PTC_ADDR
	mov		r1, #PTC_CMD_STOP
	strb	r1, [r0, #PTC_TCR]
	mov		pc, lr

; Rotina:    ptc_get_value
; Descricao: Devolve o valor corrente da contagem do periferico pTC.
;            Interface exemplo: uint8_t ptc_get_value( );
; Entradas:  -
; Saidas:    R0 - O valor corrente do registo TC do periferico.
; Efeitos:   -
ptc_get_value:
	ldr		r1, PTC_ADDR
	ldrb	r0, [r1, #PTC_TC]
	mov		pc, lr

; Rotina:    ptc_clr_irq
; Descricao: Sinaliza o periferico pTC que foi atendido um pedido de
;            interrupção.
;            Interface exemplo: void ptc_clr_irq( );
; Entradas:  -
; Saidas:    -
; Efeitos:   -
ptc_clr_irq:
	ldr		r0, PTC_ADDR
	strb	r1, [r0, #PTC_TIR]
	mov		pc, lr

PTC_ADDR:
	.word	PTC_ADDRESS


; Seccao:    data
; Descricao: Guarda as variáveis globais
;
	.data
outport_img:
	.space	1

	.align
sysclk:
	.space	2

; Seccao:    stack
; Descricao: Implementa a pilha com o tamanho definido pelo simbolo STACK_SIZE
;
	.stack
	.space	STACK_SIZE
stack_top:
