.data

.text

main:

lui $t6,0x0000 # bfaf/0000
ori $t6,$t6,0x2100 # 8000/2100
addi $t0,$t0,0x0004
andi $t1,$t1,0x0000
sw $t0,0x0($t6)


loop:
sub $t0,$t0,0x0001
sw $t0,0x0($t6)
beq $t0,$t1,exit
j loop
xori $t5,$t5,0x0250 # 本指令用于测试跳转指令
andi $t5,$t5,0x0250 # 本指令用于测试跳转指令

exit:
li $v0,10
syscall   
