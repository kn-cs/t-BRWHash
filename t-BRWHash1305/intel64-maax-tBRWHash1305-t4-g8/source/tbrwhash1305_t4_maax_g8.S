/* assembly to compute tbrwhash1305 using t = 4, g = 8  */

#include "tbrwhash1305_macro.h"
	
	.p2align 5
	.globl tbrwhash1305_t4_maax_g8
	 
tbrwhash1305_t4_maax_g8:

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

	brw_add_block1(0,4,%r8,%r11,%r12)
	brw_add_block2(1,5,%r13,%r14,%r15)
	brw_mul()
	brw_add_block3(2,%r8,%r9,%r10,%r11,%r12)	
	brw_reduce(%r11,%r12,%r9,%r10)
	brw_add_block2(3,6,%r13,%r14,%r15)
	brw_mul()
	brw_store_temp(136)
	
	brw_add_block1(4,4,%r8,%r11,%r12)
	brw_add_block2(5,5,%r13,%r14,%r15)
	brw_mul()
	brw_add_temp(136)
	brw_add_block3(6,%r8,%r9,%r10,%r11,%r12)
	brw_reduce(%r11,%r12,%r9,%r10)
	brw_add_block2(7,7,%r13,%r14,%r15)
	brw_mul()
	brw_store_temp(136)
	
	brw_add_block1(8,4,%r8,%r11,%r12)
	brw_add_block2(9,5,%r13,%r14,%r15)
	brw_mul()
	brw_add_block3(10,%r8,%r9,%r10,%r11,%r12)
	brw_reduce(%r11,%r12,%r9,%r10)
	brw_add_block2(11,6,%r13,%r14,%r15)
	brw_mul()
	brw_store_temp(176)
	
	brw_add_block1(12,4,%r8,%r11,%r12)
	brw_add_block2(13,5,%r13,%r14,%r15)
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
	
	brw_add_block1(15,4,%r13,%r14,%r15)	
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

	mul_taunr(120)
	mul_len_tau_and_add(0,96)	
	    
	jmp     .LF

.LB3:
	cmpq	$3,%rax
	jg	.LB4

	mul_taunr(0)
	mul_taun(0,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(16,96)

	jmp     .LF
	
.LB4:
	cmpq	$4,%rax
	jg	.LB5

	mul_taunr(144)
	mul_taun(0,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_len_tau_and_add(32,96)

	jmp     .LF
	
.LB5:
	cmpq	$5,%rax
	jg	.LB6

	mul_taunr(24)
	mul_taun(0,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(16,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(32,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_len_tau_and_add(48,96)

	jmp     .LF
	
.LB6:
	cmpq	$6,%rax
	jg	.LB7

	mul_taunr(48)
	mul_taun(0,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(16,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(48,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_len_tau_and_add(64,96)

	jmp     .LF
	
.LB7:
	cmpq	$7,%rax
	jg	.LB8

	mul_taunr(72)
	mul_taun(0,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(64,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_len_tau_and_add(80,96)

	jmp     .LF
	
.LB8:
	cmpq	$8,%rax
	jg	.LB9

	mul_taunr(168)
	mul_taun(0,72,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(16,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(32,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(64,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(80,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_len_tau_and_add(96,96)

	jmp     .LF	

.LB9:	
	mul_taunr(72)
	
.LH8:
	mul_taun(0,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(48,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(64,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_tau(80,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(96)
	
	addq	$112,%rsi
	movq	80(%rsp),%rax
	subq    $8,%rax
	movq	%rax,80(%rsp)
	
	cmpq    $0,%rax	
	je      .LT
	
.LHT1:	
	cmpq    $1,%rax	
	jg      .LHT2
	
	mul_taur(96)
	jmp	.LH1

.LHT2:
	cmpq    $2,%rax	
	jg      .LHT3
	
	mul_taunr(120)
	jmp     .LH2

.LHT3:
	cmpq    $3,%rax
	jg      .LHT4

	mul_taunr(0)
	jmp     .LH3
	
.LHT4:
	cmpq    $4,%rax
	jg      .LHT5

	mul_taunr(144)

	jmp     .LH4
	
.LHT5:
	cmpq    $5,%rax
	jg      .LHT6

	mul_taunr(24)
	jmp     .LH5
	
.LHT6:
	cmpq    $6,%rax
	jg      .LHT7

	mul_taunr(48)
	jmp     .LH6
	
.LHT7:
	cmpq    $7,%rax
	jg      .LHT8

	mul_taunr(72)
	jmp     .LH7				

.LHT8:
	mul_taunr(168)
	
	mul_taun(0,72,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	
	addq	$16,%rsi
		
	jmp     .LH8
	
.LH1:
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(0)
		
	jmp     .LT
	
.LH2:
	mul_tau(0,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	    
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(16)
		
	jmp     .LT
	
.LH3:
	mul_taun(0,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()		
	mul_tau(16,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()
		
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(32)
	
	jmp     .LT
	
.LH4:
	mul_taun(0,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()		
	mul_taun(16,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_tau(32,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
		
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(48)
	
	jmp     .LT
	
.LH5:
	mul_taun(0,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_tau(48,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
		
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(64)
	
	jmp     .LT
	
.LH6:
	mul_taun(0,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_tau(64,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
		
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(80)
	
	jmp     .LT
	
.LH7:
	mul_taun(0,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(16,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(64,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_tau(80,96,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
		
	reduce_5limb(%r9,%r10,%r11,%r12)
	add_msg_block(96)
	
.LT:
	mul_taur(96)
	
	jmp	.LF
	
.L2:	
	movq	64(%rsp),%rdi
	
	movq	80(%rsp),%rax
	addq	$2,%rax
	movq	%rax,80(%rsp)	

	cmpq	$3,%rax
	jg	.LB03
	
	mul_taun(0,120,%r8,%r9,%r10,%r11,%r12)
	mul_len_tau_and_add(16,96)
		
	jmp     .LF

.LB03:	
	cmpq	$4,%rax
	jg	.LB04	
	
	mul_taun(0,0,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(32,96)
	
	jmp	.LF
	
.LB04:
	cmpq	$5,%rax
	jg	.LB05

	mul_taun(0,144,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(48,96)
	
	jmp	.LF
	
.LB05:
	cmpq	$6,%rax
	jg	.LB06

	mul_taun(0,24,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(64,96)
	
	jmp	.LF
	
.LB06:
	cmpq	$7,%rax
	jg	.LB07

	mul_taun(0,48,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(64,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(80,96)
	
	jmp	.LF
	
.LB07:
	cmpq	$8,%rax
	jg	.LB08

	mul_taun(0,72,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(32,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(48,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(64,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(80,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(96,96)
	
	jmp	.LF
	
.LB08:
	cmpq	$9,%rax
	jg	.LB09

	mul_taun(0,168,%r8,%r9,%r10,%r11,%r12)
	mul_taun(16,72,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(32,48,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_taun(48,24,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(64,144,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(80,0,%r13,%r14,%r15,%rax,%rcx)
	add_product()	
	mul_taun(96,120,%r13,%r14,%r15,%rax,%rcx)
	add_product()
	mul_len_tau_and_add(112,96)
	
	jmp	.LF	
	
.LB09:
	brw_init_zero(%r8,%r9,%r10,%r11,%r12)
				
	jmp	.LH8
	
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
