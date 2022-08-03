.data
    str: .asciiz "You've earned an A+!" #I am going to cry if I got A+!
    buffer: .space 28 #this is the buffer size
    error1: .asciiz "Stack Overflow" #Stack Overflowed! Exit
.text
    li $v0,8 #read string
    la $a0, buffer #load byte space into address
    li $a1, 28 #allocate the buffer size
    move $t0,$a0 #move the string to t0
    syscall
    
    move $a0, $t0 #move byte space back into the argument register
    jal print #jump to print
    sb $t2, 0($t4)#store t2 into memory address (sp+0)
    li $v0, 10 #end the program
    syscall
    
    print:
    	addi $sp, $sp, -20 #allocate 20 byte for stack pointer
    	sw $ra, 16($sp) #save the return address
    	sw $a0, 12($sp) #save the argument
    	
    	addi $t4, $sp, 0 #save the stack pointer's address
    	addi $t5, $sp, 20#save the max stack pointer value
    	la $t1, ($a0) #load a0 as address in t1
    	
    	load_str:
	    lbu $t2, ($t1) #load t1 as unsigned byte into t2
	    slti $t3, $t2, 1 #set t3 as 1 if t2 is smaller than 1, otherwise t3 is 0
	    beq $t2, 48, null #if t2 is equal to 48, branch to null 
	    
	    resume:
	    	beq $t4, $t5, errorexit
    	    	sb $t2, 0($t4) #store t2 into memory address (sp+0)
    	    	addi $t4, $t4, 1 #add 1 to t4
    	    	addi $t1, $t1, 1 #add 1 to t1
    	    	bne $t3, 1, load_str #if t3 is not equal to 1 branch to load_str
    	
    	    li $v0, 4 #print the string
    	    syscall
    
    	    lw $ra 16($sp) #load return address
    	    lw $a0 12($sp) #load argument
    	    jr $ra #jump back
    		
    	    null:
    		addi $t2, $t2, -48 # if t2 = 48, set t2 to 0
    		j resume #jump back to resume

errorexit:
   la $a0, error1#print error message
   li $v0, 4
   syscall
   
   li $v0, 10#end program
   syscall
print_a:
    la $a0, str #print the ultimate message
    li $v0, 4
    syscall
