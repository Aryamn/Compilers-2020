	.file	"part1.c"
	.text
	.section	.rodata
.LC0:
	.string	"\nThe greater number is: %d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp 			#pushing base pointer in the stack
	movq	%rsp, %rbp 		# assigning rbp=rsp
	subq	$16, %rsp		# creating stack frame by subtracting 16 bytes space from stack pointer
	movl	$45, -8(%rbp) 		# Mem[rbp-8] = 45 (num1 = 45)
	movl	$68, -4(%rbp) 		# Mem[rbp-4] = 68 (num2 = 68)
	movl	-8(%rbp), %eax 		# eax = Mem[rbp-8] (eax = num1)
	cmpl	-4(%rbp), %eax 		# comparing eax and Mem[rbp-4] by doing eax-Mem[rbp-4](num1-num2)
	jle	.L2 			# if eax-Mem[rbp-4]<=0 jump to L2 (if num1-num2<=0 go to L2)
	movl	-8(%rbp), %eax  	# else eax = Mem[rbp-8] (eax = num1)
	movl	%eax, -12(%rbp) 	# Mem[rbp-12] = eax (greater = num1)
	jmp	.L3 			# jump to L3
.L2:
	movl	-4(%rbp), %eax  	#eax = Mem[rbp-4] (eax = num2)
	movl	%eax, -12(%rbp)		# Mem[rbp-12] = eax (greater = num2)
.L3:
	movl	-12(%rbp), %eax 	# eax = Mem[rbp-12] (eax = result)
	movl	%eax, %esi 		# esi = eax (2nd argument of printf function is eax(greater))
	leaq	.LC0(%rip), %rdi 	# rdi = .LCO (1st argument of printf function is .LCO string)
	movl	$0, %eax         	# eax = 0
	call	printf@PLT		# calling printf fucntion
	movl	$0, %eax       		# eax = 0 (Since return value is 0) 
	leave                  		# copying rbp to rsp and popping rbp from stack releasing space for local variables
	ret  				# returning  eax (eax is 0 )
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
