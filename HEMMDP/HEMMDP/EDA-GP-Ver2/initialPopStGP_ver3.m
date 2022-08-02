function pop = initialPopStGP_ver3(popSize,trainD,paramet)
global ADD SUB MUL DIV FSET_START FSET_END RAND_START Var_START RAND_END BLOCK_START BLOCK_END
S=load('temp_global_parallel');
ADD=S.ADD;
SUB =S.SUB;
MUL =S.MUL;
DIV =S.DIV;
FSET_START=S.FSET_START;
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;
BLOCK_END=S.BLOCK_END;

minRand = -10;
maxRand = 10;
varnumber = size(trainD,2)-1;
for j=1:popSize        
    pop.indiv(j).value = [];
    %randomnumbers = minRand+(maxRand-minRand)*rand(1,100);
    for i=1:RAND_END-RAND_START+1
        randomnumbers(i)=0.5;
    end
    buffer = randomIndiv_ver3(varnumber,paramet);
    pop.indiv(j).value = buffer;
    pop.indiv(j).rand = randomnumbers;
    [a2 expr] = printIndiv_ver3(buffer,1,varnumber,randomnumbers);
%     disp(expr);
    pop.indiv(j).expr = expr;
    fitness = compStFit_ver3(pop,j,trainD);
    pop.indiv(j).fit = fitness;
end




