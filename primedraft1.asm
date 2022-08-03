
.data#initialize working environment for data
   var_input:   .asciiz   "Please enter a integer:"  #ask user to input integer for prime check
   var_true_prime:   .asciiz   " is prime number" #return user that this input is prime number
   var_false_prime:   .asciiz   " is NOT prime number"   #return user that this input is not prime number
   
.text#initialize working enviornment for text
.global main#initialize the main as global
   main:
      # ask user to input value
      li $v0, 4
      la $a0, var_input
      syscall
      
      li $v0, 5
      syscall
      
      move $t0, $v0
      
      li $t1, 2# Initial value as 2 for processing
      
      #make sure the input is bigger than 1
      blt $t0, 1, isNOTPrime
      beq $t0, 1, isNOTPrime
      beq $t0, 2, isPrime
      
      #loop check if input number greater than 2 is prime
      loop:
         beq $t1, $t0, isPrime#if the input is equal to the inial prime value, branch isPrime
         div $t0, $t1 #try divide input by number
         mfhi $t2 #move the remainder to register 10
         beq $t2, $zero, isNOTPrime
         addi $t1, $t1, 1 #if remainder is not zero, add inial value by 1
         
         b loop#continue the loop
         
#create label for value is prime and value is NOT prime
   isPrime:
      li $v0, 1
      move $a0, $t0
      syscall
      li $v0, 4
      la $a0, var_true_prime
      syscall
      
      b exitLabel
   isNOTPrime:
      li $v0, 1
      move $a0, $t0
      syscall
      li $v0, 4
      la $a0, var_false_prime
      syscall
      
      b exitLabel
#create exit label
   exitLabel:
      li $v0, 10
      syscall   