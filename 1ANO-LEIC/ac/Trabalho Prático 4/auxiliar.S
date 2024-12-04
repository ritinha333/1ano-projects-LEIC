

/*

fun caseConfig(){
	turnL1yeallow()	
	turnL2green()
	turnL3yellow()
	if(config == '0') case_crossing_cars
	else{
		val timeout = timeout
		if(timeout == '0') case_config
		else{
			evaluate_state_config()
			getTimeref
			if(state == '1') {
				clrBitsL1AndL2
				getTimeref
				case_config
				}
			else {
				setBitsL1AndL2
				getTimeref
				case_config
				}
		}
	}
}
*/


/*
fun casePedestrians(){
	turn_cars_red_on()
	turn_pedestrians_green_on()
	if(config == '1') case_config
	else {
		val timeout = timeou_blink()
		if(timeout == '1') case_crossing_cars
		else {
			if(button == '0'){
				take_timeref 
				case_pedestrians
			} 
			else case_pedestrians
		}
	}
}
*/

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
	.equ	TIMEOUT, 	5
	.equ	ARRAY_MASK, 0x07
	.equ	ARRAY_POS, 0x03
    .equ    SWI7, 128


; Constantes referentes ao porto de entrada e saída
    .equ    PEDESTRIAN_BUTTON_MASK, 0x01
    .equ    PEDESTRIAN_BUTTON_POS,  0
    .equ    CONFIG_MASK,            0x10
    .equ    CONFIG_POS,             4
    .equ    TIME_MASK,              0xE0
    .equ    TIME_POS,               5
    .equ    TRAFFIC_LIGHT_R_MASK,   0x01
    .equ    TRAFFIC_LIGHT_G_MASK,   0x02
	.equ	PEDESTRIAN_LIGHT_R_MASK, 0x04
	.equ 	PEDESTRIAN_LIGHT_G_MASK, 0x08
	.equ 	MODE_R_MASK,			 0x10
	.equ 	MODE_G_MASK,			 0x20


; Estados da aplicação
    .equ    CROSSING_CARS_ST,          0
    .equ    CROSSING_PEDESTRIAN_ST,    2
    .equ    CONFIG_ST,                 4

; Constantes auxiliares
	.equ 	ZERO,						0
	.equ 	ONE,						1



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
	.word stack_top
main_addr:
	.word	main
isr_addr:
	.word	isr

    .text

	
main:
    push    r4                      ; Estado atual
    push    r5                      ; Imagem do inport_read
    push    r6                      ; Referência do clock
    push    r7                      ; aux
    mov     r4, #CROSSING_CARS_ST   ; Estado atual = CROSSING_CARS_ST
    mov     r0, #SYSCLK_FREQ        ; Decidir qual o clock que vamos usar para alterar este valor
    bl      sysclk_init             ; Inicializar o clock
    mrs		r0, cpsr
	mov		r1, #ENABLE_EXTINT
	orr		r0, r0, r1
	msr		cpsr, r0
main_loop:
	ldr		r1, state_time_addr
	ldr		r1, [r1]				; Iniciar a variável state para 0
	mov		r2, #ZERO
	str		r2, [r1]				; Colocar o state a zero inicialmente
	;referência do tempo
	bl 		sysclk_get_ticks					
	mov 	r6, r0					;Referência do tempo atual
    bl      inport_read             ; Ler o porto de leitura
    mov     r5, R0                  ; r5 = imagem do porto de entrada
    bl      case_crossing_cars      ; Arranque do sistema => case_crossing_cars
    add     pc, r4, pc              ; Incrementar o program counter com o valor de acordo o branch a ser efetuado
main_branch_table:
    b       case_crossing_cars
    b       case_crossing_pedestrians
    b       case_config

state_time_addr:
	.word 	state_time

case_crossing_cars:
	bl 		turn_cars_green_on					; L1 a verde
	bl		turn_pedestrians_red_on				; L2 a vermelho
	bl 		turn_mode_yellow_on					; L3 a amarelo
	;mov		r1, #CONFIG_MASK					
	;and		r0, r5, r1							; De acordo a imagem do porto de entrada vê a config
	mov		r0, r5
	bl 		get_config							; De acordo a imagem do porto de entrada vê a config
	mov 	r1, #ZERO							; r1 = 0
	cmp 	r0, r1								; r0 - r1
	bne		case_crossing_cars_l0				; se r0 != r1 -> vai para estado config, caso contrário vai continuar testando o button
	;mov		r1, #PEDESTRIAN_BUTTON_MASK			
	;and		r0, r5, r1							; De acordo a imagem do porto de entrada vê a button 
	mov		r0, r5
	bl 		get_pedestrian_button
	bl		detect_raising_edge					; de acordo com o valor now ele verifica se houve uma transição ascedente retornando true
	mov		r1, #ONE
	cmp		r1, r0								; r1(1) - r0 (1 ou 0)
	bzs 	case_crossing_cars_l1				;se houve raising_edge ele passa para o estado seguinte (r0 -> true == ONE) muda de estado
	mov		r0, r6								; r0 = referência do tempo
	mov 	r1, #BLINK_TIME						; r1 = #BLINK_TIME
	bl 		timeout_blink						; testar timeout_blink
	ldr		r1, state_time_addr1
	ldr		r1, [r1]							; variável state referente ao tempo
	bl 		evaluate_state_cars					; avalia o state do tempo baseado no timeout
	bl 		sysclk_get_ticks					; Tirar nova referência de tempo
	mov 	r6, r0								; Referência do tempo atual
	b 		case_crossing_cars					; continua neste caso até que config a '0' e button a '1' ou config a '1'
