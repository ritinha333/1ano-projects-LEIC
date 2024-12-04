;1.a) Como cada registo é codificado a 16 bits (2 bytes por registo), temos 8 bytes provenientes de registos, mais quatro bytes do 
;program counter e do link registor, e para finalizar pelas 9 instruções implentadas fazemos o 2^4= 16 bytes, logo a quantidade de
;memória necdessária para esta implementação é 8+4+16= 28 bytes
;1.b) A afirmação é falsa pois não é necessário usar slots do stack para esta implementação, 
;apenas é preciso os registos disponíveis (r0, r1, r2, r3)
;2.a) O valor da constante NAN equivale a 2 ^16 -1, isto é 65535 em decimal
;2.b) O valor NAN é uma constante a 16 bits na qual apresenta o valor mais alto que se consegue representar a 16 bits sem sinal

.equ STACK_SIZE, 64
.equ NAN, 0xFFFF


.section .startup
      b start_
	  b .
	  
start_:
	  ldr sp, stack_top_addr
	  mov r0, pc
	  add lr, r0, #4
	  ldr pc, main_addr
	  b .
	  
stack_top_addr:	  
	  .word stack_top
	 
main_addr:
       .word main 
	 
.text

;5)

main:

push lr 
ldr r4, error_addr
mov r5, #0
strb r5, [r4, #0]

firstMainIf:
    ldr r0, tst_str0_addr
	mov r1, #2
	bl str2nat
	ldr r2, tst_result_addr
	ldr r3, [r2, #0]
	cmp r0, r3                      ;compara o retorno da função str2nat com o valor necessário de tst_result
	beq secondMainIf
	mov r4, #1
	orr r5, r5, r4
	ldr r4, error_addr
	str r5, [r4, #0]      
	 
secondMainIf:
	ldr r0, tst_str1_addr
	mov r1, #8
	bl str2nat
	ldr r2, tst_result_addr
	ldr r3, [r2, #2]
	cmp r0, r3                       ;compara o retorno da função str2nat com o valor necessário de tst_result
	beq thirdMainIf
	mov r4, #2
	orr r5, r5, r4
	ldr r4, error_addr
	str r5, [r4, #0] 
	 
thirdMainIf:

	 ldr r0, tst_str1_addr
	 mov r1, #16
	 bl str2nat
	 ldr r2, tst_result_addr
	 ldr r3, [r2, #4]
	 cmp r0, r3             ;compara o retorno da função str2nat com o valor necessário de tst_result
	 beq thirdMainIf
	 mov r4, #4
	 orr r5, r5, r4
	 ldr r4, error_addr
	 str r5, [r4, #0]

main_end:
     mov r0, #0
	 pop pc
     b  .

;enderenços para saltos indiretos (valores iniciados)

error_addr:
    .word error

tst_str0_addr:
    .word tst_str0

tst_str1_addr:
    .word tst_str1

tst_str2_addr:
    .word tst_str2

tst_result_addr:
    .word tst_result

;-------------------------------------------------------------------------------------------------  

;3)

;r0 numeral[], vetor
;r1 radix
;r2 number
;r3 error
;r4 idx
;r5 tmp
;--------------------------------
;r6, r7, r8 temporário

str2nat: 

  push r4
  push r5
  push r6
  push r7
  push r8
  
  mov r2, #0
  mov r3, #0
  mov r4, #0
  
forCicle:
   mov r6, #0
   cmp r3, r6
   bne return
   ldr r6, [r0,r4] 	;numeral[idx]
   mov r7, #'\0'
   cmp r6, r7
   beq return
   mov r7, r0         
   mov r0, r6         
   mov r6, r3         
   mov r8, r2        
   push lr
   bl char2nat
   pop lr
   mov r0, r7         ;passar o valores para os registos iniciais para os poder voltar a usar nesta etapa
   mov r6, r0         
   mov r3, r6
   mov r2, r8         
   mov r7, #NAN & 0xFF
   movt r7, #NAN & 0xFF      
   cmp r6, r7
   bne else_forCicle
   mov r2, r7
   mov r3, #1
   b forCicle
   
else_forCicle:
   mov r5, r0
   mov r6, r1
   mov r7, r2
   mov r8, r3
   push lr 
   bl multiply
   pop lr
   mov r3, r8
   mov r2, r7
   mov r1, r6
   mov r0, r5
   b forCicle_end
multiply:
   mov r2, #0
while:
   mov r3, #0
   cmp r3, r1
   bhs while_end
   add r2, r2, r0
   sub r1, r1, #1
   b while
while_end:
	mov r0, r2
	mov pc, lr
	   
forCicle_end:
   add r4, r4, #1
   b forCicle
   
return:
       mov r0, r3   ;apesar de ser feito o mov ele não transfere valor do r3 para o r0
       pop r8
       pop r7
       pop r6
       pop r5
       pop r4
       mov pc, lr
    
;------------------------------------------------------------------------------------------
;2.c)

 ;r0 symbol
  ;r1 radix
  ;r2 number que toma o valor de NAN
  ;r3 operação do segundo if
  
char2nat:
   mov r2, #NAN & 0xFF
   movt r2, #NAN & 0xFF
firstIf:
   mov r4, #'0'
   cmp r0, r4             ;comparação entre symbol e 0
   blo firstElse
   mov r4, #'9'
   cmp r4, r0                ;comparação entre 9 e symbol
   blo firstElse
   mov r4, #'0'
   sub r2, r0, r4                 ;subtração number = symbol - '0' (atualiza o valor de number)
 
firstElse:
   mov r4, #'A'
   cmp r0, r4                ;comparação entre symbol e 'A'
   blo char2nat_end
   mov r4, #'F'
   cmp r4, r0                ;comparação entre 'F' e symbol
   blo char2nat_end
   mov r4, #'A'
   sub r3, r0, r4           ;r3 = symbol - 'A' ;r2 = r3 + 10
   add r2, r3, #10                  

secondIf:
   mov r4, #16
   cmp r1, r4                      
   bhs char2nat_end                 ;comparação entre radix e 16 (basta este teste pois operação lógica ou)
   mov r2, #NAN & 0xFF
   movt r2, #NAN & 0xFF       
                                   
char2nat_end:
   mov r0, r2   ;retorno 
   mov pc, lr
   

;-----------------------------------------------
;4)

.data

    tst_result:
       .word 0x000B, 0x01C9, 0x9A0F
     
	tst_str0:
	   .asciz "01011"	
       .align 1
	tst_str1:
	   .asciz "709"
	   .align 1
    tst_str2:
       .asciz "9A0F"
    

.section .bss
    
	error:
	   .space 1
	 

 .section .stack 

 .space STACK_SIZE

 stack_top:
