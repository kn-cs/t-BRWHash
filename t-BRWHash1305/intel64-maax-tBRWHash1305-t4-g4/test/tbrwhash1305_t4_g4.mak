INCDRS = -I../include/

SRCFLS = ../source/tbrwhash1305_const.S 	\
	 ../source/tbrwhash1305_t4_maax_g4.S	\
	 ../source/tbrwhash1305_keypowers.S	\
	 ../source/tbrwhash1305_input.c 	\
	 ../source/tbrwhash1305.c
         
OBJFLS = ../source/tbrwhash1305_const.o 	\
	 ../source/tbrwhash1305_t4_maax_g4.o	\
	 ../source/tbrwhash1305_keypowers.o	\
	 ../source/tbrwhash1305_input.o 	\
	 ../source/tbrwhash1305.o

TESTSRC = ./tbrwhash1305_t4_g4_verify.c
TESTOBJ = ./tbrwhash1305_t4_g4_verify.o

SPEEDSRC = ./tbrwhash1305_t4_g4_speed.c
SPEEDOBJ = ./tbrwhash1305_t4_g4_speed.o

RECORDSRC = ./tbrwhash1305_t4_g4_record_speed.c
RECORDOBJ = ./tbrwhash1305_t4_g4_record_speed.o
	  
EXE1    = tbrwhash1305_t4_g4_verify
EXE2    = tbrwhash1305_t4_g4_speed
EXE3    = tbrwhash1305_t4_g4_record_speed

CFLAGS = -march=native -mtune=native -m64 -O3 -funroll-loops -fomit-frame-pointer

CC     = gcc-10
LL     = gcc-10

all:	$(EXE1) $(EXE2) $(EXE3)

$(EXE1): $(TESTOBJ) $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(TESTOBJ) -lm
	
$(EXE2): $(SPEEDOBJ) $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(SPEEDOBJ) -lm -lcpucycles
	
$(EXE3): $(RECORDOBJ) $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(RECORDOBJ) -lm -lcpucycles

.c.o:
	$(CC) $(INCDRS) $(CFLAGS) -o $@ -c $<

clean:
	-rm $(EXE1) $(EXE2) $(EXE3)
	-rm $(TESTOBJ) $(SPEEDOBJ) $(RECORDOBJ)
	-rm $(OBJFLS)

