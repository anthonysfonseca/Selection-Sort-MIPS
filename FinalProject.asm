# s0 - array
# s1 - sorted array
# s2 - number of elements
# t0 - temp storage for read int
# t1 - loop counter
# t2 - temp storage for current element
# t3 - element counter + 1
# t4 - element that the current element is being compared to

.macro printString (%string) # prints the specified string
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro getInt # reads an integer from the user and stores it in $t0
	li $v0, 5
	syscall
	move $t0, $v0 # $t0 is where the read value is stored until it can be stored in the array
.end_macro

.macro printInt ($num) # prints the number stored in the specified register
	li $v0, 1
	move $a0, $num
	syscall
.end_macro 

.data
#numOfElements: .space 4 # Don't need this code as of now but leaving it just in case it's helpful in the future. It stores the number of array elements as a label.
numOfElementsPrompt: .asciiz "How many integers will you be entering? "
array: .space 1000
intPrompt: .asciiz "Enter integer "
intPromptCont: .asciiz ": "
printArray1: .asciiz "You entered: "
comma: .asciiz ", "
error: .asciiz "Incorrect Input. Try again.\n"

.text
main:
	printString(numOfElementsPrompt) # prompts the user to enter the number of elements they want in the array
	getInt # gets the number of array elements from the user
	blez $t0, invalid # prints an error if the user inputs 0 or a negative number
#	sw $t0, numOfElements # Don't need this code as of now but leaving it just in case it's helpful in the future. It stores the number of array elements as a label. 
	move $s2, $t0 # stores the number of elements in $s2
	addi $t1, $zero, 1 # loop counter starting at 1 so it can print the current element (e.g. starting at "Enter integer 1: " instead of "Enter integer 0: "
	la $s0, array # loads the address of the array at $s0 (Not sure if this is needed, havent' tested without)
	addi $t3, $s2, 1 # number of elements plus 1 so the loop accounts for starting at 1 instead of 0
	
getArray:
	printString(intPrompt) # prompts the user to enter the current element of the array
	printInt($t1) # prints the counter
	printString(intPromptCont) # prints ": "
	getInt # gets the current array element
	sb $t0, 0($s0) # stores the input in the array
	addi $s0, $s0, 4 # increments the base address for the next element
	addi $t1, $t1, 1 # increments the loop counter
	beq $t1, $t3, resetArrayAddress1 # moves to the next step in the code
	j getArray # restarts the loop

resetArrayAddress1: # resets the array address back to the first element
	addi $s0, $s0, -4 # decrements the base address to the previous element
	addi $t1, $t1, -1 # decrements the loop counter
	beq $t1, 1, echo # moves to the next step
	j resetArrayAddress1 # restarts the loop until the array address is back down to the first element

echo:
	printString(printArray1) # prints "You entered: " 

printArray: # loop for printing all array elements
	lb $t2, 0($s0) # loads the current array element
	printInt($t2) # prints the current array element
	addi $s0, $s0, 4 # increments the base address for the next element
	addi $t1, $t1, 1 # increments the loop counter
	beq $t1, $t3, resetArrayAddress2 # resets the address again
	printString(comma) # prints ", " but not on the last element
	j printArray # restarts the loop

resetArrayAddress2: # not really made use of right now, but possibly useful for future code when you need to start at the first element
	addi $s0, $s0, -4
	addi $t1, $t1, -1
	beq $t1, 1, EXIT
	j resetArrayAddress2

#sortArray:
#	lb $t2, 0($s0)
#	addi $s0, $s0, 4
#	lb $t4, 0($s0)
#	blt $t2, $t4, switchNum1
#	bge $t2, $t4, sortArray

#sortArrayCont:
#	addi $t1, $t1, 1
#	beq $t1, $t3, resetArrayAddress4sortArray
	
#switchNum1:
#	sb $t2, 0($s0)
#	move $t2, $t4
#	j resetArrayAddress3

#switchNum2:
	

invalid: # error when the user enters 0 or a negative number
	printString(error)
	j main

#resetArrayAddress3:
#	addi $s0, $s0, -4
#	addi $t1, $t1, -1
#	beq $t1, 1, switchNum2
#	j resetArrayAddress3

#resetArrayAddress4:
#	addi $s0, $s0, -4
#	addi $t1, $t1, -1
#	beq $t1, 1, printSortedArray
#	j resetArrayAddress4

#printSortedArray:
#	lb $t2, 0($s0)
#	printInt($t2)
#	addi $s0, $s0, 4
#	addi $t1, $t1, 1
#	beq $t1, $t3, EXIT
#	printString(comma)
#	j printSortedArray

EXIT:
	li $v0, 10
	syscall
	
	
	
