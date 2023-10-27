.data

enterMsg1: .string "Please enter the last four digits of your student id \n"
enterMsg2: .string "Press enter between each digit \n"
enterMsg3: .string "Enter next digit \n"
totalAddMsg: .string "\nThe sum of all the digits is "
totalMulMsg: .string "\nThe multiplication of all the digits is "
allDigits: .string "All digits that were entered "
space: .string " "
arrayDigits: .space 4 # make space for 4 digits
	
.text

addi s1, zero, 1
addi s3, zero, 3
la t0, arrayDigits # load the starting address of the array

# output the initial instruction text to the console
addi a7, zero, 4
la a0, enterMsg1
ecall

# output instruction to press enter
addi a7, zero, 4
la a0, enterMsg2
ecall

# read an integer from keyboard input and store the input
addi a7, zero, 5
ecall
add s0, zero, a0
mul s2, a0, s1
sb a0, (t0) # save the byte from a0 (the number) to t0

loop:
  # get a digit and then add it and multiply
  jal addAndMulDigit
  
  addi t0, t0, 1 # update the address for the next digit in the array
  
  sb a0, (t0) # save that byte at the updated address
  
  # subtract 1 from the counter each iteration
  addi s3, s3, -1
  
  # continue loop until the counter equals to zero
  bnez s3, loop

# reset the counter
addi s3, zero, 4

# reset address of the array to the start at t0
la t0, arrayDigits

# output the all digits message
addi a7, zero, 4
la a0, allDigits
ecall

loop2:
	jal outputNumFromArray
  	
  	addi s3, s3, -1
  	
  	bnez s3, loop2

# output the total message of addition
addi a7, zero, 4
la a0, totalAddMsg
ecall

# output the result of addition
add a0, s0, zero
addi a7, zero, 1
ecall

# output the total message of multiplication
addi a7, zero, 4
la a0, totalMulMsg
ecall

# output the result of multiplication
add a0, s2, zero
addi a7, zero, 1
ecall

# exit the program
addi a7, zero, 10
ecall


# output the text asking for the next digit to the console
# then receive the input, add to total, multiply with previous
addAndMulDigit:
  addi a7, zero, 4
  la a0, enterMsg3
  ecall

  addi a7, zero, 5
  ecall
  add s0, s0, a0

  mul s2, s2, a0

  ret

outputNumFromArray:
# make space on stack & save ra on stack
  addi sp, sp, -4
  sw ra, 0(sp)

  lb a0, (t0) # load to a0 the number from the array
	
  addi t0, t0, 1 # update the address for the next digit
  
  addi a7, zero, 1
  ecall
  
  jal outputSpace
  
# restore ra from stack & deallocate stack space   
  lw ra, 0(sp)
  addi sp, sp, 4
  
  ret
  
outputSpace:
  addi a7, zero, 4
  la a0, space
  ecall
  
  ret