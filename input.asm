#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - input.asm
#File description - This file shows the opening message, rules, and asks the user if they want to play again and enter their choice.

#data segment
.data

b_top: .asciiz "**********************************************\n"
text_top: .asciiz "*       BLACK HOLE BOARD GAME  (MIPS)        *\n"
b_mid: .asciiz "*                                            *\n"
r1: .asciiz "* Avatars:                               *\n"
r2: .asciiz "*    10 for PLAYER (BLUE)            *\n"
r3: .asciiz "*    10 for COMPUTER (RED)        *\n"
r4: .asciiz "*    1  BLACK HOLE  (GREEN)                     *\n"
b_end: .asciiz "**********************************************\n"

ask_pg: .asciiz "\nWant to play again? (1 = Yes, -1 = No): "
bad_in: .asciiz "Invalid choice. Enter 1 or -1: "

#text segment
.text

.globl print_welcome
.globl wait_for_enter
.globl ask_play_again

print_welcome:
    li $v0, 4
    la $a0, b_top
    syscall

    li $v0, 4
    la $a0, text_top
    syscall

    li $v0, 4
    la $a0, b_mid
    syscall

    li $v0, 4
    la $a0, r1
    syscall

    li $v0, 4
    la $a0, r2
    syscall

    li $v0, 4
    la $a0, r3
    syscall

    li $v0, 4
    la $a0, r4
    syscall
    
    li $v0, 4
    la $a0, b_end
    syscall
    jr $ra

wait_for_enter:
    jr $ra

ask_play_again:
again_prompt:
    li $v0, 4
    la $a0, ask_pg
    syscall

    li $v0, 5
    syscall

    move $t0, $v0
    beq $t0, 1, again_yes
    li $t1, -1
    beq $t0, $t1, again_no
    li $v0, 4
    la $a0, bad_in

    syscall
    j again_prompt

again_yes:
    li $v0, 1
    jr $ra

again_no:
    li $v0, 0
    jr $ra
