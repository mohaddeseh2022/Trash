
function [bestw,TrainErr,TestErr,ValidErr,T,FTrcorr,FTscorr]=Combination(FBlock,Coeff2,num,trainD,validD,testD,k)
% n=size(trainD,1);
% 
% trainD=trainD./(repmat(sum(trainD),[n 1]));
% 
% n=size(testD,1);
% testD=testD./(repmat(sum(testD),[n 1]));
% 
% 
% n=size(validD,1);
% validD=validD./(repmat(sum(validD),[n 1]));

RAND_END=2000;
desiredresult = size(trainD,2);
n1=size(trainD,1);
n2=size(validD,1);
n3=size(testD,1);
Ystar=trainD(:,desiredresult);
validdesiredresult=size(validD,2);
validYstar=validD(:,validdesiredresult);
nonbasecount=0;
varnumber = size(trainD,2)-1;
for i=0:num
 if i>0      
[result, pos]=run_verComb(FBlock{k}{i},1,trainD,Coeff2{k}{i},RAND_END); 
%preresult1(:,i)=result;
 end
%TT{i}=result;%re(i,1) to re(i,n)
if i==0
    T=ones(n1,1);
end
% if i==1
%     T=result; 
% end
if i>1
   
     if size(FBlock{k}{i-1})==size(FBlock{k}{i}) %if preresult1(:,i-1)==result
         if FBlock{k}{i-1}==FBlock{k}{i}
        nonbasecount=nonbasecount+1;
        continue;
         end

     end
     
end

if i>0
T=horzcat(T,result);
end
end

basecount=num-nonbasecount;
for i=0:num
    if i>0
[result2,pos]=run_verComb(FBlock{k}{i},1,validD,Coeff2{k}{i},RAND_END);
%preresult2(:,i)=result2;
    end
if i==0
    TT=ones(n2,1);
end
% if i==1
%     TT=result2;
% end
if i>1
  if size(FBlock{k}{i-1})==size(FBlock{k}{i})
    if FBlock{k}{i-1}==FBlock{k}{i} % if preresult2(:,i-1)==result2
        continue;
    end
  end
end
if i>0
TT=horzcat(TT,result2);
end
end

bestw(1)=0;
bestw(2:basecount+1)=ones(basecount,1);
bestw=bestw';
o=(trace(T'*T)/size(diag(T'*T),1));
la=1000;
lan=10^(-5);
for lan=0:10:100
%while lan<1000000+1
A=((T'*T)+(lan*eye(basecount+1)))^(-1); %basecount instead of num
weights=A*T'*Ystar; %W is calculated with traindata and error is calculated with validation data
if (norm((TT*weights)-validYstar)<norm((TT*bestw)-validYstar)) 
    norm((T*weights)-Ystar)
    norm((T*bestw)-Ystar)
    la=lan;
    bestw=weights;
end
%lan=lan*10;
end
mean(T*bestw)
mean(Ystar)
TrainErr=cError(T*bestw,Ystar)
ValidErr=cError(TT*bestw,validYstar)
for i=0:num
    if i>0
[result3,pos]=run_verComb(FBlock{k}{i},1,testD,Coeff2{k}{i},RAND_END);
%preresult3(:,i)=result3;
    end
    if i==0
        TTT=ones(n3,1);
    end
% if i==1
%     TTT=result3;
% end
if i>1
 if size(FBlock{k}{i-1})==size(FBlock{k}{i})
    if FBlock{k}{i-1}==FBlock{k}{i} % if preresult3(:,i-1)==result3
        continue;
    end
 end
end

if i>0
TTT=horzcat(TTT,result3);
end
end
Testdesiredresult=size(testD,2);
TestYstar=testD(:,Testdesiredresult);
TestErr=cError(TTT*bestw,TestYstar)

Block_res_Train=T*bestw;
Block_res_Valid=TT*bestw;
Block_res_Test=TTT*bestw;
%[result, pos]=run_verComb(FBlock{k}{i},1,testD,Coeff2{k}{i},RAND_END);
%cError(TestT*bestw,TestYstar);

   
      sumres=T*bestw;
      sumres1=TTT*bestw;
  
FTrcorr=abs(corr(sumres,Ystar));
FTscorr=abs(corr(sumres1,TestYstar));