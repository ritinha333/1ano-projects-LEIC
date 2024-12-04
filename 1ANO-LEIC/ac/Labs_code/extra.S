    .text
push pc
ldr r0, var1_addr
ldrb r1, [ r0, # 0 ]
ldrb r2, [ r0, # 1 ]
mov r3, #var2_addr
ldr r4, [ r3, # 0 ]
ldr r6, [ r5, # 0 ]
strb r7, [ r5, # 0 ]
strb r8, [ r5, # 1 ]
ldr r9, [ r3, # 0 ]
pop r10
b .
var1_addr:
    .word var1
var2_addr:
    .word var2

.data
var1:
    .word 0xABCD

var2:
    .word 32
    
