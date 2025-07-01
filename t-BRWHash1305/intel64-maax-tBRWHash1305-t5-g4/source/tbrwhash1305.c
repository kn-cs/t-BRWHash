#include "tbrwhash1305.h"

void tbrwhash1305(uchar8 *h,const uchar8 *m,const uint64 *k,const uint64 l) {

	uint64 *p;
	
	if (l == 0) {
	
		p = (uint64 *)h;
		*p = 0; *(p+1) = 0;
		return;
	}
		
	/* 
	 *  h: output
	 *  m: input message
	 *  k: base address of key powers array
	 *  l: number of blocks
	 */	 
	tbrwhash1305_t5_maax_g4((uint64 *)h,(uint64 *)m,k,l);
}