case_crossing_cars_l0:
	mov		r4, #CONFIG_ST
	b		main_loop
case_crossing_cars_l1:
	mov 	r4, #CROSSING_PEDESTRIAN_ST
	b		main_loop
case_crossing_pedestrians:
	bl		turn_cars_red_on						; L1 a vermelho
	bl		turn_pedestrians_green_on				; L2 a verde
	;mov		r1, #CONFIG_MASK						; r1 = #CONFIG_MASK
	;and		r0, r5, r1								; De acordo com a imagem do porto de entrada vê a config
	mov 	r0, r5
	bl 		get_config
	mov 	r1, #ONE								; r1 = 1
	cmp 	r0, r1									; r0 - r1, se for 0 significa que r0 = r1 = 1 
	bzc		case_crossing_pedestrians_l0			; se for false testa times
	;mov		r1, #TIME_MASK							; r1 = #TIME_MASK
	;and		r1, r5, r1								; De acordo com a imagem do porto de entrada vê crossing_times
	;lsr		r1, r1, #TIME_POS						; Coloca nos bits de menor peso
	mov		r0, r5
	bl 		get_time
	ldr		r1, crossing_times_addr					; Carrega o endereço de crossing_times disponíveis para o led dos peões
	ldrb	r1, [r1, r0]							; Indexa o array de crossing times de acordo o valor presente dos 3 bits de maior peso do porto de entrada
	mov		r0, r6									; timeref
	bl		timeout									; verifica timeout da luz dos peões
	mov		r1, #ONE								; r1 = 1
	cmp 	r0, r1									; timeout - 1
	bzc		case_crossing_pedestrians_l1			; if timeout - 1 for false testa button
	;mov		r1, #PEDESTRIAN_BUTTON_MASK			
	;and		r0, r5, r1								; De acordo a imagem do porto de entrada vê a button 
	mov 	r0, r5
	bl 		get_pedestrian_button
	mov		r1, #ZERO								; r1 = #ZERO 
	cmp 	r0, r1									; r0 - r1 
	bzc		case_crossing_pedestrians				; if button - 0 for false tirar ref do tempo e saltar para o estado case_crossing_pedestrians
	bl 		sysclk_get_ticks						; take_timeref
	mov 	r6, r0									; Referência do tempo atual
	b		case_crossing_pedestrians
case_crossing_pedestrians_l0:
	mov		r4, #CONFIG_ST
	b		main_loop
case_crossing_pedestrians_l1:
	mov 	r4, #CROSSING_CARS_ST
	b		main_loop
case_config:
	bl 		turn_cars_yellow_on
	bl 		turn_pedestrians_green_on
	bl		turn_mode_yellow_on
	mov		r1, #CONFIG_MASK						; r1 = #CONFIG_MASK
	and		r0, r5, r1								; De acordo com a imagem do porto de entrada vê a config
	mov 	r1, #ZERO								; r1 = 0
	cmp 	r0, r1									; r0 - r1, se for 1 significa que r0 = r1 = 1 
	bzc		case_config_l0							; se for false, testa timeout
	mov		r0, r6									; Colocar a referência do tempo em r0
	mov		r1, #BLINK_TIME							; Colocar em r1 o valor que quero passar ao timeout
	bl 		timeout									; Avalia se houve timeout
	mov 	r1, #ZERO								; r1 = 0
	cmp 	r0, r1									; r0 - r1
	bzc		case_config								; se for false, testa state			
	ldr		r1, state_time_addr1						; Carrega o endereço de state_time
	ldr		r1, [r1]								; variável state referente ao tempo
	bl 		evaluate_state_config							; avalia o state do tempo baseado no timeout
	bl 		sysclk_get_ticks						; Tirar nova referência de tempo
	mov 	r6, r0									; Referência do tempo atual
	b 		case_config
case_config_l0:
	mov 	r4, #CROSSING_CARS_ST
	b 		main_loop

