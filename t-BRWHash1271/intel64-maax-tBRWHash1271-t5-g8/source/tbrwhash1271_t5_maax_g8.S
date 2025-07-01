/* assembly to compute tbrwhash1271 using t = 5, g = 8  */

#include "tbrwhash1271_macro.h"
	
	.p2align 5
	.globl tbrwhash1271_t5_maax_g8
	 
tbrwhash1271_t5_maax_g8:

	movq 	%rsp,%r11
	andq    $-32,%rsp
	subq 	$672,%rsp 

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	
	movq 	%rdi,56(%rsp)
	movq 	%rdx,64(%rsp)
	
	movq    %rdx,%rdi
	
	xorq 	%rdx,%rdx
	movq	%rcx,%rax
	movq	$32,%rbx
	divq	%rbx

	movq	%rax,72(%rsp)
	movq	%rdx,80(%rsp)

	popcnt	%rax,%rcx
	movq	%rcx,88(%rsp)

	cmpq	$0,%rax
	je	.L1
	
	leaq	216(%rsp),%rax
	movq	%rax,96(%rsp)

	movq	$1,%rax
	movq	%rax,104(%rsp)

/* brw computation */	
	
.LBRW:
	movq	64(%rsp),%rdi
	
	brw_add_block1(0,4,%r12,%r13)
	brw_add_block2(1,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(2,%r8,%r9,%r10,%r11,%rax)
	brw_reduce_4l()
	brw_add_block2(3,6,%r14,%r15)
	brw_mul(%r8,%r9)
	brw_store_temp(120)
	
	brw_add_block1(4,4,%r12,%r13)
	brw_add_block2(5,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(6,%r8,%r9,%r10,%r11,%rax)
	movq	zero(%rip),%r12
	brw_add_temp(120)
	brw_reduce_5l()
	brw_reduce_4l()
	brw_add_block2(7,7,%r14,%r15)
	brw_mul(%r8,%r9)
	brw_store_temp(120)
	
	brw_add_block1(8,4,%r12,%r13)	
	brw_add_block2(9,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(10,%r8,%r9,%r10,%r11,%rax)
	brw_reduce_4l()
	brw_add_block2(11,6,%r14,%r15)
	brw_mul(%r8,%r9)
	brw_store_temp(152)	
	
	brw_add_block1(12,4,%r12,%r13)
	brw_add_block2(13,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(14,%r8,%r9,%r10,%r11,%rax)
	movq	zero(%rip),%r12
	brw_add_temp(120)
	brw_add_temp(152)
	brw_reduce_5l()
	brw_reduce_4l()
	brw_add_block2(15,8,%r14,%r15)
	brw_mul(%r8,%r9)
	brw_store_temp(120)
	
	brw_add_block1(16,4,%r12,%r13)
	brw_add_block2(17,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(18,%r8,%r9,%r10,%r11,%rax)
	brw_reduce_4l()
	brw_add_block2(19,6,%r14,%r15)
	brw_mul(%r8,%r9)
	brw_store_temp(152)
	
	brw_add_block1(20,4,%r12,%r13)
	brw_add_block2(21,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(22,%r8,%r9,%r10,%r11,%rax)
	movq	zero(%rip),%r12
	brw_add_temp(152)
	brw_reduce_5l()	
	brw_reduce_4l()
	brw_add_block2(23,7,%r14,%r15)	
	brw_mul(%r8,%r9)
	brw_store_temp(152)
	
	brw_add_block1(24,4,%r12,%r13)
	brw_add_block2(25,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(26,%r8,%r9,%r10,%r11,%rax)
	brw_reduce_4l()
	brw_add_block2(27,6,%r14,%r15)
	brw_mul(%r8,%r9)
	brw_store_temp(184)	
	
	brw_add_block1(28,4,%r12,%r13)
	brw_add_block2(29,5,%r14,%r15)
	brw_mul(%r12,%r13)
	brw_add_block3(30,%r8,%r9,%r10,%r11,%rax)
	movq	zero(%rip),%r12
	brw_add_temp(120)
	brw_add_temp(152)
	brw_add_temp(184)
	
	movq	104(%rsp),%rax
	tzcnt	%rax,%rcx
	
	movq	%rcx,112(%rsp)
	cmp	$0,%rcx
	je	.LPUSH

	movq	$0,%rcx	
	movq	96(%rsp),%rdi
	
.LPOP0:
	brw_stack_add_top()
	subq	$32,%rdi
	
	incq	%rcx
	cmpq	112(%rsp),%rcx
	jl	.LPOP0
	
	movq	%rdi,96(%rsp)
	
.LPUSH:	
	brw_reduce_5l()	
	brw_reduce_4l()

	movq	$5,%rdi
	addq	112(%rsp),%rdi
	imul	$16,%rdi,%rdi
	addq	64(%rsp),%rdi
	
	brw_add_block1(31,4,%r14,%r15)
	brw_mul(%r8,%r9)
	
	movq	96(%rsp),%rdi
	addq	$32,%rdi
	movq	%rdi,96(%rsp)
	
	brw_stack_push()

	addq	$480,%rsi

	movq    104(%rsp),%rax
	addq    $1,%rax
	movq    %rax,104(%rsp)	
	cmpq    72(%rsp),%rax
	jle     .LBRW
	
	brw_init_zero(%r8,%r9,%r10,%r11,%r12)
	
	cmpq	$0,88(%rsp)
	je	.L0	
	
	movq	$0,%rcx
	movq	96(%rsp),%rdi
	
.LPOP1:
	brw_stack_add_top()

	subq	$32,%rdi
	
	incq	%rcx
	cmpq	88(%rsp),%rcx
	jl	.LPOP1
	
/* poly computation */	

	reduce_5limb()
	reduce_4limb()	
	reduce_2limb()	

.L0:	
	movq	64(%rsp),%rdi
	
	movq	80(%rsp),%rax
	addq	$2,%rax
	movq	%rax,80(%rsp)
	
	cmpq	$2,%rax
	jg	.LB3

	mul_taunr(80)
	madd_tau_len(0,64)	
	    
	jmp     .LF

.LB3:
	cmpq	$3,%rax
	jg	.LB4

	mul_taunr(0)
	mul_taun(0,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(15,64)

	jmp     .LF
	
.LB4:
	cmpq	$4,%rax
	jg	.LB5

	mul_taunr(96)
	mul_taun(0,0,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(15,80,%r12,%r13,%r14,%r15)
	add_product()	
	madd_tau_len(30,64)

	jmp     .LF
	
.LB5:
	cmpq	$5,%rax
	jg	.LB6

	mul_taunr(16)
	mul_taun(0,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(15,0,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(30,80,%r12,%r13,%r14,%r15)
	add_product()	
	madd_tau_len(45,64)

	jmp     .LF
	
.LB6:
	cmpq	$6,%rax
	jg	.LB7

	mul_taunr(32)
	mul_taun(0,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(15,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,0,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(45,80,%r12,%r13,%r14,%r15)
	add_product()	
	madd_tau_len(60,64)

	jmp     .LF
	
.LB7:
	cmpq	$7,%rax
	jg	.LB8

	mul_taunr(48)
	mul_taun(0,32,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(15,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,0,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(60,80,%r12,%r13,%r14,%r15)
	add_product()	
	madd_tau_len(75,64)

	jmp     .LF
	
.LB8:
	cmpq	$8,%rax
	jg	.LB9

	mul_taunr(112)
	mul_taun(0,48,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(15,32,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(30,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(60,0,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(75,80,%r12,%r13,%r14,%r15)
	add_product()	
	madd_tau_len(90,64)

	jmp     .LF	

.LB9:	
	mul_taunr(48)
	
.LH8:
	mul_taun(0,32,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(15,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,96,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(45,0,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(60,80,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(75,64,%r12,%r13,%r14,%r15)
	add_product()
	
	reduce_4limb()
	reduce_2limb()	
	add_msg_block(90)
	
	addq	$105,%rsi
	movq	80(%rsp),%rax
	subq    $8,%rax
	movq	%rax,80(%rsp)
	
	cmpq    $0,%rax	
	je      .LT
	
.LHT1:	
	cmpq    $1,%rax	
	jg      .LHT2
	
	mul_taunr(64)
	jmp	.LH1

.LHT2:
	cmpq    $2,%rax	
	jg      .LHT3
	
	mul_taunr(80)
	jmp     .LH2

.LHT3:
	cmpq    $3,%rax
	jg      .LHT4

	mul_taunr(0)
	jmp     .LH3
	
.LHT4:
	cmpq    $4,%rax
	jg      .LHT5

	mul_taunr(96)

	jmp     .LH4
	
.LHT5:
	cmpq    $5,%rax
	jg      .LHT6

	mul_taunr(16)
	jmp     .LH5
	
.LHT6:
	cmpq    $6,%rax
	jg      .LHT7

	mul_taunr(32)
	jmp     .LH6
	
.LHT7:
	cmpq    $7,%rax
	jg      .LHT8

	mul_taunr(48)
	jmp     .LH7				

.LHT8:
	mul_taunr(112)
	
	mul_taun(0,48,%r12,%r13,%r14,%r15)
	add_product()
	
	addq	$15,%rsi
		
	jmp     .LH8
	
.LH1:
	reduce_4limb()
	reduce_2limb()	
	add_msg_block(0)
		
	jmp     .LT
	
.LH2:
	mul_taun(0,64,%r12,%r13,%r14,%r15)
	add_product()
	    
	reduce_4limb()
	reduce_2limb()
	add_msg_block(15)
		
	jmp     .LT
	
.LH3:
	mul_taun(0,80,%r12,%r13,%r14,%r15)
	add_product()		
	mul_taun(15,64,%r12,%r13,%r14,%r15)
	add_product()
		
	reduce_4limb()
	reduce_2limb()	
	add_msg_block(30)
	
	jmp     .LT
	
.LH4:
	mul_taun(0,0,%r12,%r13,%r14,%r15)
	add_product()		
	mul_taun(15,80,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(30,64,%r12,%r13,%r14,%r15)
	add_product()	
		
	reduce_4limb()
	reduce_2limb()
	add_msg_block(45)
	
	jmp     .LT
	
.LH5:
	mul_taun(0,96,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(15,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,80,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(45,64,%r12,%r13,%r14,%r15)
	add_product()	
		
	reduce_4limb()
	reduce_2limb()
	add_msg_block(60)
	
	jmp     .LT
	
.LH6:
	mul_taun(0,16,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(15,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,80,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(60,64,%r12,%r13,%r14,%r15)
	add_product()	
		
	reduce_4limb()
	reduce_2limb()
	add_msg_block(75)
	
	jmp     .LT
	
.LH7:
	mul_taun(0,32,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(15,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(60,80,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(75,64,%r12,%r13,%r14,%r15)
	add_product()	
		
	reduce_4limb()
	reduce_2limb()
	add_msg_block(90)
	
.LT:
	mul_taunr(64)
	
	jmp	.LF
	
.L1:	
	movq	64(%rsp),%rdi
	
	movq	80(%rsp),%rax
	addq	$2,%rax
	movq	%rax,80(%rsp)	

	cmpq	$3,%rax
	jg	.LB03
	
	mul_taun(0,80,%r8,%r9,%r10,%r11)
	madd_tau_len(15,64)
		
	jmp     .LF

.LB03:	
	cmpq	$4,%rax
	jg	.LB04	
	
	mul_taun(0,0,%r8,%r9,%r10,%r11)
	mul_taun(15,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(30,64)
	
	jmp	.LF
	
.LB04:
	cmpq	$5,%rax
	jg	.LB05

	mul_taun(0,96,%r8,%r9,%r10,%r11)
	mul_taun(15,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(45,64)
	
	jmp	.LF
	
.LB05:
	cmpq	$6,%rax
	jg	.LB06

	mul_taun(0,16,%r8,%r9,%r10,%r11)
	mul_taun(15,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(60,64)
	
	jmp	.LF
	
.LB06:
	cmpq	$7,%rax
	jg	.LB07

	mul_taun(0,32,%r8,%r9,%r10,%r11)
	mul_taun(15,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(60,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(75,64)
	
	jmp	.LF
	
.LB07:
	cmpq	$8,%rax
	jg	.LB08

	mul_taun(0,48,%r8,%r9,%r10,%r11)
	mul_taun(15,32,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(30,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(45,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(60,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(75,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(90,64)
	
	jmp	.LF
	
.LB08:
	cmpq	$9,%rax
	jg	.LB09

	mul_taun(0,112,%r8,%r9,%r10,%r11)
	mul_taun(15,48,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(30,32,%r12,%r13,%r14,%r15)
	add_product()
	mul_taun(45,16,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(60,96,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(75,0,%r12,%r13,%r14,%r15)
	add_product()	
	mul_taun(90,80,%r12,%r13,%r14,%r15)
	add_product()
	madd_tau_len(105,64)
	
	jmp	.LF	
	
.LB09:
	brw_init_zero(%r8,%r9,%r10,%r11,%r12)
				
	jmp	.LH8
		
.LF:
	reduce_4limb()
	reduce_2limb()
	
	make_unique()

	andq	mask62(%rip),%r9
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
