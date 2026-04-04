#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - scoring.asm
#File description - This file calculates the score by scanning the black hole and prints the final board, score, winner, and closing message. 

#data segment
.data

.globl player_score
.globl comp_score
.globl bh_pos

player_score: .word 0
comp_score: .word 0
bh_pos: .word 0

bh_at: .asciiz "\nBlack hole at position "
bh_end: .asciiz "\n"
sc_hdr: .asciiz "\n*---* Scores *---*\n"
p1_sc: .asciiz "Player: "
cp_sc: .asciiz "Computer: "
s_newline: .asciiz "\n"
p1_win: .asciiz "\nPLAYER WINS\n"
cp_win: .asciiz "\nCOMPUTER WINS\n"
tie_text: .asciiz "\nTIE\n"
s_sep: .asciiz "-------------------------\n"

.text
.globl calculate_scores
.globl announce_winner
.globl is_player_winner


calculate_scores:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)

    sw $zero, player_score
    sw $zero, comp_score

    li $s0, 0

find_bh:
    bge $s0, 21, bh_found
    la $t0, board_owner
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $t2, 0($t0)
    beq $t2, 3, bh_found
    addi $s0, $s0, 1
    j find_bh

bh_found:
    sw $s0, bh_pos

    move $a0, $s0
    jal get_adj_entry_addr
    move $t7, $v0

    lw $s2, 0($t7)  
    li $s1, 0

adj_loop:
    bge $s1, $s2, adj_done

    addi $t0, $s1, 1
    sll $t0, $t0, 2
    add $t0, $t7, $t0
    lw $s3, 0($t0)           
    blt $s3, 0, adj_next

    la $t0, board_owner
    sll $t1, $s3, 2
    add $t0, $t0, $t1
    lw $t2, 0($t0)           

    la $t0, board_value
    add $t0, $t0, $t1
    lw $t3, 0($t0)           

    beq $t2, 1, add_to_player
    beq $t2, 2, add_to_comp
    j adj_next

add_to_player:
    lw $t4, player_score
    add $t4, $t4, $t3
    sw $t4, player_score
    j adj_next

add_to_comp:
    lw $t4, comp_score
    add $t4, $t4, $t3
    sw $t4, comp_score

adj_next:
    addi $s1, $s1, 1
    j adj_loop

adj_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

announce_winner:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, bh_at
    syscall
    lw $a0, bh_pos
    addi $a0, $a0, 1
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, bh_end
    syscall

    li $v0, 4
    la $a0, sc_hdr
    syscall

    li $v0, 4
    la $a0, p1_sc
    syscall
    lw $a0, player_score
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, s_newline
    syscall

    li $v0, 4
    la $a0, cp_sc
    syscall
    lw $a0, comp_score
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, s_newline
    syscall

    lw $t0, player_score
    lw $t1, comp_score
    blt $t0, $t1, p1_w
    bgt $t0, $t1, cp_w

    li $v0, 4
    la $a0, tie_text
    syscall
    j an_done

p1_w:
    li $v0, 4
    la $a0, p1_win
    syscall
    j an_done

cp_w:
    li $v0, 4
    la $a0, cp_win
    syscall

an_done:
    li $v0, 4
    la $a0, s_sep
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

is_player_winner:
    lw $t0, player_score
    lw $t1, comp_score
    blt $t0, $t1, ipw_yes
    li $v0, 0
    jr $ra

ipw_yes:
    li $v0, 1
    jr $ra
