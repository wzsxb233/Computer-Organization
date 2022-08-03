
.data#initialize working environment for data
   var_input:   .asciiz   "Please enter a integer:"  #ask user to input integer for prime check
   var_true_prime:   .asciiz   " is prime number. The prime number up to and including it are:" #return user that this input is prime number
   var_false_prime:   .asciiz   " is NOT prime number"   #return user that this input is not prime number
   space: .asciiz "\n"  #get some space for crowded numbers
   
.text#initialize working enviornment for text
.global main#initialize the main as global
   main:
      # ask user to input value
      li $v0, 4
      la $a0, var_input
      syscall
      
      li $v0, 5
      syscall
      
      move $t0, $v0#store input into t0
      
      li $t1, 2# Initial value as 2 for processing
      li $t3, 2# Initial value as 2 for loop2
      li $t4, 2# Initial value as 2 for loop2

      
      
      #make sure the input is bigger than 1
      blt $t0, 1, isNOTPrime
      beq $t0, 1, isNOTPrime
      beq $t0, 2, isPrime
      
      #loop check if input number greater than 2 is prime
      loop:
         beq $t1, $t0, isPrime#if the input is equal to the inial prime value, branch isPrime
         div $t0, $t1 #try divide input by number
         mfhi $t2 #move the remainder to register t2
         beq $t2, $zero, isNOTPrime
         addi $t1, $t1, 1 #if remainder is not zero, add inial value by 1
         
         b loop#continue the loop
         
      #loop to print all prime number upto and including input
      loop2:
         beq $t4, $t0, IncludedPrime#first check if our marked value t4 is already up to input, if it is, print input and end
         beq $t3, $t4, Printit#then check if marked value t4 is equal to the counting value t3, if it is, print t4, increment t4, resett3
         div $t4, $t3#divide t4 by t3
         mfhi $t5#store remanent
         beq $t5, $zero, Resetit#if remanent is zero, t4 is not prime number, increment t4 and reset t3
         addi $t3, $t3, 1 #if remainder is not zero, add inial value by 1
         b loop2#continue loop2 until t4 is equal to input number
         
         
#create label for value is prime and value is NOT prime
   isPrime:
      li $v0, 1#print input
      move $a0, $t0
      syscall
      li $v0, 4#print string for isPrime
      la $a0, var_true_prime
      syscall
      b loop2
      
   isNOTPrime:
      li $v0, 1#print input
      move $a0, $t0
      syscall
      li $v0, 4#print string for isNOTPrime
      la $a0, var_false_prime
      syscall
      
      b exitLabel#if it is not a prime, what else do we need to do other than end the program?
      
#create label for included prime number
   IncludedPrime:
      li $v0, 4#get some space
      la $a0, space
      syscall
      li $v0, 1#print the input number since it is the largest prime number we are looking for this time
      move $a0, $t0
      syscall
      b exitLabel

      
#create label for printing
   Printit:
      li $v0, 4#get some space
      la $a0, space
      syscall
      li $v0, 1#print marked value
      move $a0, $t4
      syscall
      addi $t4, $t4, 1#increment t4 since we want to look into next value
      li $t3, 2#set t3 to initial value 2 againe
      b loop2
#create label to increment t4 and reset t3 when t4 is not prime number
   Resetit:
      addi $t4, $t4, 1#increment t4 since we want to look into next value
      li $t3, 2#set t3 to initial value 2 again
      b loop2
#create exit label
   exitLabel:#end program
      li $v0, 10
      syscall   