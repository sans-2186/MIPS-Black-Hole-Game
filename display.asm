#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - display.asm
#File description - This file not only prints the board's format for the input/output window, but also for the Bitmap display (colours, draw, pixels)

#data segment
.data

bitmap_data: .space 8192

clr_bg: .word 0x111827
clr_emp: .word 0x374151
clr_p1: .word 0x3B82F6
clr_comp: .word 0xEF4444
clr_bh: .word 0x22C55E
clr_edge: .word 0xFFFFFF
clr_text: .word 0xFFFFFF

row_x_start: .word 29, 26, 23, 20, 17, 14
row_y_start: .word 1, 6, 11, 16, 21, 26

dp_top: .asciiz "\n*=*=*=*=*=* BLACK HOLE BOARD GAME =*=*=*=*=*\n"
dp_bot: .asciiz "*============================*\n"
c_emp: .asciiz "{   }"
c_bh: .asciiz "{ 0 }"
b_lm: .asciiz "{"
b_r: .asciiz "}"
t_p: .asciiz "P"
t_c: .asciiz "C"
sp: .asciiz " "
dp_newline: .asciiz "\n"
n10: .asciiz "10"

n0: .asciiz "0"
n1: .asciiz "1"
n2: .asciiz "2"
n3: .asciiz "3"
n4: .asciiz "4"
n5: .asciiz "5"
n6: .asciiz "6"
n7: .asciiz "7"
n8: .asciiz "8"
n9: .asciiz "9"
digit_table: .word n0,n1,n2,n3,n4,n5,n6,n7,n8,n9

indent_15: .asciiz "               "
indent_12: .asciiz "            "
indent_9: .asciiz "         "
indent_6: .asciiz "      "
indent_3: .asciiz "   "
indent_0: .asciiz ""
indent_table: .word indent_15, indent_12, indent_9, indent_6, indent_3, indent_0


gly_rows:
    .byte 3,3,3   # 0
    .byte 1,1,1   # 1
    .byte 3,1,2   # 2
    .byte 3,1,3   # 3
    .byte 2,3,1   # 4
    .byte 3,2,3   # 5
    .byte 2,3,3   # 6
    .byte 3,1,1   # 7
    .byte 3,3,3   # 8
    .byte 3,3,1   # 9
    .byte 3,3,2   # P
    .byte 3,2,3   # C
    .byte 2,3,2   # B
    .byte 2,3,2   # H

#text segment
.text

.macro px_store
    la $t3, bitmap_data
    li $t4, 64
    mul $t4, $a1, $t4
    add $t4, $t4, $a0
    sll $t4, $t4, 2
    add $t3, $t3, $t4
    sw $a2, 0($t3)
.end_macro

.globl print_board_ascii
.globl draw_bitmap

print_board_ascii:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    li $v0, 4
    la $a0, dp_top
    syscall

    li $s0, 0
    li $s2, 0

row_loop:
    bge $s0, 6, row_done
    la $t0, indent_table
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $a0, 0($t0)
    li $v0, 4
    syscall

    la $t0, row_size
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $s1, 0($t0)
    li $t9, 0

col_loop:
    bge $t9, $s1, col_done
    la $t0, board_owner
    sll $t1, $s2, 2
    add $t0, $t0, $t1
    lw $s3, 0($t0)
    la $t0, board_value
    add $t0, $t0, $t1
    lw $s4, 0($t0)

    beq $s3, 0, p_empty
    beq $s3, 3, p_bh
    li $v0, 4
    la $a0, b_lm
    syscall

    beq $s3, 1, p_p
    li $v0, 4
    la $a0, t_c
    syscall

    j p_num

p_p:
    li $v0, 4
    la $a0, t_p
    syscall

p_num:
    beq $s4, 10, p_ten
    li $v0, 4
    la $a0, sp
    syscall

    la $t0, digit_table
    sll $t1, $s4, 2
    add $t0, $t0, $t1
    lw $a0, 0($t0)
    li $v0, 4
    syscall

    j p_close

p_ten:
    li $v0, 4
    la $a0, n10
    syscall

p_close:
    li $v0, 4
    la $a0, b_r
    syscall
    j p_next

p_empty:
    li $v0, 4
    la $a0, c_emp
    syscall
    j p_next

p_bh:
    li $v0, 4
    la $a0, c_bh
    syscall

p_next:
    addi $s2, $s2, 1
    addi $t9, $t9, 1
    j col_loop

col_done:
    li $v0, 4
    la $a0, dp_newline
    syscall
    addi $s0, $s0, 1
    j row_loop

row_done:
    li $v0, 4
    la $a0, dp_bot
    syscall
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra

draw_bitmap:
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)

    la $t0, bitmap_data
    lw $t1, clr_bg
    li $t2, 0

db_bg:
    bge $t2, 2048, db_bg_done
    sll $t3, $t2, 2
    add $t4, $t0, $t3
    sw $t1, 0($t4)
    addi $t2, $t2, 1
    j db_bg

db_bg_done:
    li $s0, 0

db_tile_loop:
    bge $s0, 21, db_done

    la $t0, board_owner
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $s1, 0($t0)
    la $t0, board_value
    add $t0, $t0, $t1
    lw $s6, 0($t0)

    beq $s1, 1, db_c_p1
    beq $s1, 2, db_c_comp
    beq $s1, 3, db_c_bh
    lw $s2, clr_emp
    j db_c_done

db_c_p1:
    lw $s2, clr_p1
    j db_c_done

db_c_comp:
    lw $s2, clr_comp
    j db_c_done

db_c_bh:
    lw $s2, clr_bh

