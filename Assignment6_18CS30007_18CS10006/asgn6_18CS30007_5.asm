	.file	"output.s"
	.section	.rodata
.LC0:
	.string	"------------Rod Cutting Problem------------\n"
.LC1:
	.string	"Input the size of array:\n"
.LC2:
	.string	"The maximum value obtainable for rod cutting problem is:"
.LC3:
	.string	"\n"
	.text	
	.globl	max
	.type	max, @function
max: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$32, %rsp
	movq	%rdi, -16(%rbp)
	movq	%rsi, -12(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jg .L2
	jmp .L3
	jmp .L3
.L2: 
	movl	-16(%rbp), %eax
	jmp .L3
.L3: 
	movl	-12(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	max, .-max
	.globl	func
	.type	func, @function
func: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$552, %rsp
	movq	%rdi, -16(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$100, %eax
	movl 	%eax, -412(%rbp)
	movl	$0, %eax
	movl 	%eax, -416(%rbp)
	movl 	-416(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -420(%rbp)
	movl	$0, %eax
	movl 	%eax, -424(%rbp)
	movq	-424(%rbp), %rdx
	movq	%rdx, -12(%rbp)
	movl	$0, %eax
	movl 	%eax, -444(%rbp)
	movl	-444(%rbp), %eax
	movl 	%eax, -440(%rbp)
	movl	$1, %eax
	movl 	%eax, -448(%rbp)
	movl	-448(%rbp), %eax
	movl 	%eax, -432(%rbp)
.L6: 
	movl	-432(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jle .L8
	jmp .L13
.L7: 
	movl	-432(%rbp), %eax
	movl 	%eax, -456(%rbp)
	addl 	$1, -432(%rbp)
	jmp .L6
.L8: 
	movl	$0, %eax
	movl 	%eax, -460(%rbp)
	movl	-460(%rbp), %eax
	movl 	%eax, -440(%rbp)
	movl	$0, %eax
	movl 	%eax, -464(%rbp)
	movl	-464(%rbp), %eax
	movl 	%eax, -436(%rbp)
.L9: 
	movl	-436(%rbp), %eax
	cmpl	-432(%rbp), %eax
	jl .L11
	jmp .L12
.L10: 
	movl	-436(%rbp), %eax
	movl 	%eax, -472(%rbp)
	addl 	$1, -436(%rbp)
	jmp .L9
.L11: 
	movl 	-436(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -480(%rbp)
	movq	-16(%rbp), %rax
	movq 	%rax, -484(%rbp)
	movl 	-432(%rbp), %eax
	movl 	-436(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -488(%rbp)
	movl	$1, %eax
	movl 	%eax, -492(%rbp)
	movl 	-488(%rbp), %eax
	movl 	-492(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -496(%rbp)
	movl 	-496(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -500(%rbp)
	movq	-12(%rbp), %rax
	movq 	%rax, -504(%rbp)
	movl 	-484(%rbp), %eax
	movl 	-504(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -508(%rbp)
	movl 	-440(%rbp), %eax
	movq 	-440(%rbp), %rdi
movl 	-508(%rbp), %eax
	movq 	-508(%rbp), %rsi
	call	max
	movl	%eax, -512(%rbp)
	movl	-512(%rbp), %eax
	movl 	%eax, -440(%rbp)
	jmp .L10
.L12: 
	movl 	-432(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -520(%rbp)
	movq	-440(%rbp), %rdx
	movq	%rdx, -12(%rbp)
	jmp .L7
.L13: 
	movl 	-16(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -528(%rbp)
	movq	-12(%rbp), %rax
	movq 	%rax, -532(%rbp)
	movl	-532(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	func, .-func
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
	subq	$540, %rsp

	movl	$100, %eax
	movl 	%eax, -412(%rbp)
	movq 	$.LC0, -432(%rbp)
	movl 	-432(%rbp), %eax
	movq 	-432(%rbp), %rdi
	call	printStr
	movl	%eax, -436(%rbp)
	movq 	$.LC1, -440(%rbp)
	movl 	-440(%rbp), %eax
	movq 	-440(%rbp), %rdi
	call	printStr
	movl	%eax, -444(%rbp)
	leaq	-420(%rbp), %rax
	movq 	%rax, -452(%rbp)
	movl 	-452(%rbp), %eax
	movq 	-452(%rbp), %rdi
	call	readInt
	movl	%eax, -456(%rbp)
	movl	$0, %eax
	movl 	%eax, -460(%rbp)
	movl	-460(%rbp), %eax
	movl 	%eax, -416(%rbp)
.L16: 
	movl	-416(%rbp), %eax
	cmpl	-420(%rbp), %eax
	jl .L18
	jmp .L19
.L17: 
	movl	-416(%rbp), %eax
	movl 	%eax, -468(%rbp)
	addl 	$1, -416(%rbp)
	jmp .L16
.L18: 
	movl 	-416(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -472(%rbp)
	movl	$1, %eax
	movl 	%eax, -476(%rbp)
	movl 	-416(%rbp), %eax
	movl 	-476(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -480(%rbp)
	movq	-480(%rbp), %rdx
	movq	%rdx, -12(%rbp)
	jmp .L17
.L19: 
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdi
movl 	-420(%rbp), %eax
	movq 	-420(%rbp), %rsi
	call	func
	movl	%eax, -492(%rbp)
	movl	-492(%rbp), %eax
	movl 	%eax, -424(%rbp)
	movq 	$.LC2, -500(%rbp)
	movl 	-500(%rbp), %eax
	movq 	-500(%rbp), %rdi
	call	printStr
	movl	%eax, -504(%rbp)
	movl 	-424(%rbp), %eax
	movq 	-424(%rbp), %rdi
	call	printInt
	movl	%eax, -512(%rbp)
	movq 	$.LC3, -516(%rbp)
	movl 	-516(%rbp), %eax
	movq 	-516(%rbp), %rdi
	call	printStr
	movl	%eax, -520(%rbp)
	movl	$0, %eax
	movl 	%eax, -524(%rbp)
	movl	-524(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
