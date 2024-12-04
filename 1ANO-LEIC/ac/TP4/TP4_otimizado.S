
; Definicao dos valores dos simbolos utilizados no programa
;
	.equ	ENABLE_EXTINT, 0x10          ; Mascara para o bit I do registo CPSR

	.equ	STACK_SIZE, 64                ; Dimensao do stack - 64 B

	; Definicoes do porto de entrada
	.equ	INPORT_ADDRESS, 0xFF80        ; Endereco do porto de entrada

	; Definicoes do porto de saida
	.equ	OUTPORT_ADDRESS, 0xFFC0       ; Endereco do porto de saida

	; Definicoes do circuito pTC
	.equ	PTC_ADDRESS,  0xFF40          ; Endereco do circuito pTC

	.equ	PTC_TCR, 0                    ; Deslocamento do registo TCR do pTC
	.equ	PTC_TMR, 2                    ; Deslocamento do registo TMR do pTC
	.equ	PTC_TC,  4                    ; Deslocamento do registo TC do pTC
	.equ	PTC_TIR, 6                    ; Deslocamento do registo TIR do pTC

	.equ	PTC_CMD_START, 0              ; Comando para iniciar a contagem no pTC
	.equ	PTC_CMD_STOP, 1               ; Comando para parar a contagem no pTC

	.equ	SYSCLK_FREQ, 0x63             ; Módulo 99 - Intervalo de contagem do circuito pTC
                                          ; que suporta a implementação do sysclk

	.equ	BLINK_TIME, 5                 ; A cada 0.5 segundos

; Constantes referentes ao porto de entrada e saída
    .equ    PEDESTRIAN_BUTTON_MASK, 	0x01
    .equ    PEDESTRIAN_BUTTON_POS,  	0
    .equ    CONFIG_MASK,            	0x10
    .equ    CONFIG_POS,             	4
    .equ    TIME_MASK,              	0xE0
    .equ    TIME_POS,               	5
    .equ    TRAFFIC_LIGHT_R_MASK,   	0x01
    .equ    TRAFFIC_LIGHT_G_MASK,   	0x02
	.equ	PEDESTRIAN_LIGHT_R_MASK, 	0x04
	.equ 	PEDESTRIAN_LIGHT_G_MASK, 	0x08
	.equ 	MODE_R_MASK,			 	0x10
	.equ 	MODE_G_MASK,			 	0x20


; Estados da aplicação
    .equ    CROSSING_CARS_ST,          0
    .equ    CROSSING_PEDESTRIAN_ST,    2
    .equ    CONFIG_ST,                 4

; Constantes auxiliares
	.equ 	ZERO,						0
	.equ 	ONE,						1

; Seccao:    startup
; Descricao: Guarda o código de arranque do sistema
;
	.section startup

	b		_start
	ldr		pc, isr_addr
_start:
	ldr		sp, stack_top_addr
    mov 	r0, pc
    add 	lr, r0, #4
	ldr		pc, main_addr
    b   .
stack_top_addr:
	.word stack_top
main_addr:
	.word	main
isr_addr:
	.word	isr

    .text
main:
    push    r4                      			; Estado atual
    push    r5                      			; Crossing_times_curr
    push    r6                      			; Referência do clock
    mov     r4, #CROSSING_CARS_ST   			; Estado atual = CROSSING_CARS_ST
    mov     r0, #SYSCLK_FREQ        			; Decidir qual o clock que vamos usar para alterar este valor
    bl      sysclk_init             			; Inicializar o clock
    mrs		r0, cpsr
	mov		r1, #ENABLE_EXTINT
	orr		r0, r0, r1
	msr		cpsr, r0
main_loop:
	ldr		r1, state_addr						; Carregar endereço da variável state_time
	mov		r2, #ONE							; r2 = 1
	str		r2, [r1]							; Colocar o state a zero inicialmente
    add     pc, r4, pc              			; Incrementar o program counter com o valor de acordo o branch a ser efetuado
main_branch_table:
    b       case_crossing_cars
    b       case_crossing_pedestrians
    b       case_config
	b		main_end
state_addr:
	.word 	state

case_crossing_cars:		
	bl		startup_LEDs_Crossing_Cars
