#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - computer.asm
#File description - This file generate's the seed for the computers number to be placed in random positions and prints them.


#data segment
.data

comp_seed: .word 31415
comp_text: .asciiz "  C"
comp_at: .asciiz " at position "
comp_newline: .asciiz "\n"

#text segment
.text

.globl seed_comp
.globl print_comp_place

seed_comp:
    lw $a1, comp_seed
    li $a0, 1
    li $v0, 40
    syscall
    jr $ra

print_comp_place:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)

    li $v0, 4
    la $a0, comp_text
    syscall
    lw $a0, 4($sp)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, comp_at
    syscall
    lw $a0, 8($sp)
    addi $a0, $a0, 1
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, comp_newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra
