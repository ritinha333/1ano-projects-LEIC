
; De acordo a máquina de estados presente nos slides 23, será implementado um sistema que abre um portão

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


; Definição de constantes

; Máscaras para o porto de entrada
    .equ    B_MASK,             0x1
    .equ    SA_MASK,            0x2
    .equ    SF_MASK,            0x4
    .equ    SO_MASK,            0x8

; Máscaras para o porto de saída
    .equ    ON_OFF_MASK,        0x1
    .equ    ABRE_FECHA_MASK,    0x2

; Estados da máquina de estados
    .equ    FECHADO_ST,             0
    .equ    ABERTO_ST,              2
    .equ    ABRIR_ST,               4
    .equ    FECHAR_ST,              6
    .equ    PARADO_ABRIR_ST,        8
    .equ    PARADO_FECHAR_ST,       10

/*
Inicialização em linguagem C

for(;;){        (for forever)

    inport_img = inport_read();     lemos apenas uma vez do porto de entrada (essa imagem vai permirtir saber qual 
                                    o estado a seguir)

Baseado no valor da minha variável de estado saber qual branch vai ser executado

Implementação do switch case em Assembly através duma tabela de referências de branches

Manipular o pc de modo a executar o branch que quero
    ldr     r1, STATE_ADDRESS
    ldrb    r1, [r1]
    lsl     r1, r1, #1  (para escalar - passo a ter um offset referente ao estado a saltar de acordo o valor de offset - base 2 - entre 0 e 5)
    mov     r0, pc
    add     r0, r0, #4      (referência para a tabela)
    add     pc, r0 (referência para a minha tabela de branch), r1 (state_variable)  - salta em função desta adição
    add     pc, r1, pc  (o pc já está a apontar para a próxima)
branch_table:
    b   case_fechado
    b   case_aberto
    b   case_abrir
    b   case_fechar
    b   case_parado_abrir
    b   case_parado_fechar

case_fechado: ...
case_aberto: ...
case_abrir: ... 
case_fechar: ...
case_parado_abrir: ...
case_parado_fechar: ...


Implementação do switch case em Assembly através duma tabela de endereços em memória

STATE_CASES:
    .word   case_fechado, case_aberto, case_abrir, case_fechar, case_parado_abrir, case_parado_fechar

Baseado indexado baseado no LogicalShiftLeft. ldr é de forma a laterar o valor do program counter

    ldr     r1, STATE_ADDR
    ldrb    r1, [r1]
    lsl     r1, r1, #1
    ldr     r0, STATE_CASES_ADDR
    ldr     pc, [r0, r1]        (indexa o program counter com o valor escalado que está presente em memória)

case_fechado: ...
    b switch_end
case_aberto: ...
    b switch_end
case_abrir: ... 
    b switch_end
case_fechar: ...
    b switch_end
case_parado_abrir: ...
    b switch_end
case_parado_fechar: ...

switch_end: ...

    switch(state){
        case FECHADO_ST:
            ...
            break;
        case ABERTO_ST:
            ...
            break;
        case ABRIR_ST:
         ...
            break;
        case FECHAR_ST:
         ...
            break;
        case PARADO_ABRIR:
         ...
            break;
        case PARADO_FECHAR:
         ...
            break;
    }
}

Interface programática para a implementação do problema:

Solução do switch_case -> menos ciclos de clock

uint8_t get_button()
uint8_t get_sa()
uint8_t get_sf()
uint8_t get_so()
void abre()
void fecha()
void para()
void print_state(uint8_t state) -> escrever no porto de saída o estado atual
uint16_t get_time(uint16_t timeref) -> o tempo de referência, dá-me o tempo que passou desda a referência passada em parâmetro, em ticks (now - ref)
uint8_t timeout(uint16_t time)
uint16_t get_time_ref() -> vai buscar o tempo atual
uint8_t detect_falling_edge (uint8_t now) -> deteta uma transição de 1 para 0

*/
main:
/*
preparar o programa
*/
main_loop:
/*
Tabela de branches
*/
case_fechado:
    mov     r0, r5
    bl      get_button              ; Zero ou um dependendo do valor presente no porto
    bl      detect_falling_edge     ; Para detetar se passou de um para zero -> r0 retorna 0 ou 1 - if true or false i guess
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop
    beq     main_loop               ; Quando a flag zero é true significa que o r0 é zero
    mov     r4, #ABRIR_ST           ; Registo r4 retém o estado atual
    b       main_loop               ; Volta à main de modo a testar novamente a tabela dos branches


