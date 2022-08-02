function fit = compStFit_Final(pop,j,trainD,BlockValue,BSPlusJ,Coeff,k)
global RAND_END

S=load('temp_global_parallel');
RAND_END=S.RAND_END;
varnumber = size(trainD,2)-1;
Y = trainD(:,varnumber+1);
buffer{k}{j} = pop.indiv(j).value;
rnd = pop.indiv(j).rand;
buffer=CalccoefficientFinal(BlockValue,k,j,buffer);
[result, pos] = run_Final(buffer{k}{j},1,trainD,rnd,BlockValue,BSPlusJ,Coeff,k-1,RAND_END);
fit = myerror(result,Y);   %for regression problem
%fit=mean(result); %for max problem