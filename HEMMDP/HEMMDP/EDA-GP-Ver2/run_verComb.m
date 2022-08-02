function [result, pos]=run_verComb(buffer,pos,trainD,rnd,RAND_END)

% global ADD SUB MUL DIV RAND_START Var_START 

S=load('temp_global_parallel');
ADD=S.ADD;
SUB =S.SUB;
MUL =S.MUL;
DIV =S.DIV;
RAND_START=S.RAND_START;
Var_START=S.Var_START;

m = size(trainD,1);
result=zeros(m,1);
primitive = buffer(pos);
if (Var_START<=primitive && primitive<RAND_START)
    result=trainD(:,primitive-Var_START+1);
    pos=pos+1;
elseif (primitive <=RAND_END && primitive >= RAND_START)
    result=(rnd(primitive-RAND_START+1)*ones(m,1));
    pos=pos+1;
else
    [result1,pos1]=run_verComb(buffer,pos+1,trainD,rnd,RAND_END);
    [result2,pos2]=run_verComb(buffer,pos1,trainD,rnd,RAND_END);
    switch (primitive) 
        case ADD
            result = result1+result2;
%             result = result1.*result2;

        case SUB
            result = result1-result2;
%             result = result1./result2;
%             result(isnan(result)) =1;
%             result(isinf(result))=result1(isinf(result));
            
        case MUL
            result = result1.*result2;
        case DIV
%             result = result1./result2;
%             result(isnan(result)) =1;
%             result(isinf(result))=result1(isinf(result));
            for i=1:m
                if (result2(i)==0 && result1(i)==0)
                    result(i) =1;
                elseif (abs(result2(i))==0)%(abs(result2(i)) < 1e-5)
                    result(i) = result1(i);
                else
                    result(i) = result1(i)/result2(i);
                end
            end
    end
    pos = pos2;
end