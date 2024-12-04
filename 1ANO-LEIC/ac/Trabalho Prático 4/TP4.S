
; Ficheiro:  ap05.S
; Descricao: Programa de suporte a realizacao da 5a atividade laboratorial de
;            Arquitetura de Computadores.
; Autor:     Tiago M Dias (tiago.dias@isel.pt)
; Data:      03-05-2024

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ	ENABLE_EXTINT, 0x10          ; Mascara para o bit I do registo CPSR

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
	.equ	SYSCLK_FREQ, 0x63             ; Módulo 99 - Intervalo de contagem do circuito pTC
                                          ; que suporta a implementação do sysclk
; *** Fim de troco para completar ***

	; Outras definicoes
	.equ	LED0_MASK, 1                  ; Mascara para o LED O0 da placa SDP16
    .equ	LED7_MASK, 128                  ; Mascara para o LED O7 da placa SDP16
; *** Inicio de troco para completar ***
	.equ	BLINK_TIME, 5                 ; ??
	.equ	ARRAY_MASK, 0x07
	.equ	ARRAY_POS, 0x03
    .equ    SWI7, 128

; Constantes referentes ao porto de entrada
    .equ    PEDESTRIAN_BUTTON_MASK, 0x01
    .equ    PEDESTRIAN_BUTTON_POS,  0
    .equ    CONFIG_MASK,            0x10
    .equ    CONFIG_POS,             4
    .equ    TIME_MASK,              0xE0
    .equ    TIME_POS,               5

; Estados da aplicação
    .equ    OPERATION_B_ST,            0   
    .equ    CROSSING_CARS_ST,          2
    .equ    CROSSING_PEDESTRIAN_ST,    4
    .equ    CONFIG_ST,                 8
    .equ    TIMOUT_ST,                 10

; Constantes auxiliares
    .equ    PEDESTRIAN_BUTTON_ON,   1
    .equ    PEDESTRIAN_BUTTON_OFF,  0
    .equ    CONFIG_ON,              1
    .equ    CONFIG_OFF,             0
    .equ    MODE_R_ON,              1
    .equ    MODE_R_OFF,             0
    .equ    MODE_G_ON,              1
    .equ    MODE_G_OFF,             0

; *** Fim de troco para completar ***

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;
	.section startup
	b	_start
    push 	lr
	push 	r0
	push 	r1
	ldr		r1, sysclk_addr
	ldr		r0, [r1]
	add		r0, r0, #1
	str		r0, [r1]			; Incrementa o valor da variável global sysclk
	bl  	ptc_clr_irq
	pop		r1
	pop		r0
	pop		lr
	movs 	pc, lr
	
_start:
	ldr	sp, stack_top_addr
    mov r0, pc
    add lr, r0, #4
	ldr	pc, main_addr
    b   .

    .text

main:
    push    r4                      ; Estado atual
    push    r5                      ; Imagem do inport_read
    push    r6                      ; Referência do clock
    push    r7                      ; aux
    mov     r4, #OPERATION_B_ST        ; Estado atual = OPERATION_B
    mov     r0, #SYSCLK_FREQ        ; Decidir qual o clock que vamos usar para alterar este valor
    bl      sysclk_init             ; Inicializar o clock
    mrs		r0, cpsr
	mov		r1, #ENABLE_EXTINT
	orr		r0, r0, r1
	msr		cpsr, r0
main_loop:
    bl      case_operation_b        ; Arranque do sistema => case_operation_b
    bl      inport_read             ; Ler o porto de leitura
    mov     r5, R0                  ; r5 = imagem do porto de entrada
    add     pc, r4, pc              ; Incrementar o program counter com o valor de acordo o branch a ser efetuado
main_branch_table:
    b       case_crossing_cars
    b       case_crossing_pedestrians
    b       case_config
    b       case_timeout
case_crossing_cars:
; Ligar os LEDS L1 a verde e L2 a vermelho 
    mov     r1, r5                          ; Preservar valores
    mov     r0, r5                          ; Preservar valores
    bl      get_config                      ; Buscar o valor do config de acordo a imagem feita do porto
    mov     r2, #CONFIG_ON                  ; Carregar o registo 2 com a constante #CONFIG_ON
    cmp     r0, r2                          ; if #CONFIG_ON (1) != Valor do config SW (0) logo config = false
    beq     case_crossing_cars_b0           ; Caso seja falso tem de se testar o botão
    mov     r7, r4
    mov     r4, #CONFIG_ST                  ; Caso contrário o estado altera-se para #CONFIG_ST
    b       main_loop                       ; Voltar ao loop da main
