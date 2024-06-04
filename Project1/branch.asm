#file: branch.asm
.data
A: .word 15
B: .word 10
C: .word 6
Z: .word 0
.text
main:
lw $t5,A
lw $t6,B
lw $t7,C
lw $t8,Z
bgt $t5,$t6,L10
blt $t7,5,L10
j L110
L10:
li $t8,1
j L20
L110:
beq $t5,$t6,L11
li $t8,3
j L20
L11:
li $t8,2
L20:
beq $t8,1,L3
j L4
L3:
li $t8,-1
j L7
L4:
beq $t8,2,L5
j L6
L5:
li $t8,-2
j L7
L6:
li $t8,0
L7:
sw $t8,Z
