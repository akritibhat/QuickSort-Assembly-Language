.data

dataAddr:.align 2
         .space 64   

dataName:.align 5    
        .asciiz "Joe"
        .align 5
        .asciiz "Jenny"
        .align 5
        .asciiz "Jill"
        .align 5
        .asciiz "John"
        .align 5
        .asciiz "Jeff"
        .align 5
        .asciiz "Joyce"
        .align 5
        .asciiz "Jerry"
        .align 5
        .asciiz "Janice"
        .align 5
        .asciiz "Jake"
        .align 5
        .asciiz "Jonna"
        .align 5
        .asciiz "Jack"
        .align 5
        .asciiz "Jocelyn"
        .align 5
        .asciiz "Jessie"
        .align 5
        .asciiz "Jess"
        .align 5
        .asciiz "Janet"
        .align 5
        .asciiz "Jane"

iterator: .word 0
min: .word 0
size: .word 16
pivot: .word 0

.text
main:
    la $t0, dataName    #the array
    la $t1, dataAddr
    la $t9, dataAddr    #load the pointers
    li $t2, 0        #counter 


    initDataAddr:
    beq $t2, 16, initEnd    #loop till counter reaches 16
    sw $t0, ($t1)          #point to the corresponding item in array
    addi $t0, $t0, 32    #move to the next location of item, i.e. increment location by 32 byte boundary
    addi $t1, $t1, 4    #move the pointer forward by 4 bytes
    addi $t2, $t2, 1    #counter++
    j initDataAddr
	
	initEnd:
	lw $a0, iterator #Passing starting address as input parameter
	lw $a1, size #Passing length as input parameter
	
	#jal print_mystring   
	lw $a0, iterator
	jal quick_sort #calling quick sort arguments- dataAddr, size

	jal print_mystring       
	li $v0, 10     
        li $a0, 0          
	syscall	  	

###################################################################################################
.globl quick_sort
quick_sort:

	lw $t3, min
	addu $t3,$t3,1
	ble $a1,$t3, endfunction                # if (len <=1) return;
	
	la $t0, 0($a0) #t0 stores start of array
	la $a2, 0($a0)
	la $s5, 0($a1)
	
	la $t2, 0($a1)  #t2 stores the len
	subu  $t2, $t2 , 1
	
	#la $s5, 0($a1)
	lw $t1, iterator #set $t1 to i
	lw $t3, min
	#mul $t0,$t0,4
	addu $v1,$zero, $zero #v1 stores start address of arrray
	mul  $v1, $t0, 4
	addu $v1,$t9,$v1 #adding array start point to $v1
	
	
	enter_sort: #enter function
	
	#lw $t4, pivot #initialise pivot
	addu $t4,$a0,0
	mul $t4,$t4,4
	#subu $t2,$t2,1
	
	###########################################################################################
	begin_loop_sort:
	bge $t1,$t2, exit_loop_sort #(int i=0, i< len-1) t1=i, t2 is length
	
	addu $t5,$zero, $zero #initialise t5 , t6
	addu $t6,$zero, $zero
	
	mul $t5,$t1, 4 #loggical shift of t5
	addu $t5,$v1,$t5 #t5+strt address
	
	mul $t6,$t2, 4
	addu $t6,$v1,$t6
	
   	la $a0, ($t5)
   	la $a1, ($t6)
   	
   	addu $a3,$zero,$zero
	addu $a3,$t9,$t4 #a3 stores element at pivot
	
	subu $sp,$sp,44 #quick_sort start #increasing stack size
	sw $ra, ($sp) #storing return address into stack	
	sw $a0, 8($sp)
	sw $a1, 12($sp)
   	sw $a3, 16($sp)
   	sw $t1, 24($sp)
   	sw $t5, 28($sp)
   	sw $t6, 32($sp)
   	sw $t2, 36($sp)
   	#sw $t4, 40($sp)
   	#################
    	jal str_lt #if (str_lt( a[i], a[len-1] , i++)
    	#################
    	
    	lw $ra, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a3, 16($sp)
	lw $t1, 24($sp)
	lw $t5, 28($sp)
   	lw $t6, 32($sp)
   	lw $t2, 36($sp)
   	#lw $t4, 40($sp)
	addi $sp,$sp,44
    	
    	addi $t1,$t1,1 #(i++)
    	
    	j begin_loop_sort
    	
    	exit_loop_sort:
    	
	  
   	addu $t5,$zero, $zero
	addu $t6,$zero, $zero
	
	addu $t5,$v1,$zero
	#srl $t5, $t5, 2
	
	#mul $t6,$t4, 2
	addu $t5,$t5,$t4
	subu $t5,$t5,4
   	#lw $a0, 0($t5)
   	#lw $a1, 0($t6)
   	
   	subu $sp,$sp,44 #quick_sort start #increasing stack size
	sw $ra, ($sp) #storing return address into stack	
	sw $a0, 8($sp)
	sw $a1, 12($sp)
   	sw $a3, 16($sp)
   	sw $t1, 24($sp)
   	sw $t5, 28($sp)
   	sw $t6, 32($sp)
   	sw $t2, 36($sp)
   	sw $t4, 40($sp)
   	#div $t4,$t4,4'
   	addu $a0,$t9,$t4 
   #	lw $a0, ($t4)
   	
	jal swap_str_ptrs2 #swap_str_ptrs(&a[pivot], &a[len - 1]);
	
	lw $ra, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a3, 16($sp)
	lw $t1, 24($sp)
	lw $t5, 28($sp)
   	lw $t6, 32($sp)
   	lw $t2, 36($sp)
   	lw $t4, 40($sp)
	addi $sp,$sp,44
	
	la $a0, 0($t0)
	divu $t4,$t4,4
	#subu $t4,$t4,$a0
	move $a1, $t4 
	#subu $t4,$t4,$a2
	subu $a1,$a1,$a0
	
	la $a0,($a2)
	#subu $a1,$a1,$a0
	
	subu $sp,$sp,48 #quick_sort start #increasing stack size
	sw $ra, ($sp) #storing return address into stack	
	sw $a0, 8($sp)
	sw $a1, 12($sp)
   	sw $a3, 16($sp)
   	sw $t1, 24($sp)
   	sw $t5, 28($sp)
   	sw $t6, 32($sp)
   	sw $t2, 36($sp)
   	sw $t4, 40($sp)
   	sw $s5, 44($sp)
   	
	
	jal quick_sort #quick_sort(a, pivot);
	
	lw $ra, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a3, 16($sp)
	lw $t1, 24($sp)
	lw $t5, 28($sp)
   	lw $t6, 32($sp)
   	lw $t2, 36($sp)
   	lw $t4, 40($sp)
   	lw $s5, 44($sp)
   	
   	subu $t4,$t4,$a2
   	
	addi $sp,$sp,48
	
	#addu $a0,$a1,1
	addu $a0,$a0,$t4
	subu $a1,$s5,$t4
	subu $a1,$a1,1
	addu $a0,$a0,1
	#subu $a1,$a1,$t4
	
	
	#subu $a1,$a1,1
	#addu $a1,$a1,$a2
	
	subu $sp,$sp,48 #quick_sort start #increasing stack size
	sw $ra, ($sp) #storing return address into stack	
	sw $a0, 8($sp)
	sw $a1, 12($sp)
   	sw $a3, 16($sp)
   	sw $t1, 24($sp)
   	sw $t5, 28($sp)
   	sw $t6, 32($sp)
   	sw $t2, 36($sp)
   	sw $t4, 40($sp)
   	sw $s5, 44($sp)
	
	
	jal quick_sort  #quick_sort(a + pivot + 1, len - pivot - 1);
	
	lw $ra, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a3, 16($sp)
	lw $t1, 24($sp)
	lw $t5, 28($sp)
   	lw $t6, 32($sp)
   	lw $t2, 36($sp)
   	lw $s5, 44($sp)
   	lw $t4, 40($sp)
	addi $sp,$sp,48
	
    	jr $ra
    	
