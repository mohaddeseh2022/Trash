function buffer = randomIndiv_Final(varnumber,j,paramet)

%global FSET_START FSET_END RAND_START Var_START RAND_END BLOCK_START 

S=load('temp_global_parallel');
FSET_START=S.FSET_START;
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;

depth = 4;
max = 2^(depth+1);
d = depth;
buffer = [];
[pos, buffer] = grow_Final(buffer, 1, d, varnumber,Var_START, RAND_START,RAND_END, max, FSET_START, FSET_END,BLOCK_START,j,paramet);
while (pos==-1)
 [pos, buffer] = grow_Final(buffer, 1, d, varnumber,Var_START, RAND_START,RAND_END, max, FSET_START, FSET_END,BLOCK_START,j,paramet);
end