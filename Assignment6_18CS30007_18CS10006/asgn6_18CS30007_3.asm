	.file	"output.s"
	.section	.rodata
.LC0:
	.string	"Sum of first 9 Natural Numbers is: "
.LC1:
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
	subq	$148, %rsp

	movl	$10, %eax
	movl 	%eax, -52(%rbp)
	movl	$0, %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -60(%rbp)
	movq 	$.LC0, -72(%rbp)
	movl 	-72(%rbp), %eax
	movq 	-72(%rbp), %rdi
	call	printStr
	movl	%eax, -76(%rbp)
	movl	$0, %eax
	movl 	%eax, -80(%rbp)
	movl	-80(%rbp), %eax
	movl 	%eax, -56(%rbp)
.L2: 
	movl	$10, %eax
	movl 	%eax, -88(%rbp)
	movl	-56(%rbp), %eax
	cmpl	-88(%rbp), %eax
	jl .L4
	jmp .L5
.L3: 
	movl	-56(%rbp), %eax
	movl 	%eax, -92(%rbp)
	addl 	$1, -56(%rbp)
	jmp .L2
.L4: 
	movl 	-56(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -96(%rbp)
	movq	-56(%rbp), %rdx
	movq	%rdx, -12(%rbp)
	movl 	-56(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -104(%rbp)
	movq	-12(%rbp), %rax
	movq 	%rax, -108(%rbp)
	movl 	-60(%rbp), %eax
	movl 	-108(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -112(%rbp)
	movl	-112(%rbp), %eax
	movl 	%eax, -60(%rbp)
	jmp .L3
.L5: 
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printInt
	movl	%eax, -124(%rbp)
	movq 	$.LC1, -128(%rbp)
	movl 	-128(%rbp), %eax
	movq 	-128(%rbp), %rdi
	call	printStr
	movl	%eax, -132(%rbp)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
