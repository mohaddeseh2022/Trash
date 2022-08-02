function [bestw,TrainErr,TestErr,ValidErr,la]=Combination(FBlock,Coeff2,num,trainD,validD,testD,k)

RAND_END=2000;
desiredresult = size(trainD,2);
n1=size(trainD,1);
n2=size(validD,1);
n3=size(testD,1);
Ystar=trainD(:,desiredresult);
validdesiredresult=size(validD,2);
validYstar=validD(:,validdesiredresult);
for i=0:num
 if i>0   
[result, pos]=run_verComb(FBlock{k}{i},1,trainD,Coeff2{k}{i},RAND_END); 
 end
%TT{i}=result;%re(i,1) to re(i,n)
if i==0
    T=ones(n1,1);
end
% if i==1
%     T=result; 
% end
if i>0
T=horzcat(T,result);
end
end

for i=0:num
    if i>0
[result2,pos]=run_verComb(FBlock{k}{i},1,validD,Coeff2{k}{i},RAND_END);
    end
if i==0
    TT=ones(n2,1);
end
% if i==1
%     TT=result2;
% end
if i>0
TT=horzcat(TT,result2);
end
end

bestw(1)=0;
bestw(2:num+1)=ones(num,1);
bestw=bestw';
for lan=0.1:0.1:50
A=((T'*T)+(lan*eye(num+1)))^(-1);
weights=A*T'*Ystar
if (norm((TT*weights)-validYstar)<norm((TT*bestw)-validYstar)) %%train & validation check %norm((T*weights)-Ystar)<norm((T*bestw)-Ystar)) &&...
    norm((T*weights)-Ystar)
    norm((T*bestw)-Ystar)
    la=lan;
    bestw=weights
end
end

TrainErr=cError(T*bestw,Ystar)
ValidErr=cError(TT*bestw,validYstar)
for i=0:num
    if i>0
[result3,pos]=run_verComb(FBlock{k}{i},1,testD,Coeff2{k}{i},RAND_END);
    end
    if i==0
        TTT=ones(n3,1);
    end
% if i==1
%     TTT=result3;
% end
if i>0
TTT=horzcat(TTT,result3);
end
end
Testdesiredresult=size(testD,2);
TestYstar=testD(:,Testdesiredresult);
TestErr=cError(TTT*bestw,TestYstar)

%[result, pos]=run_verComb(FBlock{k}{i},1,testD,Coeff2{k}{i},RAND_END);
%cError(TestT*bestw,TestYstar);
