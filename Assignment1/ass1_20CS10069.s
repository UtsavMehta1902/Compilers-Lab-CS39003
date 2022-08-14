	.file	"asgn1.c"								#source file name
	.text
	.section	.rodata 							# read-only data section
	.align 8										# Enforcing alignment on the 8-byte boundary, on LC0

.LC0: 												# Label of the first f-string, in the 1st printf
	.string	"Enter the string (all lowrer case): "
.LC1: 												# Label of the second f-string, in the 1st printf
	.string	"%s"
.LC2: 												# Label of the third f-string, in the 2nd printf
	.string	"Length of the string: %d\n"
	.align 8 										# Enforcing alignment on the 8-byte boundary, on LC3
.LC3: 												# Label of the fourth f-string, in the 3rd printf
	.string	"The string in descending order: %s\n"
	.text 											# Code starts
	.globl	main 									# Makes main a global name
	.type	main, @function 						# Mentions that main is a function

main:												# main function starts
.LFB0:
	.cfi_startproc
	endbr64 										# If there is an indirect branch in 64-bit, terminate it
	pushq	%rbp 									# Save the old base pointer (rbp)
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp 								# rsp-->rbp, set new stack base pointer
	.cfi_def_cfa_register 6

	# The following segment of code(in .s) corresponds to these lines in .c
	# char str[20], dest[20];
	# int len;

	subq	$80, %rsp 								# Create space(80 bytes) for local variables(1 int variable) and arrays(2 char arrays)
	movq	%fs:40, %rax 							# get canary to prevent stack buffer overflow
	movq	%rax, -8(%rbp) 							# Points rax to M[rbp - 8] and pushes the canary to stack base pointer
	xorl	%eax, %eax 								# erase canary

	# The following segment of code(in .s) corresponds to these lines in .c
	# printf("Enter the string (all lowrer case): ");

	leaq	.LC0(%rip), %rax 						# Copy the 1st printf Label to rax memory first,
	movq	%rax, %rdi 								# Then copy the rax to the first argument (%rdi) of printf function
	movl	$0, %eax 								# point 0 to eax (eax <-- 0)
	call	printf@PLT 								# call the first printf
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# scanf("%s", str);
	leaq	-64(%rbp), %rax 						# Copies the M[rbp - 64] memory space pointer to rax
	movq	%rax, %rsi 								# Passes the above mentioned memory as the 2nd argument to scanf
	leaq	.LC1(%rip), %rax 						# Copy the 1st scanf label to rax memory first,
	movq	%rax, %rdi 								# Then copy the rax to the first argument of scanf function
	movl	$0, %eax 								# point 0 to eax (eax <-- 0)
	call	__isoc99_scanf@PLT 						# call the first scanf

	# The following segment of code(in .s) corresponds to these lines in .c
	# len = length(str);
	leaq	-64(%rbp), %rax 						# Copies the M[rbp - 64] memory space pointer to rax
	movq	%rax, %rdi 								# Then copy the rax to the first argument of length function
	call	length 									# call the length function to get the length of original string
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# printf("Length of the string: %d\n", len);
	movl	%eax, -68(%rbp)							# Copies the eax memory space pointer to M[rbp - 68]
	movl	-68(%rbp), %eax							# Copies the M[rbp - 68] memory space pointer to eax (thus, eax stores 'len')
	movl	%eax, %esi								# Passes the above mentioned memory as the 2nd argument to printf
	leaq	.LC2(%rip), %rax 						# Copy the 2nd printf label to rax memory first,
	movq	%rax, %rdi 								# Then copy the rax to the first argument of length function
	movl	$0, %eax 								# point 0 to eax (eax <-- 0)
	call	printf@PLT 								# call the second printf
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# sort(str, len, dest);
	leaq	-32(%rbp), %rdx							# Copies the M[rbp - 32] memory space pointer to rdx, which is the first argument of sort
	movl	-68(%rbp), %ecx							# Copies the M[rbp - 68] memory space pointer to ecx (thus, ecx stores 'len')
	leaq	-64(%rbp), %rax							# Copies the M[rbp - 64] memory space pointer to rax
	movl	%ecx, %esi								# Passes the above mentioned memory(ecx) as the 2nd argument to sort
	movq	%rax, %rdi								# Passes the above mentioned memory(rax) as the 3rd argument to sort
	call	sort 									# call the sort function to get the reverse-sorted string as output
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# printf("The string in descending order: %s\n", dest);
	leaq	-32(%rbp), %rax							# Copies the M[rbp - 32] memory space pointer to rax,
	movq	%rax, %rsi								# Then copy the rax to the second argument of printf function
	leaq	.LC3(%rip), %rax						# Copy the 3rd printf label to rax memory first,
	movq	%rax, %rdi								# Then copy the rax to the first argument of length function
	movl	$0, %eax								# point 0 to eax (eax <-- 0)
	call	printf@PLT								# call the third printf to print the output
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# return 0;
	movl	$0, %eax								# point 0 to eax (eax <-- 0)
	movq	-8(%rbp), %rdx							# Copies the M[rbp - 8] memory space pointer(which stored the canary) to rdx
	subq	%fs:40, %rdx							# Check for successful termination of main (return value should be 0), using segment addressing

	je	.L3											# If main is successfully terminated, jump to L3

	call	__stack_chk_fail@PLT					# Else terminate the execution

.L3:
	leave 											# rsp --> rbp, remove stack frame, pop top of the stack to rbp
	.cfi_def_cfa 7, 8
	ret 											# return, and shift the control to the return address
	.cfi_endproc

.LFE0:
	.size	main, .-main							# the size of 'main' function
	.globl	length 									# Makes length a global name
	.type	length, @function 						# Mentions that length is a function

length: 											# length function starts
.LFB1:
	.cfi_startproc
	endbr64											# If there is an indirect branch in 64-bit, terminate it
	pushq	%rbp 									# Save the old base pointer (rbp)
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp 								# rsp-->rbp, set new stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)							# Points rdi to M[rbp - 24] and stores the first argument of 'length'
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# int i;
	# for (i = 0; str[i] !='\0'; i++)
	movl	$0, -4(%rbp)							# Points 0 to M[rbp - 4], (M[rbp - 4] <-- 0), thus M[rbp - 4] stores value of i		
	jmp	.L5											# Jump to L5, unconditionally

.L6:
	addl	$1, -4(%rbp)							# i++ (M[rbp - 4] = M[rbp - 4] + 1), increment the iterator

.L5:
	movl	-4(%rbp), %eax							# Copies the M[rbp - 64] memory space pointer to eax (thus, eax stores 'i')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[i])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	testb	%al, %al								# al & al, bitwise AND of al with itself (if this value == 0 => we reach the end of string)
	jne	.L6											# If null character is not reached, jump to L6 to increment the iterator
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# return i;
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'i')
	popq	%rbp									# rbp now stores the top of stack, then stack is popped
	.cfi_def_cfa 7, 8
	ret												# return, and shift the control to the return address
	.cfi_endproc
.LFE1:
	.size	length, .-length						# the size of 'length' function
	.globl	sort 									# Makes sort a global name
	.type	sort, @function 						# Mentions that sort is a function