case_crossing_cars_begin:
	bl 		get_config							; De acordo a imagem do porto de entrada vê o estado do config
	and     r0, r0, r0
    bzc		case_crossing_cars_l0				
	bl 		get_pedestrian_button				; De acordo a imagem do porto de entrada vê o estado do botão
	bl		detect_rising_edge					; Avalia transição ascendente
	and     r0, r0, r0
    bzs 	case_crossing_cars_l1				
	mov		r0, r6								
	mov 	r1, #BLINK_TIME						
	bl 		timeout								; Avalia timeout
	and     r0, r0, r0
    bzc		case_crossing_cars_begin			
	bl 		evaluate_state_cars					
	mov		r1, #ZERO
	b 		case_crossing_cars_begin			
case_crossing_cars_l0:
	mov		r4, #CONFIG_ST
	b		main_loop
case_crossing_cars_l1:
	mov 	r4, #CROSSING_PEDESTRIAN_ST
	b		main_loop
case_crossing_pedestrians:
	bl		startup_LEDs_Pedestrians
case_crossing_pedestrians_begin:
	bl 		get_config							; De acordo a imagem do porto de entrada vê o estado do config
	and     r0, r0, r0
    bzs		case_crossing_pedestrians_l0		; se for false testa times
	mov		r1, r5								; crossing_time
	mov		r0, r6								; timeref
	bl		timeout								; Avalia timeout
	and     r0, r0, r0
    bzs		case_crossing_pedestrians_l1		
	bl 		get_pedestrian_button				; De acordo a imagem do porto de entrada vê o estado do botão
	and     r0, r0, r0
    bzc		case_crossing_pedestrians_begin		
	bl		sysclk_get_ticks					; Tira nova referência de tempo
	mov		r6, r0	
	b		case_crossing_pedestrians_begin
case_crossing_pedestrians_l0:
	mov		r4, #CONFIG_ST
	b		main_loop
case_crossing_pedestrians_l1:
	mov 	r4, #CROSSING_CARS_ST
	b		main_loop
case_config:
	bl		startup_LEDs_Config
case_config_begin:
	bl 		get_config							; De acordo a imagem do porto de entrada vê o estado do config
	and     r0, r0, r0
    bzs		case_config_l0						
	bl 		get_time
	lsl		r0, r0, #1
	ldr		r1, crossing_times_addr				; Carrega o endereço de crossing_times disponíveis para o led dos peões
	ldr 	r1, [r1, r0]						; Indexa o array de crossing times de acordo o valor presente dos 3 bits de maior peso do porto de entrada
	mov		r5, r1
	mov		r0, r6								; Colocar a referência do tempo em r0
	mov		r1, #BLINK_TIME						; Colocar em r1 o valor que quero passar ao timeout
	bl 		timeout								; Avalia timeout
	and     r0, r0, r0
    bzc		case_config_begin					
	bl 		evaluate_state_config				; avalia o state do tempo baseado no timeout
	mov 	r1, #ZERO
	b 		case_config_begin
case_config_l0:
	mov 	r4, #CROSSING_CARS_ST
	b 		main_loop
main_end:
	pop 	r6
	pop		r5
	pop		r4
	pop		pc

state_addr1:
	.word 	state

crossing_times_addr:
    .word   crossing_times


/*
fun evaluateStateTime(timeout: Boolean).{
	if(timout == true(1)){
		if(stateActual == true){
			outportSetBits (of L1 to green and L2 to red)
		}
		else outportClrBits (of L1 to nothing and L2 to nothing)
	}

}
*/

; r0 = timeout
evaluate_state_cars:
	push 	lr
	ldr		r1, state_addr2
	ldr		r1, [r1]
	cmp 	r1, r2							; state_time - 1
	bzs		evaluate_state_cars_l1				; flag z a zero salta, caso contrário continua
	bl		turn_cars_yellow_on				; L1 a verde
	mov 	r2, #ONE
	b		evaluate_state_cars_l2
evaluate_state_cars_l1:
	bl		turn_cars_off
	mov 	r2, #ZERO
evaluate_state_cars_l2:
	ldr		r1, state_addr2
	str		r2, [r1]
evaluate_state_cars_l0:	
	pop 	pc


; r0 = timeout
evaluate_state_config:
	push 	lr
	ldr		r1, state_addr2
	ldr		r1, [r1]
	cmp 	r1, r2	
	bzs		evaluate_state_config_l1		; flag z a zero salta, caso contrário continua
	bl		turn_cars_yellow_on
	bl		turn_pedestrians_green_on
	mov 	r2, #ONE
	b		evaluate_state_config_l2
evaluate_state_config_l1:
	bl		turn_cars_off
	bl		turn_pedestrians_off
	mov 	r2, #ZERO
