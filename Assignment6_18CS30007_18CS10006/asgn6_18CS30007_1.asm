	.file	"output.s"
	.section	.rodata
.LC0:
	.string	"Enter first Integer : \n"
.LC1:
	.string	"Enter Second Integer : \n"
.LC2:
	.string	"The following Arithmetic Operations are : \n"
.LC3:
	.string	"+"
.LC4:
	.string	"="
.LC5:
	.string	"\n"
.LC6:
	.string	"-"
.LC7:
	.string	"="
.LC8:
	.string	"\n"
.LC9:
	.string	"*"
.LC10:
	.string	"="
.LC11:
	.string	"\n"
.LC12:
	.string	"/"
.LC13:
	.string	"="
.LC14:
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
	subq	$280, %rsp

	movq 	$.LC0, -40(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printStr
	movl	%eax, -44(%rbp)
	leaq	-12(%rbp), %rax
	movq 	%rax, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	readInt
	movl	%eax, -56(%rbp)
	movq 	$.LC1, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	leaq	-16(%rbp), %rax
	movq 	%rax, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	readInt
	movl	%eax, -72(%rbp)
	movl 	-12(%rbp), %eax
	movl 	-16(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -20(%rbp)
	movl 	-12(%rbp), %eax
	movl 	-16(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -84(%rbp)
	movl	-84(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl 	-12(%rbp), %eax
	imull 	-16(%rbp), %eax
	movl 	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl 	-12(%rbp), %eax
	cltd
	idivl 	-16(%rbp)
	movl 	%eax, -100(%rbp)
	movl	-100(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movq 	$.LC2, -108(%rbp)
	movl 	-108(%rbp), %eax
	movq 	-108(%rbp), %rdi
	call	printStr
	movl	%eax, -112(%rbp)
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
	call	printInt
	movl	%eax, -120(%rbp)
	movq 	$.LC3, -124(%rbp)
	movl 	-124(%rbp), %eax
	movq 	-124(%rbp), %rdi
	call	printStr
	movl	%eax, -128(%rbp)
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rdi
	call	printInt
	movl	%eax, -132(%rbp)
	movq 	$.LC4, -136(%rbp)
	movl 	-136(%rbp), %eax
	movq 	-136(%rbp), %rdi
	call	printStr
	movl	%eax, -140(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	call	printInt
	movl	%eax, -144(%rbp)
	movq 	$.LC5, -148(%rbp)
	movl 	-148(%rbp), %eax
	movq 	-148(%rbp), %rdi
	call	printStr
	movl	%eax, -152(%rbp)
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
	call	printInt
	movl	%eax, -156(%rbp)
	movq 	$.LC6, -160(%rbp)
	movl 	-160(%rbp), %eax
	movq 	-160(%rbp), %rdi
	call	printStr
	movl	%eax, -164(%rbp)
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rdi
	call	printInt
	movl	%eax, -168(%rbp)
	movq 	$.LC7, -172(%rbp)
	movl 	-172(%rbp), %eax
	movq 	-172(%rbp), %rdi
	call	printStr
	movl	%eax, -176(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	printInt
	movl	%eax, -180(%rbp)
	movq 	$.LC8, -184(%rbp)
	movl 	-184(%rbp), %eax
	movq 	-184(%rbp), %rdi
	call	printStr
	movl	%eax, -188(%rbp)
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
	call	printInt
	movl	%eax, -192(%rbp)
	movq 	$.LC9, -196(%rbp)
	movl 	-196(%rbp), %eax
	movq 	-196(%rbp), %rdi
	call	printStr
	movl	%eax, -200(%rbp)
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rdi
	call	printInt
	movl	%eax, -204(%rbp)
	movq 	$.LC10, -208(%rbp)
	movl 	-208(%rbp), %eax
	movq 	-208(%rbp), %rdi
	call	printStr
	movl	%eax, -212(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -216(%rbp)
	movq 	$.LC11, -220(%rbp)
	movl 	-220(%rbp), %eax
	movq 	-220(%rbp), %rdi
	call	printStr
	movl	%eax, -224(%rbp)
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
	call	printInt
	movl	%eax, -228(%rbp)
	movq 	$.LC12, -232(%rbp)
	movl 	-232(%rbp), %eax
	movq 	-232(%rbp), %rdi
	call	printStr
	movl	%eax, -236(%rbp)
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rdi
	call	printInt
	movl	%eax, -240(%rbp)
	movq 	$.LC13, -244(%rbp)
	movl 	-244(%rbp), %eax
	movq 	-244(%rbp), %rdi
	call	printStr
	movl	%eax, -248(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printInt
	movl	%eax, -252(%rbp)
	movq 	$.LC14, -256(%rbp)
	movl 	-256(%rbp), %eax
	movq 	-256(%rbp), %rdi
	call	printStr
	movl	%eax, -260(%rbp)
	movl	$0, %eax
	movl 	%eax, -264(%rbp)
	movl	-264(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