case_crossing_cars_b0:
    mov     r5, r1                          ; Preservar valores
    mov     r0, r5                          ; Preservar valores
    bl      get_pedestrian_button           ; Buscar o valor do botão de acordo a imagem feita do porto
    mov     r2, #PEDESTRIAN_BUTTON_ON       ; Carregar o registo 2 com a constante #PEDESTRIAN_BUTTON_ON
    cmp     r0, r2                          ; if #PEDESTRIAN_BUTTON_ON (1) != Valor do botão SW (1) 
    bne     case_crossing_cars              ; Volta a repetir o estado 
    mov     r4, #CROSSING_PEDESTRIAN_ST     ; Alterar para o próximo estado
    b       main_loop                       ; Voltar ao loop da main
case_crossing_pedestrians:
; Ligar os LEDS L1 a vermelho e L2 a verde
    mov     r1, r5                          ; Preservar valores
    mov     r0, r5                          ; Preservar valores
    bl      get_config                      ; Buscar o valor do config de acordo a imagem feita do porto
    mov     r2, #CONFIG_ON                  ; Carregar o registo 2 com a constante #CONFIG_ON
    cmp     r0, r2                          ; if #CONFIG_ON (1) != Valor do config SW (0) logo config = false
    beq     case_crossing_pedestrians_b0    ; Caso seja falso tem de se testar o botão
    mov     r7, r4
    mov     r4, #CONFIG_ST                  ; Caso contrário o estado altera-se para #CONFIG_ST
    b       main_loop                       ; Voltar ao loop da main
case_crossing_pedestrians_b0:
    mov     r5, r1                          ; Preservar valores
    mov     r0, r5                          ; Preservar valores
    bl      get_pedestrian_button           ; Buscar o valor do botão de acordo a imagem feita do porto
    bl      detect_raising_edge             ; Vai detetar uma transição 
    mov     r2, #PEDESTRIAN_BUTTON_ON       ; Carregar o registo 2 com a constante #PEDESTRIAN_BUTTON_ON
    cmp     r0, r2                          ; if #PEDESTRIAN_BUTTON_ON (1) == Valor do botão SW (1)
    beq     case_crossing_pedestrians       ; Volta a repetir o estado 
    mov     r4, #CROSSING_CARS_ST           ; Alterar para o próximo estado
    b       main_loop                       ; Voltar ao loop da main
case_config:
; Ligar LED's L1 a amarelo blinking, L2 a verde blinking, L3 a amarelo permanentemente
    bl      get_config
    mov     r1 ,#CONFIG_ON
    cmp     r0, r1
    beq     case_config          ; if CONFIG_ON (1) == config (1) config = true
    mov     r4, r7
    b       main_loop
case_timeout:
    b       main_loop

/*
uint8_t b_last;
uint8_t detect_falling_edge(uint8_t b_now) {
	uint8_t falling_edge = b_last == 0 && b_now == 1;
	b_last = b_now;
	return falling_edge;
}
*/
detect_raising_edge:
	mov		r1, r0
	mov		r0, #1						; falling_edge = TRUE
	ldr		r2, button_state_addr
	bzc		detect_raising_edge_l0	    ; b_now == 0
	ldrb	r3, [r2]					; R3 = domain_last
	and		r3, r3, r3
	bzs		detect_raising_edge_l0	; b_last == 1
	mov		r0, #0						; falling_edge = FALSE
detect_raising_edge_l0:
	strb	r1, [r2]					; b_last = b_now
	mov		pc, lr						; return falling_edge


