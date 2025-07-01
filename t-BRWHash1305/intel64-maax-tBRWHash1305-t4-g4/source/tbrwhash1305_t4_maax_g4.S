/* assembly to compute tbrwhash1305 using t = 4, g = 4  */

#include "tbrwhash1305_macro.h"
	
	.p2align 5
	.globl tbrwhash1305_t4_maax_g4
	 
tbrwhash1305_t4_maax_g4:

	movq 	%rsp,%r11
	andq    $-32,%rsp
	subq 	$832,%rsp 

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	
	movq 	%rdi,56(%rsp)
	movq 	%rdx,64(%rsp)
	
	xorq 	%rdx,%rdx
	movq	%rcx,%rax
	movq	$16,%rbx
	divq	%rbx

	movq	%rax,72(%rsp)
	movq	%rdx,80(%rsp)
	
	popcnt	%rax,%rcx
	movq	%rcx,88(%rsp)

	cmpq	$0,%rax
	je	.L2
	
	leaq	216(%rsp),%rax
	movq	%rax,96(%rsp)

	movq	$1,%rax
	movq	%rax,104(%rsp)
	
/* brw computation */	
	
.LBRW:
	movq	64(%rsp),%rdi

	brw_add_block1(0,1,%r8,%r11,%r12)
	brw_add_block2(1,2,%r13,%r14,%r15)
	brw_mul()
	brw_add_block3(2,%r8,%r9,%r10,%r11,%r12)	
	brw_reduce(%r11,%r12,%r9,%r10)
	brw_add_block2(3,3,%r13,%r14,%r15)
	brw_mul()
	brw_store_temp(136)
	
	brw_add_block1(4,1,%r8,%r11,%r12)
	brw_add_block2(5,2,%r13,%r14,%r15)
	brw_mul()
	brw_add_temp(136)
	brw_add_block3(6,%r8,%r9,%r10,%r11,%r12)
	brw_reduce(%r11,%r12,%r9,%r10)
	brw_add_block2(7,4,%r13,%r14,%r15)
	brw_mul()
	brw_store_temp(136)
	
	brw_add_block1(8,1,%r8,%r11,%r12)
	brw_add_block2(9,2,%r13,%r14,%r15)
	brw_mul()
	brw_add_block3(10,%r8,%r9,%r10,%r11,%r12)
	brw_reduce(%r11,%r12,%r9,%r10)
	brw_add_block2(11,3,%r13,%r14,%r15)
	brw_mul()
	brw_store_temp(176)
	
	brw_add_block1(12,1,%r8,%r11,%r12)
	brw_add_block2(13,2,%r13,%r14,%r15)
	brw_mul()
	brw_add_temp(176)
	brw_add_block3(14,%r8,%r9,%r10,%r11,%r12)	
	brw_add_temp(136)	
	
	movq	104(%rsp),%rax
	tzcnt	%rax,%rcx
	
	movq	%rcx,112(%rsp)

	cmp	$0,%rcx
	je	.LPUSH

	movq	$0,%rcx
	movq	96(%rsp),%rdi
	
.LPOP0:
	brw_stack_add_top()

	subq	$40,%rdi
	
	incq	%rcx
	cmpq	112(%rsp),%rcx
	jl	.LPOP0
	
	movq	%rdi,96(%rsp)
	
.LPUSH:	
	brw_reduce(%r11,%r12,%r9,%r10)

	movq	$4,%rdi
	addq	112(%rsp),%rdi
	imul	$24,%rdi,%rdi
	addq	64(%rsp),%rdi
	

	brw_add_block1(15,1,%r13,%r14,%r15)	
	brw_mul()	

	movq	96(%rsp),%rdi
	addq	$40,%rdi
	movq	%rdi,96(%rsp)
	
	brw_stack_push()

	addq	$256,%rsi

	movq    104(%rsp),%rax
	addq    $1,%rax
	movq    %rax,104(%rsp)	
	cmpq    72(%rsp),%rax
	jle     .LBRW
	
.L0:
	brw_init_zero(%r8,%r9,%r10,%r11,%r12)
	
	cmpq	$0,88(%rsp)
	je	.L1
	
	movq	$0,%rcx
	movq	96(%rsp),%rdi
	
.LPOP1:
	brw_stack_add_top()

	subq	$40,%rdi
	
	incq	%rcx
	cmpq	88(%rsp),%rcx
	jl	.LPOP1
	
/* poly computation */	

.L1:	
	reduce_5limb(%r9,%r10,%r11,%r12)

	movq	64(%rsp),%rdi
	
	movq	80(%rsp),%rax
	addq	$2,%rax
	movq	%rax,80(%rsp)
	
	cmpq	$2,%rax
	jg	.LB3

	mul_taunr(48)
	mul_len_tau_and_add(0,24)	
	    
	jmp     .LF

.LB3:
	cmpq	$3,%rax
	jg	.LB4

	mul_taunr(0)
	mul_taun(0,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(16,24)

	jmp     .LF
	
.LB4:
	cmpq	$4,%rax
	jg	.LB5

	mul_taunr(72)
	mul_taun(0,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_len_tau_and_add(32,24)

	jmp     .LF	

.LB5:	
	mul_taunr(0)
	
.LH4:
	mul_taun(0,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_tau(16,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(32)
	
	addq	$48,%rsi
	movq	80(%rsp),%rax
	subq    $4,%rax
	movq	%rax,80(%rsp)
		
	cmpq    $0,%rax	
	je      .LT
	
.LHT1:	
	cmpq    $1,%rax	
	jg      .LHT2
	
	mul_taur(24)
	jmp	.LH1

.LHT2:
	cmpq    $2,%rax	
	jg      .LHT3
	
	mul_taunr(48)
	jmp     .LH2

.LHT3:
	cmpq    $3,%rax
	jg      .LHT4

	mul_taunr(0)
	jmp     .LH3

.LHT4:
	mul_taunr(72)
	
	mul_taun(0,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	
	addq	$16,%rsi
		
	jmp     .LH4
	
.LH1:
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(0)
		
	jmp     .LT
	
.LH2:
	mul_tau(0,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	    
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(16)
		
	jmp     .LT
	
.LH3:
	mul_taun(0,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()		
	mul_tau(16,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()
		
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(32)
	
.LT:
	mul_taur(24)
	
	jmp	.LF
	
.L2:	
	movq	64(%rsp),%rdi
	
	movq	80(%rsp),%rax
	addq	$2,%rax
	movq	%rax,80(%rsp)	

	cmpq	$3,%rax
	jg	.LB03
	
	mul_taun(0,48,%r8,%r9,%r10,%r11,%r12)
	mul_len_tau_and_add(16,24)
		
	jmp     .LF

.LB03:	
	cmpq	$4,%rax
	jg	.LB04	
	
	mul_taun(0,0,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(32,24)
	
	jmp	.LF
	
.LB04:
	cmpq	$5,%rax
	jg	.LB05
	
	mul_taun(0,72,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(48,24)
	
	jmp	.LF
	
.LB05:
	brw_init_zero(%r8,%r9,%r10,%r11,%r12)
				
	jmp	.LH4

.LF:
	reduce_5limb(%r9,%r10,%r11,%r12)
	reduce_3limb(%r8,%r9,%r10)
	
	make_unique()

	movq 	56(%rsp),%rdi
	movq    %r8,0(%rdi)
	movq    %r9,8(%rdi)

	movq 	0(%rsp),%r11
	movq 	8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbx
	movq 	48(%rsp),%rbp

	movq 	%r11,%rsp

	ret