str_lt:  

	la $t6,($a0)  #str_lt start for byte by byte comparison	200.	    add $t5,$zero,$a0  #str_lt start for byte by byte comparison
	la $t7,($a1)	
	
	lw $t5, ($t6)		
	lw $t6, ($t7)
  
  	# add $t7,$zero,$a3
    	lw $v0,0($a3)
    
    #la $t5, ($a0)
    #la $t6, ($a1)

loop:  
    	lb $t3($t6)         #loop  #load a byte from each string  
    	lb $t7($t5)  
    	beqz $t7,checkt2 
    	beqz $t3,missmatch    #str1 end  
     
    slt $t8,$t3,$t7
    slt $s0,$t7,$t3    #compare two bytes  
    slt $s0,$t8,$s0
    	
    bnez $s0,sort_swap #if $t9 is not equal to zero, swap strings

    bnez $t8,missmatch  
    addi $t5,$t5,1      #t5 points to the next byte of str1  
    addi $t6,$t6,1  
    j loop  
		
missmatch:   
    #addi $v0,$zero,1  #enter mismatch loop
    j endfunction  
checkt2:  
    beqz $t3,missmatch  
     j sort_swap
    add $v0,$zero,$zero  

endfunction:  
    jr $ra
	
sort_swap:
	#sll $t6,$t4, 2
    	#addu $t6,$t6, $t0
    	#lw $a1, 0($t6)
    	#add $a0,$zero,$t5  
   	add $a1,$zero,$v0
  
    	#addi $t4,$t4,4
    	j swap_str_ptrs

swap_str_ptrs:
	lw  $t7, 0($a0)
	lw  $t6, 0($a3)
	lw  $t5, 0($a3)
	
	sw   $t5, ($a0)
	sw   $t7, ($a3)
	addi $t4,$t4,4
	j endfunction 
	
swap_str_ptrs2:
	lw  $t7, 0($a0)
	lw  $t6, 0($a1)
	lw  $t5, 0($a1)
	
	sw   $t5, ($a0)
	sw   $t7, ($a1)
	#sw   $t6, 0($t7)
	jr $ra 
	
print_mystring:
	lw $t1, iterator #iterator for looping
	lw $t2, size
	
	begin_loop:
	bge $t1,$t2, exit_loop
	sll $t3,$t1, 2
	addu $t3,$t3, $t9
	
	
   	li $v0, 4
   	lw $a0, 0($t3)
    	syscall
    	
    	addi $t1,$t1,1
    	j begin_loop
    	exit_loop:
    	jr $ra