;void case_operation_b()
case_operation_b:
    ; Colocar L1 a amarelo de acordo BLINK_TIME
    ; Colocar L2 a vermelho de acordo BLINK_TIME
    ; Colocar L3 a amarelo permanente
    mov     r1, r5                          ; Preservar valores
    mov     r0, r5                          ; Preservar valores
    bl      get_config                      ; Buscar o valor do config de acordo a imagem feita do porto
    mov     r2, #CONFIG_ON                  ; Carregar o registo 2 com a constante #CONFIG_ON
    cmp     r0, r2                          ; if #CONFIG_ON (1) != Valor do config SW (0) logo config = false
    beq     case_operation_b0               ; Caso seja falso tem de se testar o botão
    mov     r4, #CONFIG_ST                  ; Caso contrário o estado altera-se para #CONFIG_ST
    b       main_loop                       ; Voltar ao loop da main
case_operation_b0:
    mov     r5, r1                          ; Preservar valores
    mov     r0, r5                          ; Preservar valores
    bl      get_pedestrian_button           ; Buscar o valor do botão de acordo a imagem feita do porto
    mov     r2, #PEDESTRIAN_BUTTON_ON       ; Carregar o registo 2 com a constante #PEDESTRIAN_BUTTON_ON
    cmp     r0, r2                          ; if #PEDESTRIAN_BUTTON_ON (1) != Valor do botão SW (0) logo button = false
    beq     case_operation_b              ; Volta a repetir o estado 
    ;ldr     r1, button_state_addr           ; Buscar o endereço do botão em memória
    ;ldr     r1, [r1]                        ; Valor de botão 
    ;str     r2, [r1]                        ; Alterar o estado do botão para ON
    mov     r4, #CROSSING_CARS_ST           ; Alterar para o próximo estado
    b       main_loop                       ; Voltar ao loop da main

;-----------------------------------------------------

; Camada aplicacional

;-----------------------------------------------------

; uint8_t get_pedestrian_button(uint8_t inport_val);
get_pedestrian_button:
    mov     r1, #PEDESTRIAN_BUTTON_MASK
    and     r0, r0, r1
    lsr     r0, r0, #PEDESTRIAN_BUTTON_POS
    mov     pc, lr

; uint8_t get_config(uint8_t inport_val);
get_config:
    mov     r1, #CONFIG_MASK
    and     r0, r0, r1
    lsr     r0, r0, #CONFIG_POS
    mov     pc, lr

; uint8_t get_time(uint8_t inport_val);
get_time:
    mov     r1, #TIME_MASK
    and     r0, r0, r1
    lsr     r0, r0, #TIME_POS
    mov     pc, lr

;--------------------------------------------------------------------

; Rotinas referentes ao Pico-Timer

sysclk_init:
	push 	lr
	bl		ptc_init			; Recebe em r0 o valor do intervalo (do módulo para o TMR) e inicia o pTC
	mov		r0, #0
	ldr		r1, sysclk_addr		; Inicializa a variável em memória sysclk a zero
	str		r0, [r1, #0]
	pop		pc

sysclk_get_ticks:
	ldr		r0, sysclk_addr
	ldr		r0, [r0]
	mov		pc, lr

sysclk_addr:
	.word	sysclk

ptc_init:
    push    lr
	ldr		r1, ptc_addr
	mov		r2, #PTC_CMD_STOP
	strb	r2, [r1, #PTC_TCR]
	strb	r0, [r1, #PTC_TMR]
    bl  	ptc_clr_irq
	mov		r2, #PTC_CMD_START
	strb	r2, [r1, #PTC_TCR]
	pop 	pc

ptc_start:
	ldr		r0, ptc_addr
	mov		r1, #PTC_CMD_START
	strb	r1, [r0, #PTC_TCR]
	mov		pc, lr

ptc_stop:
	ldr		r0, ptc_addr
	mov		r1, #PTC_CMD_STOP
	strb	r1, [r0, #PTC_TCR]
	mov		pc, lr

ptc_get_value:
	ldr		r1, ptc_addr
	ldrb	r0, [r1, #PTC_TC]
	mov		pc, lr

ptc_clr_irq:
	ldr		r0, ptc_addr
	strb	r1, [r0, #PTC_TIR]
	mov		pc, lr

ptc_addr:
	.word	PTC_ADDRESS

button_state_addr:
    .word   button_state

crossing_times_addr:
    .word   crossing_times

	.data

button_state:
    .space 1
    .align

sysclk:
	.space	2

crossing_times:
    .word       100, 150, 200, 250, 300

	.equ STACK_SIZE, 64
	.section .stack
	.space	STACK_SIZE
stack_top:
