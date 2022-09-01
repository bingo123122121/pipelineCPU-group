.data

 	# aString: .byte"hello world!"

.text

main:
addi $t1,$0,-8

or $t2,$t0,$t1
and $zero,$t2,$t0
j exit
xor $t1,$t2,$t0

exit:

li $v0,10

syscall   
