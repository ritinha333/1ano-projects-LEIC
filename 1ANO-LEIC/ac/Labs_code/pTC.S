

; Definicoes do porto de saida
	.equ	OUTPORT_ADDRESS, 0xFFC0       ; Endereco do porto de saida

; Definição do picoTimer
    .equ	PTC_ADDRESS,  0xFF40          ; Endereco do circuito pTC

; Offsets baseados no endereço de dados A1 A2
	.equ	PTC_TCR, 0                    ; Deslocamento do registo TCR do pTC
	.equ	PTC_TMR, 2                    ; Deslocamento do registo TMR do pTC
	.equ	PTC_TC,  4                    ; Deslocamento do registo TC do pTC
	.equ	PTC_TIR, 6                    ; Deslocamento do registo TIR do pTC

	.equ	PTC_CMD_START, 0              ; Comando para iniciar a contagem no pTC
	.equ	PTC_CMD_STOP, 1               ; Comando para parar a contagem no pTC

; Módulo de contagem
	.equ	PTC_MOD, 255                  ; Módulo de contagem do pTC

; Valor de last_read
    .equ    LAST_READ, 230                ; Exemplo de Last_read colocado pelo utilizador

; Quando a contagem começa (quando o valor corrente é maior que o valor de last_read já 
; pode começar a ser contabilizado)
    .equ    BEGIN_COUNTING, 0             ; Inicializado a 0

; Tempo passado desde last_read
    .equ    TIME, 0                       ; Constante que mantém o valor decorrido deste last_read até ao tempo corrente

; Valor a escrever no porto de saída
    .equ    WRITE_OUTPORT, 0x01           ; Escreve o valor 1 no bit de menor peso do porto de saída

; Tempo de pisca
    .equ	BLINK_TIME_INIT, 5


; Variável que atualiza o valor de blinking
    .equ	BLINK_TIME, 5

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;
	.section startup
	b	_start
	b   .
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
    bl      ptc_init                ; Inicializa o pTC
    bl      ptc_get_value           ; Obtém o valor corrente de contagem
    mov     r1, #BLINK_TIME
    sub     r1, r0, r1              ; Se for BLINK_TIME então pisca durante 0.5segundos
    cmp     r0, r1
    bne     main_blink
    mov     r0, #0
    bl      outport_write
    add     r1, r1, #BLINK_TIME 
main_blink:
    mov     r0, #WRITE_OUTPORT
    bl      outport_write
    add     r1, r1, #BLINK_TIME 


; Rotina:   elapsed
; Descrição: uma rotina para obter o tempo decorrido desde
;            o instante last_read, em ticks
;           Interface de exemplo: uint8_t elapsed ( uint8_t last_read ) 
; Entradas: R0 - O valor equivalente ao last_read
; Saídas: Tempo que decorreu
; Efeitos: *** Para completar

elapsed:
    push    lr
    push    r4
    mov		r0, #PTC_MOD
	bl		ptc_init            ; Inicializa o pTC
    ldr     r0, #LAST_READ      ; Coloca o valor de last_read escolhido para r1
    mov     r4, r0
    bl      ptc_get_value
    cmp     r0, r4
    bge     elapsed_l0          ; Caso sejam diferentes salta       
    mov     #BEGIN_COUNTING, #1
    bl      ptc_start
    b       elapsed_end         ; Caso sejam iguais em r0 mantém-se o valor do tempo decorrido
elapsed_l0:
    mov     #BEGIN_COUNTING, #0
elapsed_end:
    mov     #TIME, r0
    pop     r4
    pop     pc


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


; Rotina:    outport_write
; Descricao: Escreve no porto de saida o valor recebido em R0.
;            Interface exemplo: void outport_write( uint8_t value );
; Entradas:  R0 - valor a atribuir ao porto de saida.
; Saidas:    -
; Efeitos:   -
outport_write:
	ldr		r1, outport_addr
	strb	r0, [r1, #0]
	mov		pc, lr


outport_addr:
	.word	OUTPORT_ADDRESS

	.data

.stack
	.space	STACK_SIZE
stack_top:
