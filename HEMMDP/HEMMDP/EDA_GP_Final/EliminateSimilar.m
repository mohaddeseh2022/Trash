function [Fbuffer,Frnd,popS,Eflag]=EliminateSimilar(buffer,rnd,popSize,trainD,validD,BlockValue,~,Coeff,k,Inum)

%if results are completely the same or one results is an integere multiple
%of an other one, the similar tree should be eliminated
% global ADD SUB MUL DIV FSET_START FSET_END RAND_START Var_START RAND_END BLOCK_START BLOCK_END

S=load('temp_global_parallel');
% ADD=S.ADD;
% SUB =S.SUB;
% MUL =S.MUL;
% DIV =S.DIV;
% FSET_START=S.FSET_START;
% FSET_END=S.FSET_END;
% RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
% Var_START=S.Var_START;
% BLOCK_START=S.BLOCK_START;
% BLOCK_END=S.BLOCK_END;
 Eflag=0;
Fbuffer{60000,1}=[];
Frnd{60000,1}=[];
n1=size(trainD,1);
buffer1{20,60000}=[];
F1Block{20,60000}=[];
for i=1:popSize
 
 if k==1   
[result, ~]=run_verComb(buffer{i},1,trainD,rnd{i},RAND_END); 
 else
     buffer1{k}{i}=buffer{i};
[FBlock,~]=CalccoefficientFinal(BlockValue,k,i,buffer1);
F1Block{k}{i}=FBlock{k}{i};
[result, ~]=run_verComb(F1Block{k}{i},1,trainD,rnd{i},RAND_END);
% [result,pos]=run_Final(buffer{i},1,trainD,rnd{i},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);     
 end
 if isinf(result)
     Eflag=1;
 result=0.5*ones(n1,1);
 buffer{i}=RAND_END;
 end
 
 if isnan(result)
    Eflag=1;
 result=0.5*ones(n1,1);
 buffer{i}=RAND_END;
 end

if i==1
    T=result; 
end

if i>1
T=horzcat(T,result);
end

end

%[m,n]=size(T);


if popSize>1
    if (k==1 && Inum==1)
 [C,ia]=licols(T); %wrong performance with licols thats why I changed it to
 [mm,nn]=size(C'); %for licols
    else
[C,ia,~] = unique(T','rows');
[mm,~]=size(C);
    end
popS=mm;
for i=1:mm
    Fbuffer{i}=buffer{ia(i)};  %C(i,:)'; %Fbuffer{i}=T(:,ia(i));
    Frnd{i}=rnd{ia(i)};
end
else
 Fbuffer=buffer;  %C(i,:)'; %Fbuffer{i}=T(:,ia(i));
 Frnd=rnd;  
 popS=popSize;
end