case_abrir:
    mov     r0, r5
    bl      get_sa                  ; Verificar o retorno - se zero ou um
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop
    beq     case_abrir_l0           ; Quando a flag zero é true significa que o r0 é zero
    bl      para                    ; O portão nunca para, só está a abrir/on 
    bl      get_time_ref            ; Chamar a função get_time_ref de modo a obter a referência do tempo
    mov     r6, r0                  ; Mantém a referência do tempo 
    mov     r4, #ABERTO_ST          ; Colocar no registo de r4 o estado #ABERTO_ST
    b       main_loop
case_abrir_l0:
    bl      abre                    ; Para não estar sempre a fazer a condição de portão a ON e ABRE, num estado que esteja a transitar para o estado aberto colocar a condição de ABRE/ON
    mov     r0, r5
    bl      get_button              ; Zero ou um dependendo do valor presente no porto
    bl      detect_falling_edge     ; Para detetar se passou de um para zero -> r0 retorna 0 ou 1 - if true or false i guess
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop
    beq     main_loop               ; Quando a flag zero é true significa que o r0 é zero
    bl      para                    ; O portão nunca para, só está a abrir/on
    bl      get_time_ref            ; Chamar a função get_time_ref de modo a obter a referência do tempo
    mov     r6, r0                  ; Mantém a referência do tempo 
    mov     r4, #PARADO_ABRIR_ST    ; Colocar no registo de r4 o estado #PARADO_ABRIR_ST
    b       main_loop


case_aberto:
case_parado_abrir:

    mov     r0, r5
    bl      get_button              ; Zero ou um dependendo do valor presente no porto
    bl      detect_falling_edge     ; Para detetar se passou de um para zero -> r0 retorna 0 ou 1 - if true or false i guess
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop
    bne     case_aberto_l0          ; Caso não haja botão 
    mov     r0, r6                  ; Colocar em r0 o valor da referência de tempo, em r6
    bl      get_time                ; Dizer quanto tempo passou desde a referência
    bl      timeout                 ; Verificar se houve timeout
    and     r0, r0, r0              ; if r0 = 1 mudar de estado else main_loop
    beq     main_loop
case_aberto_l0:
    mov     r4, #FECHAR_ST
    b       main_loop


case_fechar:
    mov     r0, r5                  ; Imagem do porto de entrada
    bl      get_so                  ; Vai buscar o valor do sensor SO
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop 
    beq     case_fechar_l0
    mov     r4, #ABRIR_ST
    b       main_loop 
case_fechar_l0:
    mov     r0, r5
    bl      get_sf                  ; Vai buscar o valor do sensor SF
    and     r0, r0, r0
    beq     case_fechar_l1
    bl      para                    ; O portão nunca para, só está a abrir/on ->
    mov     r4, #FECHADO_ST
    b       main_loop 
case_fechar_l1:
    bl      fecha
    mov     r0, r5
    bl      get_button              ; Zero ou um dependendo do valor presente no porto
    bl      detect_falling_edge     ; Para detetar se passou de um para zero -> r0 retorna 0 ou 1 - if true or false i guess
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop
    beq     main_loop               ; Caso não haja botão 
    bl      para                    ; O portão nunca para, só está a abrir/on
    bl      get_time_ref
    mov     r6, r0
    mov     r4, #PARADO_FECHAR_ST
    b       main_loop


case_parado_fechar:
    mov     r0, r5                  ; Imagem do porto de entrada
    bl      get_button              ; Zero ou um dependendo do valor presente no porto
    bl      detect_falling_edge     ; Para detetar se passou de um para zero -> r0 retorna 0 ou 1 - if true or false i guess
    and     r0, r0, r0              ; Verificar o valor que está em r0 if(r0 = 1) mudar de estado else voltar ao loop
    beq     case_parado_fechar_l0
    mov     r4, #ABRIR_ST
    b       main_loop
case_parado_fechar_l0:
    mov     r0, r6
    bl      get_time
    bl      timeout
    and     r0, r0, r0
    beq     main_loop
    mov     r4, #FECHAR_ST
    b       main_loop

/*
Ficheiro de configuração

timer=PICO_Timer
id=5
databus=P16Low
addrsel=FF40,FF7F
clk=100Hz -> em termos de simulação só posso definir endereços entre 0Hz e 100Hz


P16
ext_irq=5,3

a interrupção está ligada ao identificador 5 com registo 3 - TIR A '1' interrupção

*/
/* 
Atribui aos bits do porto de saida identificados com o valor lógico um em pins_mask o valor dos bits correspondentes de value. O valor dos restantes bits n�o � alterado.
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



.stack
	.space	STACK_SIZE
stack_top:
