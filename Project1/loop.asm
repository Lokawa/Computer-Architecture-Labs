#file:loop.asm
.data
Z:.word 99
i:.word 0
.text
main:
lw $t1,Z
lw $t2,i
Loop1:
add $t2,$t2,1
blt $t2,$t1,Loop1

bgt $t2,0,Loop2
Loop2:
add $t1,$t2,$t1
add $t2,$t2,-1
bgt $t2,0,Loop2

sw $t1,Z
sw $t2,i
