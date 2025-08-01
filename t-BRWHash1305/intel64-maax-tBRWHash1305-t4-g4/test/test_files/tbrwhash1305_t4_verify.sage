import random

ZZ = IntegerRing()
F2 = GF(2)

# p is the prime, k is key length and n is block length
p = 2^(130)-5; k = 128; n = 128; 
F = GF(p)

def getKeyRandom(k):

	key = []
	f = open("tbrwhash1305_t4_verify_keyfile.txt", "w")
	for i in range(k): 
		bit = F2.random_element()
		key.append(bit)
		f.write(str(bit))
	f.close()	 
	return key

def getKeyFldElt(key,k):

	c = F(0);
	for i in range(k):
		c = 2*c + F(key[i])
	return c;
 
def formatMsgBRW(msg,msgLen,msgEltsLst,n):

	if (msgLen == 0):
		m = 0
		msgEltsLst = []
		return m
	r = ZZ(mod(msgLen,n))
	if (r == 0):
		m = msgLen/n
		lastlen = n
	else:
		m = 1 + floor(msgLen/n)
		lastlen = r

	for i in range(m-1):
		c = F(0)
		for j in range(n):
			c = 2*c + F(msg[i*n+j])
		msgEltsLst.append(c)
	c = F(0)
	for j in range(lastlen):
		c = 2*c + F(msg[(m-1)*n+j])
	msgEltsLst.append(c)
	return m

def printMsgLst(msgEltsLst):

	m = len(msgEltsLst)
	for i in range(0,m):
		print("\t%032x"%msgEltsLst[i])
	return

def BRW(keyFldElt, msgEltsLst):

	m = len(msgEltsLst)
	   
	if (m == 0):
		return 0
	if (m == 1):
		return msgEltsLst[0]
	if (m == 2):
		return keyFldElt*msgEltsLst[0] + msgEltsLst[1] 
	if (m == 3):
		 return (keyFldElt+msgEltsLst[0])*((keyFldElt*keyFldElt)+msgEltsLst[1]) + msgEltsLst[2]

	r = floor(log(m,2))
	msgEltsLst1 = []
	for i in range(0,2^r-1):
		msgEltsLst1.append(msgEltsLst[i])

	msgEltsLst2 = []
	for j in range(2^r,m):
		msgEltsLst2.append(msgEltsLst[j])
		
	tmp1 = BRW(keyFldElt, msgEltsLst1)
	tmp2 = keyFldElt^(2^r)+msgEltsLst[2^r-1]
	tmp3 = BRW(keyFldElt, msgEltsLst2)

	return tmp1 * tmp2 + tmp3
	
def ComputeBRW(t,keyFldElt,msgEltsLst):
	
	m = len(msgEltsLst)
	keyPow = []
	keyPow.append(keyFldElt)
	
	stack = []
	i = 1
	if (m>2):
		for j in range(1,1+floor(log(m,2))):
			keyPow.append(keyPow[j-1]^2)
			a = keyPow[i]
			i=i+1			
			stack.append(F(0))

	top = -1
	for i in range(1,1+floor(m/(2^t))):
		tmpMsgLst = []
		for j in range(1,2^t):
			tmpMsgLst.append(msgEltsLst[2^t*(i-1)+j-1])
		tmp = BRW(keyFldElt, tmpMsgLst)
		k = 0
		ii = i
		while (ZZ(mod(ii,2)) == 0):
			ii = ii/2
			k = k+1
		for j in range(0,k):
			tmp = tmp + stack[top]
			top = top - 1
		tmp1 = msgEltsLst[2^t*i-1] + keyPow[t+k]
		tmp2 = keyPow[t+k]
		tmp = tmp * tmp1
		top = top + 1
		stack[top] = tmp

	r = ZZ(mod(m,2^t))
	tmpMsgLst = []
	for j in range(r):
		tmpMsgLst.append(msgEltsLst[m-r+j])
	tmp = BRW(keyFldElt, tmpMsgLst)
	
	ell = 0
	ii = floor(m/2^t)
	while (ii>0):
		if (ZZ(mod(ii,2)) == 1):
			ell = ell + 1
		ii = floor(ii/2)
	for j in range(0,ell):
		tmp = tmp + stack[top]
		top = top - 1

	return tmp
	
def Horner(keyFldElt, msgEltsLst):
	
	m = len(msgEltsLst)
	if (m == 0):
		return F(0)
	val = msgEltsLst[0]
	for i in range(1,m):
		val = keyFldElt * val + msgEltsLst[i]
	return val	
	
def tBRWHash(t,msgLen,keyFldElt,msgEltsLst):

	m = len(msgEltsLst)
	frakm = m - ZZ(mod(m,2^t)) 
	tmpMsgLst = []
	for i in range(0,frakm):
		tmpMsgLst.append(msgEltsLst[i])
	X = ComputeBRW(t,keyFldElt,tmpMsgLst)
	#print("X: \t%033x"%X)
	tmpMsgLst = [X]
	for i in range(frakm,m):
		tmpMsgLst.append(msgEltsLst[i])
	tmpMsgLst.append(F(msgLen))
	val = keyFldElt*Horner(keyFldElt,tmpMsgLst)
	return val	
	
def getRandomString(n):
     
	s = ""
	for i in range(1,n+1):
         
		b = random.randint(0,1)
		s += str(b)
	return s
	
def genTestCases():

	key = getKeyRandom(k)
	keyFldElt = getKeyFldElt(key,k)
    	
	t = 4;
	f1 = open("tbrwhash1305_t4_verify_test_cases.txt", "w")
	f2 = open("tbrwhash1305_t4_verify_s_outputs.txt", "w")	
	start = 1
	stop = 2048
	step = 1
	for msgLen in range(start,stop,step):	
		for i in range(1,2):
			msg = getRandomString(msgLen)
			msgEltsLst = []
			m = formatMsgBRW(msg,msgLen,msgEltsLst,n)
			m = len(msgEltsLst)
			for j in range(0,m):
				f1.write("%032x"%msgEltsLst[j])
			f1.write(" ")
			f1.write("%d"%msgLen)
			f1.write("\n")
			digest = tBRWHash(t,msgLen,keyFldElt,msgEltsLst)
			res = int(digest) % (2^128)
			f2.write("%032x"%res)
			f2.write("\n")
				
	start = 2048
	stop = 65536+128
	step = 128
	for msgLen in range(start,stop,step):	
		for i in range(1,2):
			msg = getRandomString(msgLen)
			msgEltsLst = []
			m = formatMsgBRW(msg,msgLen,msgEltsLst,n)
			m = len(msgEltsLst)
			for j in range(0,m):
				f1.write("%032x"%msgEltsLst[j])
			f1.write(" ")
			f1.write("%d"%msgLen)
			f1.write("\n")
			digest = tBRWHash(t,msgLen,keyFldElt,msgEltsLst)
			res = int(digest) % (2^128)
			f2.write("%032x"%res)
			f2.write("\n")
	f1.close()
	f2.close()

genTestCases()

