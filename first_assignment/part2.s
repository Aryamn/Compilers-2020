	.file	"part2.c"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"\nGCD of %d, %d, %d and %d is: %d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp		# push base pointer in the stack
	movq	%rsp, %rbp	# make rbp = rsp
	subq	$32, %rsp	# making stack frame of 32 bytes
	movl	$45, -20(%rbp) 	# Mem[rbp-20] = 45 (a=45)
	movl	$99, -16(%rbp)	# Mem[rbp-16] = 99 (b=99)
	movl	$18, -12(%rbp)	# Mem[rbp-12] = 18 (c=18)
	movl	$180, -8(%rbp)	# Mem[rbp-8] = 180 (d=180)
	movl	-8(%rbp), %ecx 	# ecx = Mem[rbp-8] (assinging 4th argument to the GCD4 function)
	movl	-12(%rbp), %edx	# edx = Mem[rbp-12] (assinging 3rd argument to the GCD4 function)
	movl	-16(%rbp), %esi # esi = Mem[rbp-16] (assinging 2nd argument to the GCD4 function)
	movl	-20(%rbp), %eax # eax = Mem[rbp-20] (eax = a)
	movl	%eax, %edi	# edi = eax (assigning 1st argument to the GCD4 function)
	call	GCD4            # calling GCD4 (return value is stored in eax)
	movl	%eax, -4(%rbp)	# Mem[rbp-4] = eax (result = return value of GCD4)
	movl	-4(%rbp), %edi  # edi = Mem[rbp-4]
	movl	-8(%rbp), %esi  # esi = Mem[rbp-8]
	movl	-12(%rbp), %ecx # ecx = Mem[rbp-12] (4th argument of printf is Mem[rbp-12](c))
	movl	-16(%rbp), %edx # edx = Mem[rbp-16] (3rd argument of printf is Mem[rbp-16](b))
	movl	-20(%rbp), %eax # eax = Mem[rbp-20]
	movl	%edi, %r9d      # r9 = edi (6th argument of printf is Mem[rbp-4](result))
	movl	%esi, %r8d      # r8 = esi (5th argument of printf is Mem[rbp-8](d))
	movl	%eax, %esi      # esi = eax (2nd argument of printf is Mem[rbp-20](a))
	leaq	.LC0(%rip), %rdi # rdi = .LCO string (1st argument of printf is .LCO string)
	movl	$0, %eax 	# eax = 0
	call	printf@PLT      # call printf function
	movl	$10, %edi       # edi = 10("\n" in ascii)(first argument to printf fucntion)
	call	putchar@PLT     # called printf("\n")
	movl	$0, %eax	# eax = 0(return value of main() is 0)
	leave			# copying rbp to rsp and popping rbp from stack releasing space for local variables
	ret                     # returning eax = 0
.LFE0:
	.size	main, .-main
	.globl	GCD4
	.type	GCD4, @function
GCD4:
.LFB1:
	
	pushq	%rbp  		# push base pointer in the stack
	movq	%rsp, %rbp  	# make rbp = rsp
	subq	$32, %rsp  	# making stack frame of 32 bytes
	movl	%edi, -20(%rbp) # Mem[rbp-20] = edi (mem[rbp-20] = first argument of GCD4)
	movl	%esi, -24(%rbp)	# Mem[rbp-24] = esi (mem[rbp-24] = second argument of GCD4)
	movl	%edx, -28(%rbp)	# Mem[rbp-28] = edx (mem[rbp-28] = Third argument of GCD4)
	movl	%ecx, -32(%rbp)	# Mem[rbp-32] = ecx (mem[rbp-32] = fourth argument of GCD4)
	movl	-24(%rbp), %edx	# edx = Mem[rbp-24] (edx=n2)
	movl	-20(%rbp), %eax # eax = Mem[rbp-20] (eax=n1)
	movl	%edx, %esi	# esi = edx (n2 is second argument of function GCD)
	movl	%eax, %edi	# edi = eax (n1 is first argument of function GCD)
	call	GCD 		# call GCD (return value is in eax)
	movl	%eax, -12(%rbp) # Mem[rbp-12] = eax (t1 = GCD(n1,n2))
	movl	-32(%rbp), %edx # edx = Mem[rbp-32] (edx=n4)
	movl	-28(%rbp), %eax # eax = Mem[rbp-28] (eax=n3)
	movl	%edx, %esi	# esi = edx (n4 is second argument of function GCD)	
	movl	%eax, %edi	# edi = eax (n3 is first argument of function GCD)
	call	GCD 		# call GCD (return value is in eax)
	movl	%eax, -8(%rbp)	# Mem[rbp-8] = eax (t2 = GCD(n3,n4))
	movl	-8(%rbp), %edx  # edx = Mem[rbp-8] (edx=t2)
	movl	-12(%rbp), %eax # eax = Mem[rbp-12] (edx=t1)
	movl	%edx, %esi      # esi = edx (t2 is second argument of function GCD)
	movl	%eax, %edi      # edi = eax (t1 is first argument of function GCD)
	call	GCD             # call GCD (return value is in eax)
	movl	%eax, -4(%rbp)  # Mem[rbp-4] = eax (t3 = GCD(t1,t2))
	movl	-4(%rbp), %eax  # eax = Mem[rbp-4] (eax = t3)
	leave                   # copying rbp to rsp and popping rbp from stack releasing space for local variables
	ret                     # returning t3 (t3=eax)
.LFE1:
	.size	GCD4, .-GCD4
	.globl	GCD
	.type	GCD, @function
GCD:
.LFB2:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -20(%rbp) # Mem[rbp-20] = edi (Mem[rbp-20] = first argument of GCD(num1))
	movl	%esi, -24(%rbp) # Mem[rbp-24] = esi (Mem[rbp-24] = second argument of GCD(num2))
	jmp	.L6             # jump to L6
.L7:
	movl	-20(%rbp), %eax # eax = Mem[rbp-20](eax = num1)
	cltd 			# convert %eax into quadword in %rax
	idivl	-24(%rbp)       # divide Mem[eax] by Mem[rbp-24] remainder stored in edx (edx = num1%num2)
	movl	%edx, -4(%rbp)  # Mem[rbp-4] = edx (temp = num1 % num2)
	movl	-24(%rbp), %eax	# eax = Mem[rbp-24] (eax=num2)
	movl	%eax, -20(%rbp) # Mem[rbp-20] = eax (num1=num2)
	movl	-4(%rbp), %eax  # eax = Mem[rbp-4] (eax = temp)
	movl	%eax, -24(%rbp) # Mem[rbx-24] = eax (num2 = temp)
.L6:
	movl	-20(%rbp), %eax # eax = Mem[rbp-20](eax = num1)
	cltd                    # convert %eax into quadword in %rax
	idivl	-24(%rbp)       # divide Mem[eax] by Mem[rbp-24] remainder stored in edx (edx = num1%num2)
	movl	%edx, %eax      # eax = edx ( eax = num1%num2)
	testl	%eax, %eax      # checking eax & eax (tests whether eax is 0 or not)
	jne	.L7             # jump to L7 if eax in not equal to 0
	movl	-24(%rbp), %eax # eax = Mem[rbp-24] (eax = num2)
	popq	%rbp            # pop rbp from the stack 
	ret                     # return eax (return num2)
.LFE2:
	.size	GCD, .-GCD
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
