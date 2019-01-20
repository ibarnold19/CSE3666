##############################
# Bryan Arnold
# CSE 3666
# I/O Arithmetic Assignment 1
# 2/25/17
###############################

	.data
Q1: .asciiz "Please enter a value for a: "
Q2: .asciiz "Please enter a value for x: "
n: .asciiz "\n"
R: .asciiz "y="
R4: .asciiz " R4." # is this needed?
	.text

#########################################################################	This program takes in user input for two integers, then computes
#	the following and then displays the result as well as the register
#	the result is in: # $t0 = (((a + 13) * (x * x)) + (x * 4)) / 5
########################################################################

main:

	li $v0, 4
	la $a0, Q1
	syscall				# ask user for a value for a

	li $v0, 5
	syscall
	move $t0, $v0		# a is in $t0

	li $v0, 4
	la $a0, n
	syscall				# new line

	li $v0, 4
	la $a0, Q2
	syscall				# ask user for a value for x

	li $v0, 5
	syscall
	move $t1, $v0		# x is in $t1

	li $v0, 4
	la $a0, n
	syscall				# new line

	addi $t0, $t0, 13		# $t0 = a + 13
	mul $t9, $t1, $t1		# $t9 = x * x
	mul $t0, $t0, $t9		# $t0 = (a + 13) * (x * x)
	li $t2, 4
	mul $t1, $t1, $t2		# $t1 = x * 4
	add $t0, $t0, $t1		# $t0 = ((a + 13) * (x * x)) + (x * 4)
	li $t3, 5
	div $t0, $t0, $t3		# $t0 = (((a + 13) * (x * x)) + (x * 4)) / 5

	li $v0, 4
	la $a0, R
	syscall					# display y= message

	li $v0, 1
	move $a0, $t0
	syscall					# display the calculated result

	li $v0, 4
	la $a0, R4
	syscall					# not sure if needed, but prints the
							# register the result is in
	li $v0, 10
	syscall					# exit program
