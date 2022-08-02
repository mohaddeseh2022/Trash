function test_ver3() 

global ADD SUB MUL DIV Var Rand FSET_START FSET_END RAND_START Var_START RAND_END

ADD = 1;
SUB = 2;
MUL = 3;
DIV = 4;
FSET_START = ADD;
FSET_END = DIV;
RAND_START=13;
RAND_END=13;
Var_START=5;
Var=5;
Rand = 6;
popSize = 100;
%tsize = 0.05*popSize;
gen = 100;

load('E:\PHDThesis1396\Standard GP\bm1.mat')
load('E:\PHDThesis1396\Standard GP\bm1Test.mat')

%[pro,t1,t2]=evolveStandardEDAGP(popSize,gen,trainD,testD);
