#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - main.asm
#File description - This file plays the opening music and prints the welcome screen. It also calculates the player and computer shuffle index, update's ASCII board. Finds the black hole position. 

#data segment
.data

m_sep: .asciiz "\n------------------------------\n"
p1_text: .asciiz "  P"
bh_text: .asciiz "\n  The Black Hole placed on last open tile\n"
at_text: .asciiz " at position "
m_newline: .asciiz "\n"
bye: .asciiz "\nThank you for playing!\n"

#text segment
.text
.globl main

main:
    jal seed_comp
    jal print_welcome

new_game:
    jal play_intro_music
    jal init_board
    jal print_board_ascii
    jal draw_bitmap
    li $s0, 1   

loop_r:
    bgt $s0, 10, done_r
    li $v0, 4
    la $a0, m_sep
    syscall

    move $t0, $s0
    sll $t0, $t0, 1
    addi $t0, $t0, -2
    move $a0, $t0
    jal get_shuffled_pos
    move $s1, $v0

    move $a0, $s1
    li $a1, 1       
    move $a2, $s0
    jal place_tile

    li $v0, 4
    la $a0, p1_text
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, at_text
    syscall
    move $a0, $s1
    addi $a0, $a0, 1
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, m_newline
    syscall

    move $t0, $s0
    sll $t0, $t0, 1
    addi $t0, $t0, -1
    move $a0, $t0
    jal get_shuffled_pos
    move $s2, $v0

    move $a0, $s2
    li $a1, 2        
    move $a2, $s0
    jal place_tile

    move $a0, $s0
    move $a1, $s2
    jal print_comp_place

    jal print_board_ascii
    jal draw_bitmap
    jal play_melody_note

    li $v0, 32
    li $a0, 3000
    syscall

    addi $s0, $s0, 1
    j loop_r

done_r:
    li $a0, 20
    jal get_shuffled_pos
    move $s7, $v0
    move $a0, $s7
    li $a1, 3
    li $a2, 0
    jal place_tile

    li $v0, 4
    la $a0, bh_text
    syscall

    jal calculate_scores
    jal print_board_ascii
    jal draw_bitmap
    jal announce_winner

    jal is_player_winner
    beq $v0, 1, p1_end
    jal play_sad_end
    j m_done

p1_end:
    jal play_win_fanfare

m_done:
    jal ask_play_again
    beq $v0, 1, new_game

    li $v0, 4
    la $a0, bye
    syscall
    li $v0, 10
    syscall
