    .text
push r1
ldr r1, [ r2, # 2 ]
add r0, r2, # 1
strb r3, [ r2, # 5 ]
ldr r4, value_addr
ldrb r5, [ r6, # 0 ]
b .

value_addr:
    .word value1

    .data
value1:
    .word value2

value2:
    .word 0x1342
