#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "tbrwhash1305.h"
#include "tbrwhash1305_input.h"

#include "cpucycles.h"
#define TIMINGS 524287
static long long t[TIMINGS+1];

long long get_median() {

	long long median = 0;

	for (long long i = 0;i < TIMINGS;++i)
    		t[i] = t[i+1]-t[i];
  	for (long long j = 0;j < TIMINGS;++j) {
    		long long belowj = 0;
    		long long abovej = 0;
    		for (long long i = 0;i < TIMINGS;++i) if (t[i] < t[j]) ++belowj;
    		for (long long i = 0;i < TIMINGS;++i) if (t[i] > t[j]) ++abovej;
    		if (belowj*2 < TIMINGS && abovej*2 < TIMINGS) {
      			median = t[j];
      			break;
    		}
  	}
  	return median;
}

int main() {

	FILE *fpin,*fpout;
    	char *line,*ptr,*msg;
    	size_t len;
    	ssize_t n;
    	int i,j,c,msglen;
    	float cycles;
    	uint64 l,r;
    	uchar8 str[3],k[KEY_SIZE],m[MAX_MSG_SIZE];
    	uchar8 h[BLOCK_SIZE]={0};
    	uint64 *q,kp[MAX_KP_SIZE]={0};;
    	
    	// #define SAGE
    	#ifdef SAGE     	
    	c = system("cd ./test_files; sage tbrwhash1305_t5_speed_record_test_cases.sage; cd ..");
    	remove("./test_files/tbrwhash1305_t5_speed_record_test_cases.sage.py");    	
    	#endif    	
    	   	
	format_key(k,KEY_LENGTH,"./test_files/tbrwhash1305_t5_speed_record_test_cases_keyfile.txt");
	q = (uint64 *)k; kp[3] = q[0]; kp[4] = q[1]; kp[5] = 0;
    	
   	fpin = fopen("./test_files/tbrwhash1305_t5_speed_record_test_cases.txt", "r");
    	if (fpin == NULL) {
    	
    		printf("\nError opening input file of messages!\n\n");
        	exit(1);
        }    	
        	
	fpout = fopen("./test_files/tbrwhash1305_t5_g4_speed_records.txt","w");

    	if (fpout == NULL) {
    	
    		printf("\nError opening output file!\n\n");
        	exit(1);
        }

	line = calloc(16500,(sizeof(char)));
	msg  = calloc(16500,(sizeof(char)));	
    	while ((n = getline(&line, &len, fpin)) != -1) {
    	
        	sscanf(line,"%s %d",msg,&msglen);
        	l = ((int)n-1)/32;
        	c = 0;
        	ptr = msg;
        	for (i=1;i<=l;++i) {
        	   		
        		for (j=31;j>=1;j=j-2) {
        		
        			str[0] = ptr[j-1];
        			str[1] = ptr[j];
        			m[c++] = strtol(str,NULL,16);
        		}
        		ptr = ptr + 32;
        	}        	
        	q = (uint64 *)m; q[2*l] = msglen; q[2*l+1] = 0;
        	  
      		n = msglen%8 == 0 ? msglen/8 : msglen/8+1;
      		
		if (l > 2) {
			r = (uint64)(log2(l));
			tbrwhash1305_keypowers(kp,r,l);			
		}
        	
    		for (long long i = 0;i <= TIMINGS;++i) {
      			t[i] = cpucycles();
      			tbrwhash1305(h,m,kp,l);
   		}        	
        	cycles = ((get_median())/(double)(n));
        	fprintf(fpout,"%3llu  %6.4lf", l,cycles);        	

		if (l > 2) {			
	    		for (long long i = 0;i <= TIMINGS;++i) {
	      			t[i] = cpucycles();
	      			tbrwhash1305_keypowers(kp,r,l);
	      			tbrwhash1305(h,m,kp,l);
	   		}        	
			cycles = ((get_median())/(double)(n));
        	}
        	fprintf(fpout,"  %6.4lf\n",cycles);
    	}
    	fclose(fpin); fclose(fpout);
    	free(line); free(msg);

	return 0;	
}
