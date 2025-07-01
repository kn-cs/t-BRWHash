#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "tbrwhash1305.h"
#include "tbrwhash1305_input.h"

int main() {

	FILE *fpin,*fpout;
    	char *line,*ptr,*msg;
    	size_t len;
    	ssize_t n;
    	int i,j,c,l,r,msglen;
    	uchar8 str[3],k[KEY_SIZE],m[MAX_MSG_SIZE];
    	uchar8 h[BLOCK_SIZE]={0};
    	uint64 *q,kp[MAX_KP_SIZE]={0};
    	
    	// #define SAGE
    	#ifdef SAGE    	
    	c = system("cd ./test_files; sage tbrwhash1305_t3_verify.sage; cd ..");
    	remove("./test_files/tbrwhash1305_t3_verify.sage.py");    	
    	#endif    	
    	
	format_key(k,KEY_LENGTH,"./test_files/tbrwhash1305_t3_verify_keyfile.txt");
	q = (uint64 *)k; kp[12] = q[0]; kp[13] = q[1]; kp[14] = 0;
    	
   	fpin = fopen("./test_files/tbrwhash1305_t3_verify_test_cases.txt", "r");
    	if (fpin == NULL) {
    	
    		printf("\nError opening input file of messages!\n\n");
        	exit(1);
        }    	
        	
	fpout = fopen("./test_files/tbrwhash1305_t3_verify_c_outputs.txt","w");

    	if (fpout == NULL) {
    	
    		printf("\nError opening output file!\n\n");
        	exit(1);
        }
        
	line = calloc(16500,(sizeof(char)));
	msg  = calloc(16500,(sizeof(char)));	
    	while ((n = getline(&line, &len, fpin)) != -1) {
    	
        	line[(int)n-1] = '\0';
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
        	
        	if (l > 0) {
                	r = (uint64)(log2(l));
                	tbrwhash1305_keypowers(kp,r,l);
        	}        	
        	    	
        	tbrwhash1305(h,m,kp,l);
      		q = (uint64 *)h; fprintf(fpout,"%016llx%016llx\n",q[1],q[0]);
    	}
    	fclose(fpin); fclose(fpout);
    	free(line); free(msg);
    	
    	c = system("diff ./test_files/tbrwhash1305_t3_verify_c_outputs.txt ./test_files/tbrwhash1305_t3_verify_s_outputs.txt");
    	if (c == 0) printf("\nVerification tests succeeded for all inputs!\n\n");
    	else printf("\nVerification tests failed for some or all inputs!\n\n");
    	remove("./test_files/tbrwhash1305_t3_verify_c_outputs.txt");    	    	

	return 0;
}
