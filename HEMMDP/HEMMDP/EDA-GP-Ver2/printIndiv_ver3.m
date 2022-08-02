function [a2 expr] = printIndiv_ver3(buffer,buffercounter,varnumber,rnd)

global ADD SUB MUL DIV RAND_START Var_START RAND_END

S=load('temp_global_parallel');
ADD=S.ADD;
SUB =S.SUB;
MUL =S.MUL;
DIV =S.DIV;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;


if (Var_START<=buffer(buffercounter) &&  buffer(buffercounter)<RAND_START) 
    expr = strcat('X',num2str(buffer(buffercounter)-Var_START+1));
    buffercounter = buffercounter + 1;
    a2 = buffercounter;
elseif (buffer(buffercounter) >= RAND_START &&  buffer(buffercounter) <=RAND_END) 
    expr = ['(' num2str(rnd(buffer(buffercounter)-RAND_START+1)) ')'];
    buffercounter = buffercounter + 1;
    a2 = buffercounter;
else
    [a1 expr1] = printIndiv_ver3(buffer,buffercounter+1,varnumber,rnd);
    [a2 expr2] = printIndiv_ver3(buffer,a1,varnumber,rnd);
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