function [result, pos]=run_Final(buffer,pos,trainD,rnd,BlockValue,BSPlusJ,Coeff,k,RAND_END,Blockrun)
%RAND_END=2000;
global ADD SUB MUL DIV RAND_START Var_START BLOCK_START BLOCK_END

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
m = size(trainD,1);
varnumber=size(trainD,2)-1;
result=zeros(m,1);
%buffer
primitive = buffer(pos);
if (Var_START<=primitive && primitive<RAND_START)
    result=trainD(:,primitive-Var_START+1);
    pos=pos+1; 
elseif (primitive <=RAND_END && primitive >= RAND_START)
    result=(rnd(primitive-RAND_START+1)*ones(m,1));
    pos=pos+1;
elseif (primitive <=BLOCK_END && primitive >= BLOCK_START)
    for j=BLOCK_START:BSPlusJ
        if primitive==j    
            %rndprime(:)=Coeff{k}{primitive-BLOCK_START+1}(:);
            k-1
            primitive-BLOCK_START+1
            result=Blockrun{k-1}{primitive-BLOCK_START+1};
          % [result,poss]=run_Final(BlockValue{k}{j-BLOCK_START+1},1,trainD,rndprime,BlockValue,BSPlusJ,Coeff,k-1,RAND_END);
           pos=pos+1;
        end
    end
    
else
    [result1,pos1]=run_Final(buffer,pos+1,trainD,rnd,BlockValue,BSPlusJ,Coeff,k,RAND_END,Blockrun);
    [result2,pos2]=run_Final(buffer,pos1,trainD,rnd,BlockValue,BSPlusJ,Coeff,k,RAND_END,Blockrun);
    switch (primitive) 
        case ADD
            result = result1+result2;
            %result = result1.*result2;

        case SUB
%             result = result1./result2;
%             result(isnan(result)) =1;
%             result(isinf(result))=result1(isinf(result));
            result = result1-result2;
        case MUL
            result = result1.*result2;
        case DIV
            result = result1./result2;
            result(isnan(result)) =1;
            result(isinf(result))=result1(isinf(result));
%             for i=1:m
%                 if (result2(i)==0 && result1(i)==0)
%                     result(i) =1;
%                 elseif (abs(result2(i))==0)%(abs(result2(i)) < 1e-5)
%                     result(i) = result1(i);
%                 else
%                     result(i) = result1(i)/result2(i);
%                 end
%             end
    end
    pos = pos2;
end