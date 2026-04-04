#CS 2340 - Term Project 
#Author - Sanskriti Tiwari
#Date - 04/03/2026
#Location - UTD
#File name - music.asm
#File description - This file plays music for the intro, main, a happy one if player wins, and a depressing one if the player loses in the end. 

#data segment
.data

mel_nt:
    .word 76,75,76,75,76,71,74,72,69,-1
    .word 60,64,69,71,-1,64,68,71,72,-1
    .word 76,75,76,71
mel_dr:
    .word 200,200,200,200,200,200,200,200,500,300
    .word 200,200,200,500,300,200,200,200,500,300
    .word 200,200,200,500
mel_len: .word 24
mel_ix: .word 0

win_nt: .word 72,72,72,79,67
win_dr: .word 150,150,150,400,200
win_len: .word 5

sad_nt: .word 72,71,69,67
sad_dr: .word 300,300,300,600
sad_len: .word 4

ins_piano: .word 0
vol: .word 90

#text segment
.text

.globl play_melody_note
.globl play_intro_music
.globl play_win_fanfare
.globl play_sad_end

play_melody_note:
    lw $t0, mel_ix
    lw $t1, mel_len
    la $t2, mel_nt
    sll $t3, $t0, 2
    add $t2, $t2, $t3
    lw $t4, 0($t2)
    la $t2, mel_dr
    add $t2, $t2, $t3
    lw $t5, 0($t2)
    blt $t4, 0, m_rest
    move $a0, $t4
    move $a1, $t5

    lw $a2, ins_piano
    lw $a3, vol
    li $v0, 31
    syscall

    j m_next

m_rest:
    move $a0, $t5
    li $v0, 32
    syscall

m_next:
    addi $t0, $t0, 1
    blt $t0, $t1, m_save
    li $t0, 0

m_save:
    sw $t0, mel_ix
    jr $ra

play_intro_music:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $zero, mel_ix
    li $s0, 0

mi_lp:
    bge $s0, 8, mi_dn
    jal play_melody_note
    li $v0, 32
    li $a0, 50
    syscall

    addi $s0, $s0, 1
    j mi_lp

mi_dn:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

play_win_fanfare:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    li $s0, 0
    lw $t9, win_len

mw_lp:
    bge $s0, $t9, mw_dn
    la $t0, win_nt
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $a0, 0($t0)
    la $t0, win_dr
    add $t0, $t0, $t1
    lw $a1, 0($t0)
    lw $a2, ins_piano
    lw $a3, vol
    li $v0, 31
    syscall

    li $v0, 32
    move $a0, $a1
    syscall

    addi $s0, $s0, 1
    j mw_lp

mw_dn:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

play_sad_end:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    li $s0, 0
    lw $t9, sad_len

ms_lp:
    bge $s0, $t9, ms_dn
    la $t0, sad_nt
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    lw $a0, 0($t0)
    la $t0, sad_dr
    add $t0, $t0, $t1
    lw $a1, 0($t0)
    lw $a2, ins_piano
    lw $a3, vol
    li $v0, 31
    syscall

    li $v0, 32
    move $a0, $a1
    syscall

    addi $s0, $s0, 1
    j ms_lp

ms_dn:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