evaluate_state_config_l2:
	ldr		r1, state_addr2
	str		r2, [r1]
evaluate_state_config_l0:
	pop 	pc

state_addr2:
	.word 	state

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

detect_rising_edge:
	mov			r1, #PEDESTRIAN_BUTTON_MASK
	and			r1, r0, r1				
	mov			r0, #0					
	ldr			r2, button_state_addr 
	bzs			detect_rising_edge_l0 
	ldrb		r3, [r2]				
	and			r3, r3, r3
	bzc			detect_rising_edge_l0 
	mov			r0, #1					
detect_rising_edge_l0:
	strb		r1, [r2]
	mov			pc, lr					

button_state_addr:
    .word   button_state

	
startup_LEDs_Crossing_Cars:
	push 	lr
	bl 		turn_cars_yellow_on					; L1 a verde
	bl		turn_pedestrians_red_on				; L2 a vermelho
	bl 		turn_mode_green_on					; L3 a verde
	pop 	pc

startup_LEDs_Config:
	push 	lr
	bl 		turn_cars_yellow_on					; L1 a amarelo
	bl 		turn_pedestrians_green_on			; L2 a verde
	bl		turn_mode_yellow_on					; L3 a amarelo
	pop 	pc


startup_LEDs_Pedestrians:
	push 	lr
	bl 		turn_cars_red_on					; L1 a verde
	bl		turn_pedestrians_green_on			; L2 a vermelho
	bl 		turn_mode_green_on					; L3 a verde
	pop 	pc


/* fun timeout(timeRef, timeToCompare):{
	val presentTime = sysclk_get_ticks()
	val sub = presentTime - timeRef
	var timeout = false

	if(sub >= timeToCompare) timeout = true
	else timeout = false

	return timeout
}*/

; r0= timeRef, r1= timeToCompare
timeout:
	push 	lr
	mov		r2, r0					; timeref
	bl 		sysclk_get_ticks		; Tempo atual em ticks
	sub 	r2, r0, r2				; sub
	mov		r0, #0					; timeout = false
	cmp 	r2, r1					; timeToCompare - sub
	blo		timeout_l0				; caso seja menor salta
	bl 		sysclk_get_ticks					; Tirar nova referência de tempo
	mov 	r6, r0	
	mov		r0, #1					; timeout = true
timeout_l0:
	pop		pc


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

turn_mode_green_on:
	push 	lr
	mov 	r0, #MODE_G_MASK
	bl		outport_set_bits
	mov		r0, #MODE_R_MASK
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
	push	lr
	push 	r0
	push 	r1
	push	r2
	push	r3
	ldr		r1, sysclk_addr
	ldr		r0, [r1]
	add		r0, r0, #1
	str		r0, [r1]			; Incrementa o valor da variável global sysclk
	bl		ptc_clr_irq
	pop		r3
	pop		r2
	pop		r1
	pop		r0
	pop		lr
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

ptc_clr_irq:
	ldr		r0, ptc_addr
	strb	r1, [r0, #PTC_TIR]
	mov		pc, lr

ptc_addr:
	.word	PTC_ADDRESS


inport_read:
	ldr		r1, inport_addr
	ldrb	r0, [r1, #0]
	mov		pc, lr

inport_addr:
	.word	INPORT_ADDRESS

outport_set_bits:
	push	lr
	ldr		r1, outport_img_addr
	ldrb	r2, [r1, #0]
	orr		r0, r2, r0
	strb	r0, [r1, #0]
	bl		outport_write
	pop		pc

outport_clear_bits:
	push	lr
	ldr		r1, outport_img_addr
	ldrb	r2, [r1, #0]
	mvn		r0, r0
	and		r0, r2, r0
	strb	r0, [r1]
	bl		outport_write
	pop		pc

outport_init:
	push	lr
	ldr		r1, outport_img_addr
	strb	r0, [r1]
	bl		outport_write
	pop		pc

outport_img_addr:
	.word	outport_img

outport_write:
	ldr		r1, outport_addr
	strb	r0, [r1, #0]
	mov		pc, lr

outport_addr:
	.word	OUTPORT_ADDRESS

	.data

button_state:
    .space 1

sysclk:
	.space	2

outport_img:
	.space	1

crossing_times:
    .word       100, 150, 200, 250, 300, 300, 300, 300

state:
	.space 1

	.section .stack
	.space	STACK_SIZE
stack_top:
