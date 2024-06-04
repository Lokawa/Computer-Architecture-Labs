#file:loop_unrolling.asm
.data
Z:.word 99
i:.word 0
t:.word 0
.text
main:
lw $t1,Z
lw $t2,i
lw $t3,t
Loop1:
add $t2,$t2,1
blt $t2,$t1,Loop1

bgt $t2,16,Loop2
Loop2:
sll $t3,$t2,4
add $t1,$t1,$t3
addi $t1,$t1,-120
addi $t2,$t2,-16
bgt $t2,16,Loop2

bgt $t2,0,Loop3
Loop3:
add $t1,$t2,$t1
addi $t2,$t2,-1
bgt $t2,0,Loop3
sw $t1,Z
sw $t2,i
