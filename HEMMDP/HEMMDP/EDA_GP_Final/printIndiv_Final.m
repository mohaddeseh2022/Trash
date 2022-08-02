function [a2 expr] = printIndiv_Final(buffer,buffercounter,varnumber,rnd,BlockValue,BSPlusJ,Coeff,k)

global ADD SUB MUL DIV RAND_START Var_START RAND_END BLOCK_START BLOCK_END
S=load('temp_global_parallel');
ADD=S.ADD;
SUB =S.SUB;
MUL =S.MUL;
DIV =S.DIV;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;
BLOCK_END=S.BLOCK_END;
if (Var_START<=buffer(buffercounter) &&  buffer(buffercounter)<RAND_START) 
    expr = strcat('X',num2str(buffer(buffercounter)-Var_START+1));
    buffercounter = buffercounter + 1;
    a2 = buffercounter;
elseif (buffer(buffercounter) >= RAND_START &&  buffer(buffercounter) <=RAND_END) 
    expr = ['(' num2str(rnd(buffer(buffercounter)-RAND_START+1)) ')'];
    buffercounter = buffercounter + 1;
    a2 = buffercounter;
elseif (buffer(buffercounter)>=BLOCK_START && buffer(buffercounter)<=BLOCK_END)
    
    for j=BLOCK_START:BSPlusJ
    if  (buffer(buffercounter)==j)
        rndprime(:)=Coeff{k}{j-BLOCK_START+1}(:);
    [aa expr] = printIndiv_Final(BlockValue{k}{j-BLOCK_START+1},1,varnumber,rndprime,BlockValue,BSPlusJ,Coeff,k-1);
    end
    end
    buffercounter = buffercounter + 1;
    a2 = buffercounter;
    
     
else
    [a1 expr1] = printIndiv_Final(buffer,buffercounter+1,varnumber,rnd,BlockValue,BSPlusJ,Coeff,k);
    [a2 expr2] = printIndiv_Final(buffer,a1,varnumber,rnd,BlockValue,BSPlusJ,Coeff,k);
    switch (buffer(buffercounter)) 
        case ADD
            expr = ['(' expr1 '+' expr2 ')'];
        case SUB
            expr = ['(' expr1 '-' expr2 ')'];
        case MUL
            expr = ['(' expr1 '*' expr2 ')'];
        case DIV
            expr = ['(' expr1 '/' expr2 ')'];
    end
end