db_c_done:

    la $t0, pos_to_row
    add $t0, $t0, $s0
    lb $s3, 0($t0)
    la $t0, pos_to_col
    add $t0, $t0, $s0
    lb $s4, 0($t0)

    la $t0, row_x_start
    sll $t1, $s3, 2
    add $t0, $t0, $t1
    lw $t2, 0($t0)
    li $t3, 6
    mul $t4, $s4, $t3
    add $s5, $t2, $t4   
    la $t0, row_y_start
    add $t0, $t0, $t1
    lw $s7, 0($t0)      

    move $a0, $s5
    move $a1, $s7
    move $a2, $s2
    jal draw_rect_5x5
    move $a0, $s5
    move $a1, $s7
    lw $a2, clr_edge
    jal draw_border_5x5

db_next:
    addi $s0, $s0, 1
    j db_tile_loop

db_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    addi $sp, $sp, 36
    jr $ra

draw_number_2x3:
    addi $sp, $sp, -24

    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    move $s1, $a0      
    move $s2, $a1      
    move $s0, $a2      
    move $s3, $a3    

    blt $s0, 10, dn_one
    li $t0, 10
    div $s0, $t0
    mflo $s4            
    mfhi $s0            
    move $a0, $s1
    move $a1, $s2
    move $a2, $s4
    move $a3, $s3
    jal draw_glyph_2x3
    addi $a0, $s1, 3
    move $a1, $s2
    move $a2, $s0
    move $a3, $s3
    jal draw_glyph_2x3
    j dn_done

dn_one:
    addi $a0, $s1, 1
    move $a1, $s2
    move $a2, $s0
    move $a3, $s3
    jal draw_glyph_2x3

dn_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra

draw_glyph_2x3:
    addi $sp, $sp, -28
    
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)

    move $s3, $a0      
    move $s4, $a1      
    move $s5, $a3   

    li $t0, 3
    mul $t1, $a2, $t0
    la $t2, gly_rows
    add $s1, $t2, $t1  
    li $s0, 0

dg_row:
    bge $s0, 3, dg_done
    add $t0, $s1, $s0
    lb $s2, 0($t0)     
    andi $t0, $s2, 2
    beq $t0, $zero, dg_right
    move $a0, $s3
    add $a1, $s4, $s0
    move $a2, $s5
    px_store

dg_right:
    andi $t0, $s2, 1
    beq $t0, $zero, dg_next
    addi $a0, $s3, 1
    add $a1, $s4, $s0
    move $a2, $s5
    px_store

dg_next:
    addi $s0, $s0, 1
    j dg_row

dg_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    addi $sp, $sp, 28
    jr $ra

draw_rect_5x5:
    move $t6, $a0
    move $t7, $a1
    move $t5, $a2
    li $t8, 0

dr5_y:
    bge $t8, 5, dr5_done
    li $t9, 0

dr5_x:
    bge $t9, 5, dr5_ny
    add $a0, $t6, $t9
    add $a1, $t7, $t8
    move $a2, $t5
    px_store
    addi $t9, $t9, 1
    j dr5_x

dr5_ny:
    addi $t8, $t8, 1
    j dr5_y

dr5_done:
    jr $ra

draw_border_5x5:
    move $t6, $a0
    move $t7, $a1
    move $t5, $a2
    li $t0, 0

db_top:
    bge $t0, 5, db_sides
    add $a0, $t6, $t0
    move $a1, $t7
    move $a2, $t5
    px_store
    add $a0, $t6, $t0
    addi $a1, $t7, 4
    move $a2, $t5
    px_store
    addi $t0, $t0, 1
    j db_top

db_sides:
    li $t0, 1

db_side_lp:
    bge $t0, 4, db_bdr_done
    move $a0, $t6
    add $a1, $t7, $t0
    move $a2, $t5
    px_store
    addi $a0, $t6, 4
    add $a1, $t7, $t0
    move $a2, $t5
    px_store
    addi $t0, $t0, 1
    j db_side_lp

db_bdr_done:
    jr $ra

draw_legend:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $a0, 52
    li $a1, 1
    lw $a2, clr_p1
    jal draw_rect_2x2
    li $a0, 55
    li $a1, 1
    li $a2, 10
    lw $a3, clr_text
    jal draw_glyph_2x3

    li $a0, 52
    li $a1, 5
    lw $a2, clr_comp
    jal draw_rect_2x2
    li $a0, 55
    li $a1, 5
    li $a2, 11
    lw $a3, clr_text
    jal draw_glyph_2x3

    li $a0, 52
    li $a1, 9
    lw $a2, clr_bh
    jal draw_rect_2x2
    li $a0, 55
    li $a1, 9
    li $a2, 12
    lw $a3, clr_text
    jal draw_glyph_2x3
    li $a0, 58
    li $a1, 9
    li $a2, 13
    lw $a3, clr_text
    jal draw_glyph_2x3

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_rect_2x2:
    move $t6, $a0
    move $t7, $a1
    move $t5, $a2
    li $t8, 0

dr2_y:
    bge $t8, 2, dr2_done
    li $t9, 0

dr2_x:
    bge $t9, 2, dr2_ny
    add $a0, $t6, $t9
    add $a1, $t7, $t8
    move $a2, $t5
    px_store
    addi $t9, $t9, 1
    j dr2_x

dr2_ny:
    addi $t8, $t8, 1
    j dr2_y

dr2_done:
    jr $ra

put_pixel:
    la $t3, bitmap_data
    li $t4, 64
    mul $t4, $a1, $t4
    add $t4, $t4, $a0
    sll $t4, $t4, 2
    add $t3, $t3, $t4
    sw $a2, 0($t3)
    jr $ra