sort: 												# sort function starts
.LFB2:
	.cfi_startproc
	endbr64											# If there is an indirect branch in 64-bit, terminate it
	pushq	%rbp 									# Save the old base pointer (rbp)
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp 								# rsp-->rbp, set new stack base pointer
	.cfi_def_cfa_register 6

	# The following segment of code(in .s) corresponds to these lines in .c
	# int i, j;
	# char temp;
	subq	$48, %rsp 								# Create space for local variables(1 char variable and 2 int variables)
	movq	%rdi, -24(%rbp)							# Copies the rdi to M[rbp - 24] memory space pointer (thus, stores 'str' in M[rbp - 24])
	movl	%esi, -28(%rbp)							# Copies the esi to M[rbp - 28] memory space pointer (thus, stores 'len' in M[rbp - 28])
	movq	%rdx, -40(%rbp)							# Copies the rdx to M[rbp - 40] memory space pointer (thus, stores 'dest' in M[rbp - 40])
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# for(i=0; i<len; i++)
	movl	$0, -8(%rbp)							# Points 0 to M[rbp - 8], (M[rbp - 8] <-- 0), thus M[rbp - 8] stores value of i						
	jmp	.L9											# Jump to L9, unconditionally

.L13:
	# The following segment of code(in .s) corresponds to these lines in .c
	# for(j=0; j<len; j++)
	movl	$0, -4(%rbp)							# Points 0 to M[rbp - 4], (M[rbp - 4] <-- 0), thus M[rbp - 4] stores value of j	
	jmp	.L10										# Jump to L10, unconditionally

.L12:

	# The following segment of code(in .s) corresponds to these lines in .c
	# .if (str[i]<str[j])
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, rax stores 'str')
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[i])
	movzbl	(%rax), %edx							# Transfer a 0-byte extension to edx
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	movslq	%eax, %rcx								# Copies the eax to rcx, thus, make a value(eax) of 32-bit register as a value(rcx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, rax stores 'str')
	addq	%rcx, %rax								# rax = rax + rcx, adds the value at rcx to rax, and stores it at rax (thus, rax stores str[j])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	cmpb	%al, %dl								# Compare 1 byte of both eax and edx (compare s[i] & s[j])
	jge	.L11										# If s[i] >= s[j] branch to L11
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# temp = str[i];
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, eax stores 'str')
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[i])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	movb	%al, -9(%rbp)							# Copies M[rbp - 9] memory space pointer to al, store str[i] in M[rbp - 9]
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# str[i] = str[j];
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, eax stores 'str')
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[j])
	movl	-8(%rbp), %edx							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	movslq	%edx, %rcx								# Copies the edx to rcx, thus, make a value(edx) of 32-bit register as a value(rcx) of 64 bit register
	movq	-24(%rbp), %rdx							# Copies the M[rbp - 24] memory space pointer to rdx (thus, rdx stores 'str')
	addq	%rcx, %rdx								# rdx = rdx + rcx, adds the value at rcx to rdx, and stores it at rdx (thus, rdx stores str[i])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	movb	%al, (%rdx)								# Shifts value at al (=str[j]) to rdx (=str[i])
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# str[j] = temp;
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, eax stores 'str')
	addq	%rax, %rdx								# rdx = rdx + rax, adds the value at rax to rdx, and stores it at rdx (thus, rdx stores str[j])
	movzbl	-9(%rbp), %eax							# Transfer a 0-byte extension to eax
	movb	%al, (%rdx)								# Shifts value at al (=str[i]) to rdx (=str[j])

.L11:
	addl	$1, -4(%rbp)							# j++ (M[rbp - 4] = M[rbp - 4] + 1), increment the iterator

.L10:
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	cmpl	-28(%rbp), %eax							# If j<len
	jl	.L12										# branch to L12
	addl	$1, -8(%rbp)							# i++ (M[rbp - 8] = M[rbp - 8] + 1), increment the iterator

.L9:
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	cmpl	-28(%rbp), %eax							# If i<len
	jl	.L13										# branch to L13

	# The following segment of code(in .s) corresponds to these lines in .c
	# reverse(str,len,dest);
	movq	-40(%rbp), %rdx							# Copies the M[rbp - 40] memory space pointer to rdx (thus, stores 'dest' in rdx)
	movl	-28(%rbp), %ecx							# Copies the M[rbp - 28] memory space pointer to ecx (thus, stores 'len' in ecx)
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, rax stores 'str')
	movl	%ecx, %esi								# Copies value in ecx to 2nd argument to reverse (thus, esi stores 'len')
	movq	%rax, %rdi								# Copies value in rax to 1st argument to reverse (thus, rdi stores 'str')
	call	reverse 								# Call the reverse function to convert the sorted string as reverse sorted
	nop												# no operation
	leave 											# rsp --> rbp, remove stack frame, pop top of the stack to rbp
	.cfi_def_cfa 7, 8
	ret 											# return, and shift the control to the return address
	.cfi_endproc
