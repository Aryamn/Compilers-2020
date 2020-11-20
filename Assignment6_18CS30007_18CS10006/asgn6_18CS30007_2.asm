	.file	"output.s"
	.section	.rodata
.LC0:
	.string	"Input first integer\n"
.LC1:
	.string	"Input second integer\n"
.LC2:
	.string	"Sum of numbers is \n"
.LC3:
	.string	"\n"
.LC4:
	.string	"Difference of numbers is \n"
.LC5:
	.string	"\n"
	.text	
	.globl	find_sum
	.type	find_sum, @function
find_sum: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$40, %rsp
	movq	%rdi, -16(%rbp)
	movq	%rsi, -12(%rbp)
	movl 	-16(%rbp), %eax
	movl 	-12(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -16(%rbp)
	movl	-16(%rbp), %eax
	movl 	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	find_sum, .-find_sum
	.globl	find_diff
	.type	find_diff, @function
find_diff: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$40, %rsp
	movq	%rdi, -16(%rbp)
	movq	%rsi, -12(%rbp)
	movl 	-16(%rbp), %eax
	movl 	-12(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -16(%rbp)
	movl	-16(%rbp), %eax
	movl 	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	find_diff, .-find_diff
	.globl	main
	.type	main, @function
main: 
.LFB2:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$152, %rsp

	movq 	$.LC0, -32(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printStr
	movl	%eax, -36(%rbp)
	leaq	-12(%rbp), %rax
	movq 	%rax, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	readInt
	movl	%eax, -48(%rbp)
	movq 	$.LC1, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
	leaq	-16(%rbp), %rax
	movq 	%rax, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	readInt
	movl	%eax, -64(%rbp)
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rsi
	call	find_sum
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -20(%rbp)
	movq 	$.LC2, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	call	printStr
	movl	%eax, -84(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	call	printInt
	movl	%eax, -92(%rbp)
	movq 	$.LC3, -96(%rbp)
	movl 	-96(%rbp), %eax
	movq 	-96(%rbp), %rdi
	call	printStr
	movl	%eax, -100(%rbp)
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rsi
	call	find_diff
	movl	%eax, -108(%rbp)
	movl	-108(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movq 	$.LC4, -116(%rbp)
	movl 	-116(%rbp), %eax
	movq 	-116(%rbp), %rdi
	call	printStr
	movl	%eax, -120(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	printInt
	movl	%eax, -124(%rbp)
	movq 	$.LC5, -128(%rbp)
	movl 	-128(%rbp), %eax
	movq 	-128(%rbp), %rdi
	call	printStr
	movl	%eax, -132(%rbp)
	movl	$0, %eax
	movl 	%eax, -136(%rbp)
	movl	-136(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
