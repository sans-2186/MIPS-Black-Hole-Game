#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - board.asm
#File description - This file store's numbers and shuffle's the positions of the numbers to be stored in the input/output section pyramid and gets the adjacent entry's address



#data segment
.data

.globl board_owner
.globl board_value
.globl pos_to_row
.globl pos_to_col
.globl row_size

board_owner: .word 0:21
board_value: .word 0:21
shuffle_arr: .word 0:21

pos_to_row: .byte 0,1,1,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,5,5
pos_to_col: .byte 0,0,1,0,1,2,0,1,2,3,0,1,2,3,4,0,1,2,3,4,5
row_size: .word 1,2,3,4,5,6

adj_table:
    .word 2,1,2,-1,-1,-1,-1
    .word 4,0,2,3,4,-1,-1
    .word 4,0,1,4,5,-1,-1
    .word 4,1,4,6,7,-1,-1
    .word 6,1,2,3,5,7,8
    .word 4,2,4,8,9,-1,-1
    .word 4,3,7,10,11,-1,-1
    .word 6,3,4,6,8,11,12
    .word 6,4,5,7,9,12,13
    .word 4,5,8,13,14,-1,-1
    .word 4,6,11,15,16,-1,-1
    .word 6,6,7,10,12,16,17
    .word 6,7,8,11,13,17,18
    .word 6,8,9,12,14,18,19
    .word 4,9,13,19,20,-1,-1
    .word 2,10,16,-1,-1,-1,-1
    .word 4,10,11,15,17,-1,-1
    .word 4,11,12,16,18,-1,-1
    .word 4,12,13,17,19,-1,-1
    .word 4,13,14,18,20,-1,-1
    .word 2,14,19,-1,-1,-1,-1

#text segment
.text

.globl init_board
.globl place_tile
.globl get_shuffled_pos
.globl get_adj_entry_addr

init_board:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    la $t0, board_owner
    la $t1, board_value
    li $t2, 0
z_lp:
    bge $t2, 21, z_dn
    sll $t3, $t2, 2
    add $t4, $t0, $t3
    sw $zero, 0($t4)
    add $t4, $t1, $t3
    sw $zero, 0($t4)
    addi $t2, $t2, 1
    j z_lp

z_dn:
    la $t0, shuffle_arr
    li $t2, 0

f_lp:
    bge $t2, 21, f_dn
    sll $t3, $t2, 2
    add $t4, $t0, $t3
    sw $t2, 0($t4)
    addi $t2, $t2, 1
    j f_lp

f_dn:
    li $s0, 20

s_lp:
    blt $s0, 1, s_dn
    li $v0, 42
    li $a0, 0
    addi $a1, $s0, 1
    syscall
    move $s1, $a0

    la $t0, shuffle_arr
    sll $t1, $s0, 2
    add $t2, $t0, $t1
    sll $t1, $s1, 2
    add $t3, $t0, $t1
    lw $t4, 0($t2)
    lw $t5, 0($t3)
    sw $t5, 0($t2)
    sw $t4, 0($t3)

    addi $s0, $s0, -1
    j s_lp

s_dn:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

place_tile:
    sll $t0, $a0, 2
    la $t1, board_owner
    add $t1, $t1, $t0
    sw $a1, 0($t1)
    la $t1, board_value
    add $t1, $t1, $t0
    sw $a2, 0($t1)
    jr $ra

get_shuffled_pos:
    la $t0, shuffle_arr
    sll $t1, $a0, 2
    add $t0, $t0, $t1
    lw $v0, 0($t0)
    jr $ra

get_adj_entry_addr:
    li $t0, 7
    mul $t0, $a0, $t0
    sll $t0, $t0, 2
    la $v0, adj_table
    add $v0, $v0, $t0
    jr $ra
