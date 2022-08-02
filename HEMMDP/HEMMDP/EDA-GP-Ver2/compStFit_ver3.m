function fit = compStFit_ver3(pop,j,trainD)

varnumber = size(trainD,2)-1;
Y = trainD(:,varnumber+1);
buffer = pop.indiv(j).value;
rnd = pop.indiv(j).rand;
[result, pos] = run_ver3(buffer,1,trainD,rnd);
fit = 5;%myerror(result,Y);   %for regression problem
%fit=mean(result); %for max problem