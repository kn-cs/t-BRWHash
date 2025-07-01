INCDRS = -I../include/

SRCFLS = ../source/tbrwhash1271_const.S 	\
	 ../source/tbrwhash1271_t2_maax_g4.S	\
	 ../source/tbrwhash1271_keypowers.S	\
	 ../source/tbrwhash1271_input.c 	\
	 ../source/tbrwhash1271.c
         
OBJFLS = ../source/tbrwhash1271_const.o 	\
	 ../source/tbrwhash1271_t2_maax_g4.o	\
	 ../source/tbrwhash1271_keypowers.o	\
	 ../source/tbrwhash1271_input.o 	\
	 ../source/tbrwhash1271.o

TESTSRC = ./tbrwhash1271_t2_g4_verify.c
TESTOBJ = ./tbrwhash1271_t2_g4_verify.o

SPEEDSRC = ./tbrwhash1271_t2_g4_speed.c
SPEEDOBJ = ./tbrwhash1271_t2_g4_speed.o

RECORDSRC = ./tbrwhash1271_t2_g4_record_speed.c
RECORDOBJ = ./tbrwhash1271_t2_g4_record_speed.o
	  
EXE1    = tbrwhash1271_t2_g4_verify
EXE2    = tbrwhash1271_t2_g4_speed
EXE3    = tbrwhash1271_t2_g4_record_speed

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

