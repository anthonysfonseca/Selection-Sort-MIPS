# CS 2640.02
# Names: Anthony Fonseca, Ali Momennasab, Charles Trouilliere, Patrick Hoang
# Date: 5/2/23
# Objectives: Implement the selection sort algorithm

# s0 - array
# s1 - number of elements (n)
# s2 - number of elements - 1 (n-1)
# t0 - temp storage for read int
# t1 - loop counter 
# t2 - current element
# t3 - inner loop counter ('j' in pseudocode)
# t4 - element at index j
# t5 - "minimum" element tracker ('min' in pseudocode)

# Selection sort pseudocode
# ----------------------------------------
# for (i=0 to n-1):
#	min = i;
#	for (j=i+1 to n):
#		if (arr[j] < arr[min]):
#			min = j;
#		end if
#	end for
#	swap A[i], A[min]
# end for
# ---------------------------------------

.macro printString (%string)	# Prints a string w/ a label
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro print (%string)		# Prints the string specified in the parameter
	li $v0, 4
	.data
	step: .asciiz %string
	.text
	la $a0, step
	syscall
.end_macro

.macro getInt			# Reads an int from the user and stores it in $t0
	li $v0, 5
	syscall
	move $t0, $v0			# $t0 is where the read value is stored until it can be stored in the array
.end_macro

.macro printInt ($num)		# Prints the number stored in the specified register
	li $v0, 1
	move $a0, $num
	syscall
.end_macro

.macro resetArray
	la $s0, array
	move $t1, $zero
.end_macro

.macro printArray ($arr, $length)
	li $t1, 1			# Starts counter at 1 for formatting purposes
	loop:
		lw $t2, 0($arr)
		printInt($t2)
		blt $t1, $length, comma	# If counter < arrLength: print a comma to prepare for next int (e.g., '1, 2, 3')
		j exitLoop		# Else: print last element w/o a comma & exit macro
	comma:
		print(", ")
		addi $t1, $t1, 1	# Increment counter
		addi $arr, $arr, 4	# Move to next element in array
		j loop
	exitLoop:
.end_macro

.data
numOfElementsPrompt: .asciiz "How many integers will you be entering? "
intPrompt: .asciiz "Enter integer "
array: .space 400
sortedArray: .word 0

printArray1: .asciiz "You entered: "
comma: .asciiz ", "
error: .asciiz "Incorrect Input. Try again.\n"
temp: .asciiz " Code Went wrong here\n"

.text
main:					
	printString(numOfElementsPrompt) 	# prompts the user to enter the number of elements they want in the array
	getInt 					# gets the number of array elements from the user
	blez $t0, invalid 			# prints an error if the user inputs 0 or a negative number
	move $s1, $t0 				# stores the number of elements in $s1
	addi $t1, $zero, 1 			# loop counter starting at 1 so it can print the current element 
						# (e.g. starting at "Enter integer 1: " instead of "Enter integer 0: "
	la $s0, array 				# loads the address of the array at $s0
	addi $s1, $s1, 1 			# number of elements plus 1 so the loop accounts for starting at 1 instead of 0
	
getArray:				# Populate the array with user-defined integers
	printString(intPrompt) 			# prompts the user to enter the current element of the array
	printInt($t1) 				# prints the counter
	print(": ") 				# prints ": "
	getInt					# gets the current array element
	sw $t0, 0($s0) 				# stores the input in the array
	addi $s0, $s0, 4 			# increments the base address for the next element
	addi $t1, $t1, 1 			# increments the loop counter
	beq $t1, $s1, resetArrayAddress1	# moves to the next step in the code
	j getArray 				# restarts the loop

resetArrayAddress1: 			# Resets the array address back to the first element
	resetArray
	sub $s1, $s1, 1 			# sets s2 back to the number of elements
	add $s2, $s1, $zero 			# number of elements - 1

echoArray:
	printString(printArray1) 		# prints "You entered: "
	printArray ($s0, $s1)			# traverse through array and print its current contents
	j selectionSort
	
invalid:				# Error when the user enters 0 or a negative number
	printString(error)
	j main
	
# Selection sort
selectionSort:
	resetArray				# Reset $s0 to the base address of the array
	add $s2, $s1, -1			# $s2 = n-1
	li $t1, 0				# Set i=0

	outerLoop:
		blt $t1, $s2, insideOuterLoop	# for (i=0 to n-1):
		j endSort			# i > n-1, algorithm finished
	
	insideOuterLoop:
		move $t5, $t1			# min = i
		move $t3, $t1			
		addi $t3, $t3, 1		# j=i+1
		j innerLoop
				
	innerLoop:
		sll $t2, $t5, 2	
		add $t2, $t2, $s0		
		sll $t4, $t3, 2
		add $t4, $t4, $s0
		
		lw $t2, 0($t2)			# arr[min]
		lw $t4, 0($t4)			# arr[j]
		blt $t4, $t2, innerIf		# arr[j] < arr[min]
		j endInner

	innerIf:
		move $t5, $t3
	
	endInner:
		add $t3, $t3, 1			# end of inner loop, increment (j) counter and loop as necessary
		blt $t3, $s1, innerLoop 	# for (j=i+1 to n)
	
	swap:
		sll $t2, $t1, 2			# arr[i]
		add $t2, $t2, $s0
		sll $t4, $t5, 2			# arr[min]
		add $t4, $t4, $s0
		
		lw $t0, 0($t2)			# temp = arr[i]
		lw $t6, 0($t4)			# $t6 = arr[min]
		sw $t6, 0($t2)			# Swap values directly in array
		sw $t0, 0($t4)
		
		add $t1, $t1, 1
		j outerLoop
		
endSort:	
	resetArray
	print("\nSorted array is: ")
	printArray($s0, $s1)

exit:
	li $v0, 10
	syscall
