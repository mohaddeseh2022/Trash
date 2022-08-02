function buffer = randomIndiv_ver3(varnumber,paramet)

global  FSET_START FSET_END RAND_START Var_START RAND_END

S=load('temp_global_parallel');

FSET_START=S.FSET_START;
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;

depth =4;%4
max = 2^(depth+1);
d = depth;
buffer = [];
[pos, buffer] = grow_ver3(buffer, 1, d, varnumber,Var_START, RAND_START,RAND_END, max, FSET_START, FSET_END,paramet);
while (pos==-1)
    [pos, buffer] = grow_ver3(buffer, 1, d, varnumber,Var_START, RAND_START,RAND_END, max, FSET_START, FSET_END,paramet);
end