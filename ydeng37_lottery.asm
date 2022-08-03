.data
mainpoolsize: .asciiz "Please input the size of the main pool:" #get mainpool size
mainpooldraw: .asciiz "Please input the numbers of draw for the main pool:" #get mainpool draw
secondpoolsize: .asciiz "Please input the size of the second pool:" #get second pool size
secondpooldraw: .asciiz "Please input the numbers of draw for the second pool:" #get second pool draw
odd: .asciiz "The odds are 1 in " #return the odd
Endstory: .asciiz "The program is ended" #end the program
space: .asciiz "\n" #get some space
error1message: .asciiz "the draw is bigger than or equal to the poolsize" #create error message when draw is bigger than poolsize or equal to the poolsize
.text
.globl main

main:
	# Initialize the size of the main pool
	li $v0, 4
	la $a0, mainpoolsize #prompt for mainpool size
	syscall
	li $v0, 5 #read mainpool size
	syscall
	move $s0, $v0 #store mainpool size in s3
	
	#Initialize the draw of main pool
	li $v0, 4
	la $a0, mainpooldraw #prompt for mainpool draw
	syscall
	li $v0, 5 #read mainpool draw
	syscall
	move $s1, $v0 #store mainpool draw in s4
	
	#Initialize the size of the second pool
	li $v0, 4
	la $a0, secondpoolsize #prompt for secondpool size
	syscall
	li $v0, 5 #read secondpool size
	syscall
	move $t0, $v0 #store secondpool size in t1

	#Initialize the draw of secondpool
	li $v0, 4
	la $a0, secondpooldraw #prompt for secondpool draw
	syscall
	li $v0, 5 #read secondpool draw
	syscall
	move $t1, $v0 #store secondpool draw in t2

	#get some space
	li $v0, 4
	la $a0, space
	syscall
	
	#if the pooldraw is equal to or bigger than poolsize for either pool, return error1
	bge $t1, $t0, error1#if secondpool size is equal to secondpool draw, error1
	bge $s1, $s0, error1#if mainpool size is equal to mainpool draw, error1
	
	#Subtraction process of mainpool n-k
	sub $s2, $s0, $s1#calculate n-k
	addi $s2, $s2, 1#calculate n-k+1 for further step
		
	#Subtraction process of secondpool n-k
	sub $t2, $t0, $t1#calculate n-k
	addi $t2, $t2, 1#calculate n-k+1 for further step
	
	#Initialize s7 value as 2
	li $s7, 2
	
	#Calculate Factorial for n!/k! for mainpool
	move $a0, $s0#assign mainpool size to a0
	move $a1, $s2#assign mainpool n-k+1 to a1
	jal factrl#operation for n!/k!
	move $s3, $v0#store the value
	
	#Calculate Factorial for n!/k! for secondpool
	move $a0, $t0#assign secondpool size to a0
	move $a1, $t2#assign secondpool draw to a1
	jal factrl#operation for n!/k!
	move $t3, $v0#store the value
	
	#Calculate Factorial for k! for mainpool
	move $a0, $s1#assignment mainpool draw to a0
	move $a1, $s7#assignment 2 to a1
	jal factrl#operation for k!
	move $s4, $v0#store the value
	
	#Calculate Factorial for k! for secondpool
	move $a0, $t1#assign secondpool draw to a0
	move $a1, $s7#assign 2 to a1
	jal factrl#operation for k!
	move $t4, $v0#store the value
	
	#Calculate the odd for mainpool
	divu $s5, $s3, $s4
	
	#Calculate the odd for secondpool
	divu $t5, $t3, $t4
	
	#Calculate the odd
	mul $s6, $s5, $t5
	b returnodd#return odd
	
#factorial method branching:
factrl:

	beq $a0, $a1, factrEQ#if a0 is equal to a1, set value as a0
	b factrBT2#if a0 is not equal to a1, branching to factrBT2 function for factoring between a0 and a1




factrEQ:
	move $v0, $a0#set return value as a0
	jr $ra#jump back
	
#factorial method when a0 is >2
factrBT2:		

	sw $ra, 4($sp) # save the return address 
	sw $a0, 0($sp) # save the current value of n 
	addi $sp, $sp, -8 # move stack pointer 

 
	bgt $a0, $a1, L1 # bigger than a1 , calculate n(n - 1)! 
	add $v0, $zero, 1 # n=1; n!=1 
	jr $ra # now multiply 

L1: 
	addi $a0, $a0, -1 # n = n - 1 
	jal factrBT2 # now (n - 1)! 
	
	addi $sp, $sp, 8 # reset the stack pointer 
	lw $a0, 0($sp) # fetch saved (n - 1) 
	lw $ra, 4($sp) # fetch return address 
	mul $v0, $a0, $v0 # multiply (n)*(n - 1) 
	jr $ra # return value n!


	
#label for error1
error1:
	li $v0, 4#print string for error1
	la $a0, error1message
	syscall
	b exitlabel
	
#label for returnodd
returnodd:
	li $v0, 4
	la $a0, odd#print returnodd message
	syscall
	
	li $v0, 1
	move $a0, $s6#print the odd
	syscall
	
	b exitlabel
#label for exit
exitlabel:
	li $v0, 4
	la $a0, space#get space
	syscall
	
	li $v0, 4#print exit string
	la $a0, Endstory
	syscall
	li $v0, 10#end program
	syscall   