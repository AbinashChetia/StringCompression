# Author: Abinash Chetia
# Dated: 04/03/2021

.data
str1: .asciiz "Enter an input string with less than 40 characters and only containing a-z or A-Z: "
str2: .asciiz "\nCompressed string: "
errStr: .asciiz "\nError: Invalid input.\n"
inputString: .space 41
comprsdString: .space 41

.text

li $s1, 10			# load value 10 in $s1

li $v0,4
la $a0,str1
syscall				# print str1

li $v0,8
la $a0,inputString
li $a1,41
syscall				# take string input in inputString space upto 41 characters

jal chkStr			# call chkStr function
bne $v0,$s1,err			# check if output of chkStr function denotes valid or invalid input

li $v0,4
la $a0,str2
syscall				# print str2

la $a0,inputString		# load inputString address in $a0
la $a1,comprsdString		# load comprsdString address in $a1
jal comprsStr			# call comprsStr function
 
li $v0,4
la $a0,comprsdString
syscall				# print comprsdString

exit: li $v0,10
syscall				# exit program

err: li $v0,4
la $a0,errStr
syscall				# print errStr
j exit				# jump to exit

#--------Functions---------

chkStr: li $t1,65		# load ASCII of 'A' (65) in $t1        	   
li $t2,90        		# load ASCII of 'Z' (90) in $t2
li $t3,97        		# load ASCII of 'a' (97) in $t3
li $t4,122         	 	# load ASCII of 'z' (122) in $t4
li $t5,10			# load ASCII of new-line (10) in $t5
loop: lb $t6,0($a0)		# load byte from inputString to $t6
blt $t6,$t1,brnch1    		# jump to brnch1 if $t6 < $t1  
ble $t6,$t2,brnch    		# jump to brnch if $t6 <= $t2
blt $t6,$t3,brnch1    		# jump to brnch1 if $t6 < $t3
ble $t6,$t4,brnch    		# jump to brnch if $t6 <= $t4
brnch1: add $t5,$zero,$t6	# store value of $t6 in $t5
j exitFunc			# jump to exitFunc
brnch: addi $a0,$a0,1		# increment value of $a0 by 1
j loop				# jump to loop
exitFunc: move $v0,$t5		# move value of $t5 to $v0
jr $ra				# return back to main function

comprsStr: li $t1,49		# load ASCII of '1' (49) in $t1	
li $t2,49			# load ASCII of '1' (49) in $t2
lb $t3,0($a0)			# load byte from inputString to $t3
sb $t3,0($a1)			# store byte from inputString to comprsdString 
lb $t4,0($a0)			# load byte from inputString to $t4
li $t5,57			# load ASCII of '9' (57) in $t5
comprsLoop: addi $a0,$a0,1	# increment value of $a0 by 1
lb $t3,0($a0)			# load byte from inputString to $t3
beq $t3,$t4,compress		# jump to compress if $t3 == $t4
addi $a1,$a1,1			# increment value of $a1 by 1
beq $t1,$t2,bypassNum		# jump to bypassNum if $t1 == $t2
bgt $t1,$t5,multdigitNum	# jump to multdigitNum if $t1 >= $t5
sb $t1,0($a1)			# store byte from $t1 to comprsdString
retrn: addi $a1,$a1,1		# increment value of $a1 by 1
bypassNum: li $t6,10		# load 10 in $t6
beq $t3,$t6,exitComprsFunc	# jump to exitComprsFunc if $t3 == $t6
j comprsStr			# jump to comprsStr
exitComprsFunc: jr $ra		# return back to main function
compress: addi $t1,$t1,1	# increment value of $t1 by 1
j comprsLoop			# jump to comprsLoop
multdigitNum: subi $t1,$t1,48	# decrement value of $t1 by 48
li $t7,10			# load 10 in $t7
div $t1,$t7			# divide value of $t1 by that in $t7
mflo $t1			# move quotient of division to $t1
addi $t1,$t1,48			# increment value of $t1 by 48
sb $t1,0($a1)			# store byte from $t1 to comprsdString
addi $a1,$a1,1			# increment value of $a1 by 1 
mfhi $t1			# move remainder of division to $t1
addi $t1,$t1,48			# increment value of $t1 by 48
sb $t1,0($a1)			# store byte from $t1 to comprsdString
j retrn				# jump to retrn
