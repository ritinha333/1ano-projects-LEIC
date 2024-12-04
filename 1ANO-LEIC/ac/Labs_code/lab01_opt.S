; -----------------------------------------------------------------------------
; Ficheiro:  lab01.S
; Descricao: Codigo de suporte a realizacao da 1a atividade laboratorial de AC.
; Autor:     Tiago M Dias (tiago.dias@isel.pt)
; Data:      11-03-2022
; -----------------------------------------------------------------------------

	; r0 guarda o valor da variavel M
	; r1 guarda o valor da variavel m
	; r2 guarda o valor da variavel p
	; r3 e utilizado para guardar valores temporariamente

;	mov r2, #0		;p = 0
;	mov r3, #0		; aux = 0
;if:
;	cmp r3, r0		; aux - M	Em vez de estar a gastar mais registos poderíamos fazer AND r0, r0, r0 para não gastar mais registos
;	beq if_end			; if (M == 0), logo flag Z = 1 ele salta para o final do programa 
;
;while:
;	cmp r3, r1
;	bhs while_end
;	add r2, r2, r0
;	sub r1, r1, #1
;	b while
;while_end:
;
;if_end:
;	b 	.	;branch para ele próprio de forma a terminar o programa, o ponto final é um offset que anda sempre a saltar para ele próprio
;

; second version (otimizada)

	mov r2, #0		;p = 0
	mov r3, #0		; aux = 0

if:
	cmp r0, r3			; aux - M	Em vez de estar a gastar mais registos poderíamos fazer AND r0, r0, r0 para não gastar mais registos
	beq if_end			; if (M == 0), logo flag Z = 1 ele salta para o final do programa 
	cmp r1, r3			; aux - m	
	beq if_end			; if (m == 0), logo flag Z = 1 ele salta para o final do programa
	cmp r0, r1			;compara M com m 
	bhs while 			; caso ( M >= m ) ele vai para o while - faz menos iterações
	mov r3, r0			;tranferência de valores
	mov r0, r1
	mov r3, r1

while:
	sub r3, r3, r3
	cmp r3, r1
	bhs while_end
	add r2, r2, r0
	sub r1, r1, #1
	b while
while_end:

if_end:
	b 	.	;branch para ele próprio de forma a terminar o programa, o ponto final é um offset que anda sempre a saltar para ele próprio

