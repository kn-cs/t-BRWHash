#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "tbrwhash1271.h"
#include "tbrwhash1271_input.h"

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

int main(int argc, char **argv) {

	FILE *fp;	
	uint64 msglen,l,n,r;
	uint64 kp[MAX_KP_SIZE]={0};
        uint64 *q;	
               
	int c;        

	uchar8 h[BLOCK_SIZE]={0};
	uchar8 k[KEY_SIZE],m[MAX_MSG_SIZE];
	
	if (argc != 2) { 
		printf("\nMissing message length as input. Aborting!\n\n" );
		exit(1);
	}
	msglen = atoi(argv[1]);
	if (msglen < 0 || msglen > MAX_MSG_LENGTH) {
		printf("\nInvalid message length. Aborting!\n\n" );
		exit(1);
	}
	
	generate_key(KEY_LENGTH,"./test_files/tbrwhash1271_t5_speed_keyfile.txt");
	format_key(k,KEY_LENGTH,"./test_files/tbrwhash1271_t5_speed_keyfile.txt");
	
	generate_msg(msglen,"./test_files/tbrwhash1271_t5_speed_msgfile.txt");
	format_msg(m,msglen,"./test_files/tbrwhash1271_t5_speed_msgfile.txt");
	
	l = msglen / BLOCK_LENGTH; r = msglen % BLOCK_LENGTH; 	
	if (r > 0) l = l + 1;
	
     	c = BLOCK_SIZE*l;
     	q = (uint64 *)(m+c); q[0] = msglen; q[1] = 0;	
   	
	q = (uint64 *)k; kp[2] = q[0]; kp[3] = q[1];
        if (l > 0) {

                r = (uint64)(log2(l));
                tbrwhash1271_keypowers(kp,r,l);
        }
        
        // #define SAGE
        #ifdef SAGE
        tbrwhash1271(h,m,kp,l);        
	fp = fopen("./test_files/tbrwhash1271_t5_speed_c_output.txt","w");
    	if (fp == NULL) {
    	
    		printf("\nError opening output file!\n\n");
        	exit(1);
        }                
        q = (uint64 *)h; fprintf(fp,"%016llx%016llx\n",q[1],q[0]);
        fclose(fp);        
        
        c = system("cd ./test_files; sage tbrwhash1271_t5_speed.sage; cd ..");        
    	c = system("diff ./test_files/tbrwhash1271_t5_speed_c_output.txt ./test_files/tbrwhash1271_t5_speed_s_output.txt");
    	if (c == 0) printf("\nVerification test succeeded for the given input!\n");
    	else printf("\nVerification test failed for the given input!\n"); 
    	remove("./test_files/tbrwhash1271_t5_speed_s_output.txt");
    	remove("./test_files/tbrwhash1271_t5_speed.sage.py");    	
    	#endif        
        
     	printf("\nComputing CPU-cycles...\n\n");	
	n = msglen%8 == 0 ? msglen/8 : msglen/8+1;
	if (msglen == 0) n = 1;
	
    	for (long long i = 0;i <= TIMINGS;++i) {
      		t[i] = cpucycles();
      		tbrwhash1271(h,m,kp,l);
   	}	
   	printf("CPU-cycles per byte for computing tbrwhash1271(t=5,g=4) using maax instructions on a message of length %llu bits: %6.4lf\n\n", msglen,((get_median())/(double)(n)));

    	for (long long i = 0;i <= TIMINGS;++i) {
      		t[i] = cpucycles();
      		tbrwhash1271_keypowers(kp,r,l);
      		tbrwhash1271(h,m,kp,l);
   	}	
   	printf("CPU-cycles per byte for computing tbrwhash1271(t=5,g=4) using maax instructions on a message of length %llu bits including time for computing key-powers: %6.4lf\n\n", msglen,((get_median())/(double)(n)));	
   	
    	remove("./test_files/tbrwhash1271_t5_speed_c_output.txt");
    	remove("./test_files/tbrwhash1271_t5_speed_keyfile.txt"); 
    	remove("./test_files/tbrwhash1271_t5_speed_msgfile.txt");   	
	
	return 0;
}
