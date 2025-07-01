/* assembly to compute the key powers */

#include "tbrwhash1305_macro.h"
		
	.p2align 5
	.globl tbrwhash1305_keypowers
		
tbrwhash1305_keypowers:

	movq 	%rsp,%r11
	andq    $-32,%rsp
	subq 	$64,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	movq 	%rdi,56(%rsp)
	
	movq	%rdx,%rbp	

	movq    96(%rdi),%r14
	movq    104(%rdi),%r15
	
	tau_square()
	addq	$120,%rdi
	movq	%r8,0(%rdi)
	movq	%r9,8(%rdi)
	movq	%r10,16(%rdi)
	
	cmpq	$2,%rbp
	jl	.L2
	
	cmpq	$3,%rbp
	jl	.L1

.L0:
	tau_squaren()
	addq	$24,%rdi
	movq	%r8,0(%rdi)
	movq	%r9,8(%rdi)
	movq	%r10,16(%rdi)
	
	decq	%rsi
	cmpq	$1,%rsi
	jge	.L0
	
.L1:	
	movq 	56(%rsp),%rdi
	movq	%rbp,%rsi
	
	/* tau^3 */
	mul_taun_tau(5,4,0)	
	cmpq	$4,%rsi
	jl	.L2

	/* tau^5 */
	mul_taun_tau(6,4,1)
	cmpq	$5,%rsi
	jl	.L2	
		
	/* tau^6 */
	mul_taun_tau(1,4,2)
	cmpq	$6,%rsi
	jl	.L2
	
	/* tau^7 */
	mul_taun_tau(2,4,3)
			
.L2:
	movq 	0(%rsp),%r11
	movq 	8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbx
	movq 	48(%rsp),%rbp

	movq 	%r11,%rsp

	ret
