# CS 2640.02
# Names: Anthony Fonseca, Ali Momennasab, Charles Trouilliere, Patrick Hoang
# Date: 4/22/23
# Objectives: 

# s0 - array
# s1 - sorted array
# s2 - number of elements
# s3 - number of elements - 1
# t0 - temp storage for read int
# t1 - loop counter
# t2 - current element
# t3 - compared element
# t4 - counter for sorted array
# t5 - counter for how far the compared element is from the current element


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

.macro resetArray
	la $s0, array
	move $t1, $zero
.end_macro

.macro print (%string)
	li $v0, 4
	.data
	step: .asciiz %string
	.text
	la $a0, step
	syscall
.end_macro

.data
#numOfElements: .space 4 # Don't need this code as of now but leaving it just in case it's helpful in the future. It stores the number of array elements as a label.
numOfElementsPrompt: .asciiz "How many integers will you be entering? "
array: .word 0:100
sortedArray: .word 0
intPrompt: .asciiz "Enter integer "
intPromptCont: .asciiz ": "
printArray1: .asciiz "You entered: "
comma: .asciiz ", "
error: .asciiz "Incorrect Input. Try again.\n"
temp: .asciiz " Code Went wrong here\n"

.text
main:
	printString(numOfElementsPrompt) # prompts the user to enter the number of elements they want in the array
	getInt # gets the number of array elements from the user
	blez $t0, invalid # prints an error if the user inputs 0 or a negative number
#	sw $t0, numOfElements # Don't need this code as of now but leaving it just in case it's helpful in the future. It stores the number of array elements as a label. 
	move $s2, $t0 # stores the number of elements in $s2
	addi $t1, $zero, 1 # loop counter starting at 1 so it can print the current element (e.g. starting at "Enter integer 1: " instead of "Enter integer 0: "
	la $s0, array # loads the address of the array at $s0
	addi $s2, $s2, 1 # number of elements plus 1 so the loop accounts for starting at 1 instead of 0
	la $s1, sortedArray
	
getArray:
	printString(intPrompt) # prompts the user to enter the current element of the array
	printInt($t1) # prints the counter
	printString(intPromptCont) # prints ": "
	getInt # gets the current array element
	sw $t0, 0($s0) # stores the input in the array
	addi $s0, $s0, 4 # increments the base address for the next element
	addi $t1, $t1, 1 # increments the loop counter
	beq $t1, $s2, resetArrayAddress1 # moves to the next step in the code
	j getArray # restarts the loop

resetArrayAddress1: # resets the array address back to the first element
	resetArray
	sub $s2, $s2, 1 # sets s2 back to the number of elements
	add $s3, $s2, $zero # number of elements - 1

echo:
	printString(printArray1) # prints "You entered: " 

printArray: # loop for printing all array elements
	lw $t2, 0($s0) # loads the current array element
	printInt($t2) # prints the current array element
	addi $s0, $s0, 4 # increments the base address for the next element
	addi $t1, $t1, 1 # increments the loop counter
	beq $t1, $s2, resetArrayAddress2 # resets the address again
	printString(comma) # prints ", " but not on the last element
	j printArray # restarts the loop

resetArrayAddress2:
	resetArray # resets $s0 to the base address of the array
	la $s1, sortedArray
	add $s1, $s1, $t4

load:
	lw $t2, 0($s0)

sort:
	lw $t2, 0($s0) # loads the current element into $t2
	add $s0, $s0, 4 # shifts the base address to the next element
	add $t1, $t1, 1 # increments the loop counter to the current place in the array
	add $t5, $t5, 4
	bge $t1, $s3, endArray
	lw $t3, 0($s0)
	blt $t3, $t2, switch
	j sort

switch:
	sw $t3, 0($s1)
	move $t5, $zero
	j sort
	
endArray:
	lw $t2, 0($s0)
	sub $s0, $s0, $t5
	sw $t2, 0($s0)
	add $t4, $t4, 4
	sub $s3, $s3, 1
	bltz $s3, printSort
	j resetArrayAddress2

invalid: # error when the user enters 0 or a negative number
	printString(error)
	j main

printSort:
	la $s1, sortedArray
	move $t0, $zero
	print("\n")
	print("Sorted array is: ") # prints specified string

printSortedArray: # loop for printing all array elements
	lw $t2, 0($s1) # loads the current array element
	printInt($t2) # prints the current array element
	addi $s1, $s1, 4 # increments the base address for the next element
	addi $t1, $t1, 1 # increments the loop counter
	beq $t1, $s2, exit # resets the address again
	printString(comma) # prints ", " but not on the last element
	j printSortedArray # restarts the loop

exit:
	li $v0, 10
	syscall
