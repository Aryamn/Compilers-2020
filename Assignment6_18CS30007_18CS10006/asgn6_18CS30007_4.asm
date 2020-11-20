	.file	"output.s"
	.section	.rodata
.LC0:
	.string	"Enter a Number\n"
.LC1:
	.string	"Factorial of the given number is : "
.LC2:
	.string	"\n"
	.text	
	.globl	main
	.type	main, @function
main: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$112, %rsp

	movq 	$.LC0, -20(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	call	printStr
	movl	%eax, -24(%rbp)
	leaq	-12(%rbp), %rax
	movq 	%rax, -32(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	readInt
	movl	%eax, -36(%rbp)
	movl	$1, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	$1, %eax
	movl 	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	movl 	%eax, -48(%rbp)
	movl	$1, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -48(%rbp)
.L2: 
	movl	-48(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jle .L4
	jmp .L5
.L3: 
	movl	-48(%rbp), %eax
	movl 	%eax, -64(%rbp)
	addl 	$1, -48(%rbp)
	jmp .L2
.L4: 
	movl 	-40(%rbp), %eax
	imull 	-48(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	movl 	%eax, -40(%rbp)
	jmp .L3
.L5: 
	movq 	$.LC1, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printStr
	movl	%eax, -80(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printInt
	movl	%eax, -88(%rbp)
	movq 	$.LC2, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	printStr
	movl	%eax, -96(%rbp)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
