.data

.text

main:

lui $t6,0xbfaf # bfaf/0000
ori $t6,$t6,0x8000 # 8000/2100
addi $t0,$t0,0x0000
addi $t1,$t1,0x0004 # 30

loop:
addi $t0,$t0,0x0001
add $t2,$t2,$t0
beq $t0,$t1,exit
j loop
xori $t5,$t5,0x0250 # 本指令用于测试跳转指令
andi $t5,$t5,0x2277 # 本指令用于测试跳转指令

exit:
sw $t0,0x0($t6)
li $v0,10
syscall   