state_time_addr1:
	.word 	state_time
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

isr:
	push 	r0
	push 	r1
	ldr		r1, sysclk_addr
	ldr		r0, [r1]
	add		r0, r0, #1
	str		r0, [r1]			; Incrementa o valor da variável global sysclk
	ldr		r0, ptc_addr
	mov		r1, #PTC_CMD_STOP
	strb	r0, [r1, #PTC_TIR]	
	pop		r1
	pop		r0
	movs 	pc, lr	

sysclk_addr:
	.word	sysclk

crossing_times_addr:
    .word   crossing_times

led_state_addr:
    .word   led_state

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

/*
uint8_t b_last;
uint8_t detect_raising_edge(uint8_t b_now) : boolean {
	uint8_t raising_edge = b_last == 0 && b_now == 1;
	b_last = b_now;
	return raising_edge;
}
*/
detect_raising_edge:
	mov		r1, r0						; b_now
	mov		r0, #0						; r0 = 0 raising_edge = FALSE
	ldr		r2, button_state_addr
	ldr		r2, [r2]					; b_last
	cmp		r2, r0						; b_last - 0
	bzs		detect_raising_edge_l0	    ; b_last == 0 
	mov		r0, #1						; raising_edge = true
	cmp 	r1, r0						; b_now - 0
	bzc		detect_raising_edge_l0		; b_now != 0
detect_raising_edge_l0:
	str 	r1, [r2]
	mov		pc, lr						; return raising_edge


button_state_addr:
    .word   button_state

	
/* fun timeout(timeRef, timeToCompare):{
	val presentTime = sysclk_get_ticks()
	val sub = presentTime - timeRef
	var timeout = false

	if((timeToCompare - sub) >= timeToCompare) timeout = true
	else timeout = false

	return timeout
}*/

; r0= timeRef, r1= timeToCompare

timeout:
	push 	lr
	push 	r4
	mov		r2, r0					; timeref
	bl 		sysclk_get_ticks		; Tempo atual em ticks
	mov		r4, r0					; presentTime 
	sub 	r0, r4, r2				; sub
	sub		r3, r1, r0				; timeToCompare - sub
	mov		r0, #0					; timeout = false
	cmp 	r1, r3					; timeToCompare - (timeToCompare - sub)
	blo		timeout_l0				; caso seja menor salta
	mov		r0, #1					; timeout = true
timeout_l0:
	pop 	r4
	pop		pc

/*
fun evaluateStateTime(timeout: Boolean, stateActual: Boolean).{
	if(timout == true(1)){
		if(stateActual == true){
			outportSetBits (of L1 to green and L2 to red)
		}
		else outportClrBits (of L1 to nothing and L2 to nothing)
	}

}
*/

; r0 = timeout, r1 = stateAtual
evaluate_state_cars:
	push 	lr
	mov 	r2, #ONE
	cmp 	r0, r2							; timeout - 1
	bzs		evaluate_state_cars_l0				; flag z a zero salta, caso contrário continua
	cmp 	r1, r2							; state_time - 1
	bzs		evaluate_state_cars_l1				; flag z a zero salta, caso contrário continua
	bl		turn_cars_green_on				; L1 a verde
	bl		turn_pedestrians_red_on			; L2 a vermelho
evaluate_state_cars_l1:
	bl		turn_cars_off
	bl		turn_pedestrians_off
evaluate_state_cars_l0:
	pop 	pc

; r0 = timeout, r1 = stateAtual
evaluate_state_config:
	push 	lr
	mov 	r2, #ONE
	cmp 	r0, r2							; timeout - 1
	bzs		evaluate_state_config_l0		; flag z a zero salta, caso contrário continua
	cmp 	r1, r2							; state_time - 1
	bzs		evaluate_state_config_l1		; flag z a zero salta, caso contrário continua
	bl		turn_cars_yellow_on
	bl		turn_pedestrians_green_on
evaluate_state_config_l1:
	bl		turn_cars_off
	bl		turn_pedestrians_off
evaluate_state_config_l0:
	pop 	pc


turn_cars_red_on:
	push 	lr
	mov 	r0, #TRAFFIC_LIGHT_G_MASK
	bl		outport_clear_bits
	mov		r0, #TRAFFIC_LIGHT_R_MASK
	bl		outport_set_bits
	pop 	pc

turn_pedestrians_red_on:
	push	lr
	mov 	r0, #PEDESTRIAN_LIGHT_G_MASK
	bl		outport_clear_bits
	mov		r0, #PEDESTRIAN_LIGHT_R_MASK
	bl		outport_set_bits
	pop		pc

turn_mode_yellow_on:
	push 	lr
	mov 	r0, #MODE_G_MASK
	bl		outport_set_bits
	mov		r0, #MODE_R_MASK
	bl		outport_set_bits
	pop 	pc

turn_cars_green_on:
	push 	lr
	mov 	r0, #TRAFFIC_LIGHT_G_MASK
	bl		outport_set_bits
	mov		r0, #TRAFFIC_LIGHT_R_MASK
	bl		outport_clear_bits
	pop 	pc

turn_pedestrians_green_on:
	push	lr
	mov 	r0, #PEDESTRIAN_LIGHT_G_MASK
	bl		outport_set_bits
	mov		r0, #PEDESTRIAN_LIGHT_R_MASK
	bl		outport_clear_bits
	pop		pc

turn_cars_off:
	push	lr
	mov 	r0, #TRAFFIC_LIGHT_G_MASK
	bl 		outport_clear_bits
	mov 	r0, #TRAFFIC_LIGHT_R_MASK
	bl 		outport_clear_bits
	pop 	pc

turn_pedestrians_off:
	push 	lr
	mov		r0, #PEDESTRIAN_LIGHT_G_MASK
	bl 		outport_clear_bits
	mov		r0, #PEDESTRIAN_LIGHT_R_MASK
	bl 		outport_clear_bits
	pop		pc

turn_cars_yellow_on:
	push 	lr
	mov		r0, #TRAFFIC_LIGHT_G_MASK
	bl 		outport_set_bits
	mov		r0, #TRAFFIC_LIGHT_R_MASK
	bl 		outport_set_bits
	pop		pc

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

/*

/* fun timeout(timeRef):{
	val presentTime = sysclk_get_ticks()
	val sub = presentTime - timeRef
	var timeout = false

	if((#BLINK_TIME - sub) >= #BLINK_TIME) timeout = true
	else timeout = false

	return timeout
}*/

timeout_blink:
	push 	lr
	push	r4
	mov		r1, r0					; timeRef
	bl 		sysclk_get_ticks		; Tempo atual em ticks
	mov		r4, r0					; presentTime 
	sub 	r0, r4, r1				; sub
	mov		r2, #BLINK_TIME			; Tempo a atingir
	sub 	r1, r2, r0				; (#BLINK_TIME - sub) 
	mov		r0, #0					; timeout = false
	cmp 	r1, r2					; (#BLINK_TIME - sub) >= #BLINK_TIME
	blo		timeout_blink_end		; if((#BLINK_TIME - sub) >= #BLINK_TIME) for false não houve timeout = 0
	mov		r0, #1					; Caso contrário timeout = true
timeout_blink_end:
	pop		r4
	pop		pc



	.data

button_state:
    .space 1

led_state:
    .space 1

sysclk:
	.space	2

outport_img:
	.space	1
	.align
crossing_times:
    .word       100, 150, 200, 250, 300

state_time:
	.space 1

	.section .stack
	.space	STACK_SIZE
stack_top:



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
	.equ	TIMEOUT, 	5
	.equ	ARRAY_MASK, 0x07
	.equ	ARRAY_POS, 0x03
    .equ    SWI7, 128


; Constantes referentes ao porto de entrada e saída
    .equ    PEDESTRIAN_BUTTON_MASK, 0x01
    .equ    PEDESTRIAN_BUTTON_POS,  0
    .equ    CONFIG_MASK,            0x10
    .equ    CONFIG_POS,             4
    .equ    TIME_MASK,              0xE0
    .equ    TIME_POS,               5
    .equ    TRAFFIC_LIGHT_R_MASK,   0x01
    .equ    TRAFFIC_LIGHT_G_MASK,   0x02
	.equ	PEDESTRIAN_LIGHT_R_MASK, 0x04
	.equ 	PEDESTRIAN_LIGHT_G_MASK, 0x08
	.equ 	MODE_R_MASK,			 0x10
	.equ 	MODE_G_MASK,			 0x20


; Estados da aplicação
    .equ    CROSSING_CARS_ST,          0
    .equ    CROSSING_PEDESTRIAN_ST,    2
    .equ    CONFIG_ST,                 4

; Constantes auxiliares
	.equ 	ZERO,						0
	.equ 	ONE,						1



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
	.word stack_top
main_addr:
	.word	main
isr_addr:
	.word	isr

    .text

	
main:
    push    r4                      ; Estado atual
    push    r5                      ; Imagem do inport_read
    push    r6                      ; Referência do clock
	push 	r7						; carOrConfig
    mov     r4, #CROSSING_CARS_ST   ; Estado atual = CROSSING_CARS_ST
    mov     r0, #SYSCLK_FREQ        ; Decidir qual o clock que vamos usar para alterar este valor
    bl      sysclk_init             ; Inicializar o clock
    mrs		r0, cpsr
	mov		r1, #ENABLE_EXTINT
	orr		r0, r0, r1
	msr		cpsr, r0
main_loop:
	ldr		r1, state_addr						; Carregar endereço da variável state_time
	ldr		r1, [r1]							; Iniciar a variável state para 0
	mov		r2, #ZERO							; r2 = 0
	str		r2, [r1]							; Colocar o state a zero inicialmente
	mov		r2, #ONE							; r2 = 1
	ldr		r1, startup_LEDs_addr				; Carregar endereço da variável startup_LEDs
	ldr		r1, [r1]							; Obter valor da variável com o endereço de startup_LEDs_addr
	str		r2, [r1]							; Colocar variável startup_LEDs a 1	
	bl 		sysclk_get_ticks								
	mov 	r6, r0								; Referência do tempo atual
    bl      inport_read             			; Ler o porto de leitura
    mov     r5, R0                  			; r5 = imagem do porto de entrada
    add     pc, r4, pc              			; Incrementar o program counter com o valor de acordo o branch a ser efetuado
main_branch_table:
    b       case_crossing_cars
    b       case_crossing_pedestrians
    b       case_config

state_addr:
	.word 	state
startup_LEDs_addr:
	.word 	startup_LEDs

case_crossing_cars:
	;ldr		r0, state_addr1
	;ldr		r0, [r0]
	;ldr 	r1, carsOrConfig
	;ldr		r1, [r1]
	;bl		turn_LEDs_ON_or_OFF
	;mov		r0, r1								; r0 = startup_LEDs
	;bl		startup_LEDs_Crossing_Cars			; Colocar os LED's inicialmente com a cor desejada
	mov		r1, #ZERO							; r1 = 0
	str		r1, [r0]							; startup_LEDs = 0
	mov		r0, r5
	bl 		get_config							; De acordo a imagem do porto de entrada vê a config
	mov 	r1, #ZERO							; r1 = 0
	cmp 	r0, r1								; r0 - r1
	bzc		case_crossing_cars_l0				; se r0 != r1 -> vai para estado config, caso contrário vai continuar testando o button
	mov		r0, r5
	bl 		get_pedestrian_button
	bl		detect_raising_edge					; de acordo com o valor now ele verifica se houve uma transição ascedente retornando true
	mov		r1, #ONE
	cmp		r1, r0								; r1(1) - r0 (1 ou 0)
	bzs 	case_crossing_cars_l1				;se houve raising_edge ele passa para o estado seguinte (r0 -> true == ONE) muda de estado
	mov		r0, r6								; r0 = referência do tempo
	mov 	r1, #BLINK_TIME						; r1 = #BLINK_TIME
	bl 		timeout								; testar timeout_blink
	ldr		r1, state_addr1
	ldr		r1, [r1]							; variável state referente ao tempo
	bl 		evaluate_state_cars					; avalia o state do tempo baseado no timeout
	bl 		sysclk_get_ticks					; Tirar nova referência de tempo
	mov 	r6, r0								; Referência do tempo atual
	b 		case_crossing_cars					; continua neste caso até que config a '0' e button a '1' ou config a '1'
case_crossing_cars_l0:
	mov		r4, #CONFIG_ST
	b		main_loop
case_crossing_cars_l1:
	mov 	r4, #CROSSING_PEDESTRIAN_ST
	b		main_loop
case_crossing_pedestrians:
	bl		turn_cars_red_on					; L1 a vermelho
	bl		turn_pedestrians_green_on			; L2 a verde
	mov 	r0, r5
	bl 		get_config
	mov 	r1, #ONE							; r1 = 1
	cmp 	r0, r1								; r0 - r1, se for 0 significa que r0 = r1 = 1 
	bzs		case_crossing_pedestrians_l0		; se for false testa times
	mov		r0, r5
	bl 		get_time
	ldr		r1, crossing_times_addr				; Carrega o endereço de crossing_times disponíveis para o led dos peões
	ldrb	r1, [r1, r0]						; Indexa o array de crossing times de acordo o valor presente dos 3 bits de maior peso do porto de entrada
	mov		r0, r6								; timeref
	bl		timeout								; verifica timeout da luz dos peões
	mov		r1, #ONE							; r1 = 1
	cmp 	r0, r1								; timeout - 1
	bzs		case_crossing_pedestrians_l1		; if timeout - 1 for false testa button
	mov 	r0, r5
	bl 		get_pedestrian_button
	mov		r1, #ZERO							; r1 = #ZERO 
	cmp 	r0, r1								; r0 - r1 
	bzs		case_crossing_pedestrians			; if button - 0 for false tirar ref do tempo e saltar para o estado case_crossing_pedestrians
	bl 		sysclk_get_ticks					; take_timeref
	mov 	r6, r0								; Referência do tempo atual
	b		case_crossing_pedestrians
case_crossing_pedestrians_l0:
	mov		r4, #CONFIG_ST
	b		main_loop
case_crossing_pedestrians_l1:
	mov 	r4, #CROSSING_CARS_ST
	b		main_loop
case_config:
	mov		r0, r1								; r0 = startup_LEDs
	;bl		startup_LEDs_Config					; Colocar os LED's inicialmente com a cor desejada
	mov		r1, #ZERO							; r1 = 0
	str		r1, [r0]							; startup_LEDs = 0
	bl		turn_mode_yellow_on
	;mov		r1, #CONFIG_MASK					; r1 = #CONFIG_MASK
	;and		r0, r5, r1							; De acordo com a imagem do porto de entrada vê a config
	bl 		get_config
	mov 	r1, #ZERO							; r1 = 0
	cmp 	r0, r1								; r0 - r1, se for 1 significa que r0 = r1 = 1 
	bzs		case_config_l0						; se for false, testa timeout
	mov		r0, r6								; Colocar a referência do tempo em r0
	mov		r1, #BLINK_TIME						; Colocar em r1 o valor que quero passar ao timeout
	bl 		timeout								; Avalia se houve timeout
	mov 	r1, #ZERO							; r1 = 0
	cmp 	r0, r1								; r0 - r1
	bzc		case_config							; se for false, testa state			
	ldr		r1, state_addr1						; Carrega o endereço de state_time
	ldr		r1, [r1]							; variável state referente ao tempo
	bl 		evaluate_state_config				; avalia o state do tempo baseado no timeout
	bl 		sysclk_get_ticks					; Tirar nova referência de tempo
	mov 	r6, r0								; Referência do tempo atual
	b 		case_config
case_config_l0:
	mov 	r4, #CROSSING_CARS_ST
	b 		main_loop

state_addr1:
	.word 	state
carsOrConfig_addr:
	.word 	carsOrConfig
crossing_times_addr:
    .word   crossing_times


/*
fun turnTheLEDSOnOrOff(stateAtual: Boolean, carsOrConfig: Boolean){
	if(carsOrConfig = '0'){
		if(stateAtual == '1') startup_LEDs_ON_Crossing_Cars
		else startup_LEDs_OFF_Crossing_Cars
	}
	else if(stateAtual == '1') startup_LEDs_ON_Config
		else startup_LEDs_OFF_Config

}
*/
turn_LEDs_ON_or_OFF:
	push 	lr
	push 	r4									; stateAtual
	push	r5									; carsOrConfig
	mov		r4, r0
	mov 	r5, r1 
	mov		r1, #ZERO
	cmp 	r5, r1								; carsOrConfig - 0 = 0; z = 1 logo state_cars_evaluate
	bzs		turn_LEDs_ON_or_OFF_l0
	mov 	r1, #ONE
	cmp 	r4, r1								; stateAtual - 1 = 0; z = 1 logo 
	bzs 	turn_LEDs_ON_or_OFF_l2
	bl		startup_LEDs_OFF_Config
	b 		turn_LEDs_ON_or_OFF_end
turn_LEDs_ON_or_OFF_l0:
	mov 	r1, #ONE
	cmp 	r4, r1								; stateAtual - 1 = 0; z = 1 logo 
	bzs		turn_LEDs_ON_or_OFF_l1
	bl 		startup_LEDs_OFF_Crossing_Cars
	b 		turn_LEDs_ON_or_OFF_end
turn_LEDs_ON_or_OFF_l1:
	bl 		startup_LEDs_ON_Crossing_Cars
	b 		turn_LEDs_ON_or_OFF_end
turn_LEDs_ON_or_OFF_l2:
	bl 		startup_LEDs_ON_Config	
turn_LEDs_ON_or_OFF_end:
	pop 	r5
	pop		r4
	pop		pc

/*
uint8_t b_last;
uint8_t detect_raising_edge(uint8_t b_now) : boolean {
	uint8_t raising_edge = b_last == 0 && b_now == 1;
	if(raising_edge == true){
		b_last = b_now;
	return raising_edge;
	}
	else {
		b_last = b_now;
	return raising_edge;
	}
	
}
*/

detect_raising_edge:
	mov		r1, r0								; b_now
	mov		r0, #0								; r0 = 0 
	ldr		r2, button_state_addr				
	ldr		r2, [r2]							; b_last
	cmp		r2, r0								; b_last - 0
	bzc		detect_raising_edge_l0	    		; b_last == 0 
	mov		r0, #1								; r0 = 1
	cmp 	r1, r0								; b_now - 0
	bzc		detect_raising_edge_l1				; b_now != 0
detect_raising_edge_l0:
	str 	r1, [r2]
	mov		pc, lr								; return raising_edge
detect_raising_edge_l1:
	mov		r0, #0								; r0 = 0 
	mov		pc, lr								; return raising_edge

button_state_addr:
    .word   button_state

	
startup_LEDs_ON_Crossing_Cars:
	push 	lr
	bl 		turn_cars_green_on					; L1 a verde
	bl		turn_pedestrians_red_on				; L2 a vermelho
	bl 		turn_mode_yellow_on					; L3 a amarelo
	pop 	pc

startup_LEDs_ON_Config:
	push 	lr
	bl 		turn_cars_yellow_on					; L1 a amarelo
	bl 		turn_pedestrians_green_on			; L2 a verde
	pop 	pc

startup_LEDs_OFF_Config:
	push 	lr
	bl 		turn_cars_off					; L1 a amarelo
	bl 		turn_pedestrians_off			; L2 a verde
	pop 	pc

startup_LEDs_OFF_Crossing_Cars:
	push 	lr
	bl 		turn_cars_green_on					; L1 a verde
	bl		turn_pedestrians_red_on				; L2 a vermelho
	bl 		turn_mode_yellow_on					; L3 a amarelo
	pop 	pc

/* fun timeout(timeRef, timeToCompare):{
	val presentTime = sysclk_get_ticks()
	val sub = presentTime - timeRef
	var timeout = false

	if((timeToCompare - sub) >= timeToCompare) timeout = true
	else timeout = false

	return timeout
}*/

; r0= timeRef, r1= timeToCompare

timeout:
	push 	lr
	push 	r4
	mov		r2, r0					; timeref
	bl 		sysclk_get_ticks		; Tempo atual em ticks
	mov		r4, r0					; presentTime 
	sub 	r0, r4, r2				; sub
	sub		r3, r1, r0				; timeToCompare - sub
	mov		r0, #0					; timeout = false
	cmp 	r1, r3					; timeToCompare - (timeToCompare - sub)
	bhs		timeout_l0				; caso seja menor salta
	mov		r0, #1					; timeout = true
timeout_l0:
	pop 	r4
	pop		pc

/*
fun evaluateStateTime(timeout: Boolean, stateActual: Boolean).{
	if(timout == true(1)){
		if(stateActual == true){
			outportSetBits (of L1 to green and L2 to red)
		}
		else outportClrBits (of L1 to nothing and L2 to nothing)
	}

}
*/

; r0 = timeout, r1 = stateAtual
evaluate_state_cars:
	push 	lr
	push	r4
	mov		r4, r1
	mov 	r2, #ONE
	cmp 	r0, r2							; timeout - 1
	bzs		evaluate_state_cars_l0				; flag z a zero salta, caso contrário continua
	cmp 	r1, r2							; state_time - 1
	bzc		evaluate_state_cars_l1				; flag z a zero salta, caso contrário continua
	bl		turn_cars_green_on				; L1 a verde
	bl		turn_pedestrians_red_on			; L2 a vermelho
	mov 	r2, #ZERO
	str		r2, [r4]
evaluate_state_cars_l1:
	bl		turn_cars_off
	bl		turn_pedestrians_off
	str		r2, [r4]
evaluate_state_cars_l0:	
	pop 	r4
	pop 	pc

; r0 = timeout, r1 = stateAtual
evaluate_state_config:
	push 	lr
	mov 	r2, #ONE
	cmp 	r0, r2							; timeout - 1
	bzs		evaluate_state_config_l0		; flag z a zero salta, caso contrário continua
	cmp 	r1, r2							; state_time - 1
	bzs		evaluate_state_config_l1		; flag z a zero salta, caso contrário continua
	bl		turn_cars_yellow_on
	bl		turn_pedestrians_green_on
evaluate_state_config_l1:
	bl		turn_cars_off
	bl		turn_pedestrians_off
evaluate_state_config_l0:
	pop 	pc

;-----------------------------------------------------

; Camada aplicacional

;-----------------------------------------------------

; uint8_t get_pedestrian_button(uint8_t inport_val)
get_pedestrian_button:
	push	lr
	bl      inport_read             			; Ler o porto de leitura
    mov     r1, #PEDESTRIAN_BUTTON_MASK
    and     r0, r0, r1
    lsr     r0, r0, #PEDESTRIAN_BUTTON_POS
	pop		pc
; uint8_t get_config(uint8_t inport_val)
get_config:
	push	lr
	bl      inport_read             			; Ler o porto de leitura
    mov     r1, #CONFIG_MASK
    and     r0, r0, r1
    lsr     r0, r0, #CONFIG_POS
    pop		pc

; uint8_t get_time(uint8_t inport_val)
get_time:
	push	lr
	bl      inport_read             			; Ler o porto de leitura
    mov     r1, #TIME_MASK
    and     r0, r0, r1
    lsr     r0, r0, #TIME_POS
    pop		pc

turn_cars_red_on:
	push 	lr
	mov 	r0, #TRAFFIC_LIGHT_G_MASK
	bl		outport_clear_bits
	mov		r0, #TRAFFIC_LIGHT_R_MASK
	bl		outport_set_bits
	pop 	pc

turn_pedestrians_red_on:
	push	lr
	mov 	r0, #PEDESTRIAN_LIGHT_G_MASK
	bl		outport_clear_bits
	mov		r0, #PEDESTRIAN_LIGHT_R_MASK
	bl		outport_set_bits
	pop		pc

turn_mode_yellow_on:
	push 	lr
	mov 	r0, #MODE_G_MASK
	bl		outport_set_bits
	mov		r0, #MODE_R_MASK
	bl		outport_set_bits
	pop 	pc

turn_cars_green_on:
	push 	lr
	mov 	r0, #TRAFFIC_LIGHT_G_MASK
	bl		outport_set_bits
	mov		r0, #TRAFFIC_LIGHT_R_MASK
	bl		outport_clear_bits
	pop 	pc

turn_pedestrians_green_on:
	push	lr
	mov 	r0, #PEDESTRIAN_LIGHT_G_MASK
	bl		outport_set_bits
	mov		r0, #PEDESTRIAN_LIGHT_R_MASK
	bl		outport_clear_bits
	pop		pc

turn_cars_off:
	push	lr
	mov 	r0, #TRAFFIC_LIGHT_G_MASK
	bl 		outport_clear_bits
	mov 	r0, #TRAFFIC_LIGHT_R_MASK
	bl 		outport_clear_bits
	pop 	pc

turn_pedestrians_off:
	push 	lr
	mov		r0, #PEDESTRIAN_LIGHT_G_MASK
	bl 		outport_clear_bits
	mov		r0, #PEDESTRIAN_LIGHT_R_MASK
	bl 		outport_clear_bits
	pop		pc

turn_cars_yellow_on:
	push 	lr
	mov		r0, #TRAFFIC_LIGHT_G_MASK
	bl 		outport_set_bits
	mov		r0, #TRAFFIC_LIGHT_R_MASK
	bl 		outport_set_bits
	pop		pc

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

isr:
	push 	r0
	push 	r1
	ldr		r1, sysclk_addr
	ldr		r0, [r1]
	add		r0, r0, #1
	str		r0, [r1]			; Incrementa o valor da variável global sysclk
	ldr		r0, ptc_addr
	mov		r1, #PTC_CMD_STOP
	strb	r0, [r1, #PTC_TIR]	
	pop		r1
	pop		r0
	movs 	pc, lr	

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

/*

/* fun timeout(timeRef):{
	val presentTime = sysclk_get_ticks()
	val sub = presentTime - timeRef
	var timeout = false

	if((#BLINK_TIME - sub) >= #BLINK_TIME) timeout = true
	else timeout = false

	return timeout
}*/

timeout_blink:
	push 	lr
	push	r4
	mov		r1, r0					; timeRef
	bl 		sysclk_get_ticks		; Tempo atual em ticks
	mov		r4, r0					; presentTime 
	sub 	r0, r4, r1				; sub
	mov		r2, #BLINK_TIME			; Tempo a atingir
	sub 	r1, r2, r0				; (#BLINK_TIME - sub) 
	mov		r0, #0					; timeout = false
	cmp 	r1, r2					; (#BLINK_TIME - sub) >= #BLINK_TIME
	blo		timeout_blink_end		; if((#BLINK_TIME - sub) >= #BLINK_TIME) for false não houve timeout = 0
	mov		r0, #1					; Caso contrário timeout = true
timeout_blink_end:
	pop		r4
	pop		pc

	.data

button_state:
    .space 1

led_state:
    .space 1

sysclk:
	.space	2

outport_img:
	.space	1

startup_LEDs:
	.space	1

crossing_times:
    .word       100, 150, 200, 250, 300

carsOrConfig:
	.space 1

state:
	.space 1

	.section .stack
	.space	STACK_SIZE
stack_top:


; Testada - Funciona tanto para Timeout = 0 e Timeout = 1
; r0 = timeout
evaluate_state_cars:
	push 	lr
	mov 	r2, #ONE
	cmp 	r0, r2							; timeout(1) - 1 = 0 logo entra no if
	bzc		evaluate_state_cars_l0				; flag z a zero salta, caso contrário continua
	ldr		r1, state_addr2
	ldr		r1, [r1]
	cmp 	r1, r2							; state_time - 1
	bzs		evaluate_state_cars_l1				; flag z a zero salta, caso contrário continua
	bl		turn_cars_yellow_on				; L1 a verde
	b		evaluate_state_cars_l2
evaluate_state_cars_l1:
	bl		turn_cars_off
	mov 	r2, #ZERO
evaluate_state_cars_l2:
	ldr		r1, state_addr2
	str		r2, [r1]
evaluate_state_cars_l0:	
	pop 	pc