.LFE2:
	.size	sort, .-sort							# the size of 'sort' function
	.globl	reverse 								# Makes reverse a global name
	.type	reverse, @function 						# Mentions that reverse is a function

reverse: 											# reverse function starts
.LFB3:
	.cfi_startproc
	endbr64											# If there is an indirect branch in 64-bit, terminate it
	pushq	%rbp 									# Save the old base pointer (rbp)
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp 								# rsp-->rbp, set new stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)                         # Copies the rdi to M[rbp - 24] memory space pointer (thus, stores 'str' in M[rbp - 24])
	movl	%esi, -28(%rbp)							# Copies the esi to M[rbp - 28] memory space pointer (thus, stores 'len' in M[rbp - 28])
	movq	%rdx, -40(%rbp)							# Copies the rdx to M[rbp - 40] memory space pointer (thus, stores 'dest' in M[rbp - 40])
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# for(i=0; i<len/2; i++)
	movl	$0, -8(%rbp)							# Points 0 to M[rbp - 8], (M[rbp - 8] <-- 0), thus M[rbp - 8] stores value of i
	jmp	.L15										# Jump to L15, unconditionally

.L20:

	# The following segment of code(in .s) corresponds to these lines in .c
	# for(j=len-i-1; j>=len/2; j--)
	movl	-28(%rbp), %eax							# Copies the M[rbp - 28] memory space pointer to eax (thus, eax stores 'len')
	subl	-8(%rbp), %eax							# Substracts M[rbp - 8] from eax (thus, eax -= M[rbp - 8] or len -= i)
	subl	$1, %eax								# Substracts 1 from eax (thus, eax -= 1 or len -= 1)
	movl	%eax, -4(%rbp)							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	nop												# no operation
	movl	-28(%rbp), %eax							# Copies the M[rbp - 28] memory space pointer to eax (thus, eax stores 'len')
	movl	%eax, %edx								# Copies value in eax to edx (thus, edx stores 'len')
	shrl	$31, %edx								# Right shifting edx by 31 bits (edx >> 31), since edx is 32 bits, right shifting by 31 yields the MSB
	addl	%edx, %eax								# Add value at edx to eax (eax = eax + edx, thus add 1 to eax if MSB == 1) 
	sarl	%eax									# Right shifting eax by 1 bits (eax >> 1, thus eax = len / 2)
	cmpl	%eax, -4(%rbp)							# Compare j and len => if j < len
	jl	.L18										# then branch to L18
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# .if(i==j)
	# break
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	cmpl	-4(%rbp), %eax							# Compare i and j => if i==j
	je	.L23										# then branch to L23
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# temp = str[i];
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, rax stores 'str')
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[i])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	movb	%al, -9(%rbp)							# Copies M[rbp - 9] memory space pointer to al, store str[i] in M[rbp - 9]
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# str[i] = str[j];
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, rax stores 'str')
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[j])
	movl	-8(%rbp), %edx							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	movslq	%edx, %rcx								# Copies the edx to rcx, thus, make a value(edx) of 32-bit register as a value(rcx) of 64 bit register
	movq	-24(%rbp), %rdx							# Copies the M[rbp - 24] memory space pointer to rdx (thus, rdx stores 'str')
	addq	%rcx, %rdx								# rdx = rcx + rdx, adds the value at rcx to rdx, and stores it at rdx (thus, rdx stores str[i])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	movb	%al, (%rdx)								# Shifts value at al (=str[j]) to rdx (=str[i])
	
	# The following segment of code(in .s) corresponds to these lines in .c
	# str[j] = temp;
	movl	-4(%rbp), %eax							# Copies the M[rbp - 4] memory space pointer to eax (thus, eax stores 'j')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, eax stores 'str')
	addq	%rax, %rdx								# rdx = rdx + rax, adds the value at rax to rdx, and stores it at rdx (thus, rdx stores str[j])
	movzbl	-9(%rbp), %eax							# Transfer a 0-byte extension to eax
	movb	%al, (%rdx)								# Shifts value at al (=str[i]) to rdx (=str[j])
	jmp	.L18										# Jumps to L18, unconditionally

