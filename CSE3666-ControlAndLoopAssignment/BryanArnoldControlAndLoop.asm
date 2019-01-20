####################################################################
# Bryan Arnold
# CSE 3666
# Control and Loops Assignment
# 3/8/17
####################################################################

###############################################################################
		.data
Q1: .asciiz "Enter the first integer in the series: "   
Q2: .asciiz "Enter the number of integers in the series: "
Q3: .asciiz "Enter the offset between integers in the series: "
Series: .asciiz "The series is: "
Summation: .asciiz "The summation of the series is: "
Q4: .asciiz "Would you like to calculate another summation (Y/N)? "
nl: .asciiz "\n"
error: .asciiz "There must be a positive number of integers in the series."
Y: .asciiz "Y"
y: .asciiz "y"
N: .asciiz "N"
n: .asciiz "n"
Space: .asciiz " "
Comma: .asciiz ","
Period: .asciiz "."
buffer: .space 3	# space for character input
		.text
###############################################################################

main:

###################################
# The following load the accepted
# character inputs into registers
# for comparison of the user later.
###################################

	lb $t8, Y  
	lb $t7, y
	lb $t6, N
	lb $t5, n

######################################
# Asks user for the beginning integer
# of the series and the number of
# integers in the series. Gets user
# input for the prior.
######################################

	li $v0, 4
	la $a0, Q1	
	syscall

	li $v0, 5
	syscall
	move $t0, $v0

	li $v0, 4
	la $a0, Q2
	syscall

	li $v0, 5
	syscall
	move $t1, $v0

##############################################
# If the number of integers in the series
# is equal or less than 0, notifies the user
# and asks if they wish to try again.
##############################################

	blez $t1, Number_Error

###############################################
# Asks user for the offset between each integer
# in the series. Also displays the initial
# series notification.
###############################################

	li $v0, 4
	la $a0, Q3
	syscall

	li $v0, 5
	syscall
	move $t2, $v0

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, Series
	syscall

	li $t3, 1  # counter for loop
	li $t4, 0  # the summation of the series

loop: bgt $t3, $t1, endLoop		# for loop

	li $v0, 1
	move $a0, $t0
	syscall

	blt $t3, $t1, comma 	# to add commas between integers in the series
	beq $t3, $t1, period 	# to add a period after the last integer in the series

##############################################
# A continuation of the loop after
# the commas and period are accounted
# for. Holds the incrementing of the
# counter, adding spaces between integers,
# adding to the summation, and the addition
# of the offset between integers.
###############################################

continue: 

	li $v0, 4
	la $a0, Space
	syscall

	add $t4, $t4, $t0
	add $t0, $t0, $t2
	addi $t3, $t3, 1

	j loop 	# returns to loop

comma:

	li $v0, 4
	la $a0, Comma
	syscall

	j continue 	# returns to continue

period:

	li $v0, 4
	la $a0, Period
	syscall

	j continue 	# returns to continue

####################################################
# Displays the summation of the series the user
# created then asks the user if they would like to
# run the program again or not.
####################################################

endLoop:

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, Summation
	syscall

	li $v0, 1
	move $a0, $t4
	syscall

	li $v0, 4
	la$a0, Period
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, Q4
	syscall

	li $v0, 12
	syscall
	move $t9, $v0

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	beq $t9, $t8, main
	beq $t9, $t7, main
	beq $t9, $t6, end
	beq $t9, $t5, end

###########################################
# If the number of integers in the series
# requested is not positive, tell the user
# and ask them if they'd like to run the
# program again.
###########################################

Number_Error:

	li $v0, 4
	la $a0, error
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, Q4
	syscall

	li $v0, 12
	syscall
	move $t9, $v0

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	beq $t9, $t8, main
	beq $t9, $t7, main
	beq $t9, $t6, end
	beq $t9, $t5, end

######################
# Terminates program.
######################

end:

	li $v0, 10
	syscall