.L23:
	nop												# no operation

.L18:
	addl	$1, -8(%rbp)							# i++ (M[rbp - 8] = M[rbp - 8] + 1), increment the iterator

.L15:
	movl	-28(%rbp), %eax							# Copies the M[rbp - 28] memory space pointer to eax (thus, eax stores 'len')
	movl	%eax, %edx								# Copies value in eax to edx (thus, edx stores 'len')
	shrl	$31, %edx								# Right shifting edx by 31 bits (edx >> 31), since edx is 32 bits, right shifting by 31 yields the MSB
	addl	%edx, %eax								# Add value at edx to eax (eax = eax + edx, thus add 1 to eax if MSB == 1) 
	sarl	%eax									# Right shifting eax by 1 bits (eax >> 1, thus eax = len / 2)
	cmpl	%eax, -8(%rbp)							# Compare i and len => if i < len
	jl	.L20										# Then branch to L20
	movl	$0, -8(%rbp)							# Points 0 to M[rbp - 8], (M[rbp - 8] <-- 0), thus M[rbp - 8] stores value of i
	jmp	.L21										# Jump to L21, unconditionally

.L22:

	# The following segment of code(in .s) corresponds to these lines in .c
	# for(i=0;i<len;i++)
    #     dest[i]=str[i];
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	movslq	%eax, %rdx								# Copies the eax to rdx, thus, make a value(eax) of 32-bit register as a value(rdx) of 64 bit register
	movq	-24(%rbp), %rax							# Copies the M[rbp - 24] memory space pointer to rax (thus, rax stores 'str')
	addq	%rdx, %rax								# rax = rax + rdx, adds the value at rdx to rax, and stores it at rax (thus, rax stores str[i])
	movl	-8(%rbp), %edx							# Copies the M[rbp - 8] memory space pointer to edx (thus, edx stores 'i')
	movslq	%edx, %rcx								# Copies the edx to rcx, thus, make a value(edx) of 32-bit register as a value(rcx) of 64 bit register
	movq	-40(%rbp), %rdx							# Copies the M[rbp - 40] memory space pointer to rdx (thus, stores 'dest' in rdx)
	addq	%rcx, %rdx								# rdx = rcx + rdx, adds the value at rcx to rdx, and stores it at rdx (thus, rdx stores dest[i])
	movzbl	(%rax), %eax							# Transfer a 0-byte extension to eax
	movb	%al, (%rdx)								# Shifts value at al (=str[i]) to rdx (=dest[i])
	addl	$1, -8(%rbp)							# i++ (M[rbp - 8] = M[rbp - 8] + 1), increment the iterator

.L21:
	
	movl	-8(%rbp), %eax							# Copies the M[rbp - 8] memory space pointer to eax (thus, eax stores 'i')
	cmpl	-28(%rbp), %eax							# If i<len
	jl	.L22										# Branch to L22

	nop												# no operation
	nop												# no operation
	popq	%rbp									# rbp now stores the top of stack, then stack is popped
	.cfi_def_cfa 7, 8
	ret												# return, and shift the control to the return address
	.cfi_endproc

.LFE3:
	.size	reverse, .-reverse						# the size of 'reverse' function
	
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
