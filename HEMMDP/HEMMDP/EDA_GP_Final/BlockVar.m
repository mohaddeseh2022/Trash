function [Blvariance,Blmean]= BlockVar(FBlock,k,num,trainD,Coeff2,varnumber,BlockValue,BSPlusJ,Block_result)
RAND_END=2000;
Y = trainD(:,varnumber+1);
for i=1:num
[result, pos]=run_verComb(FBlock{k}{i},1,trainD,Coeff2{k}{i},RAND_END); 
lambda(i)=abs(corr(result,Y));

end
%if k==1
     [p1,p2]=size(trainD);
     trnD= trainD(1:1:p1,:);
    [maxcrossMI]=Maxcrossmutual_ver3(FBlock{k},Coeff2{k},num,trnD);
%else
    %[maxcrossMI]=Maxcrossmutual_Final(FBlock{k},Coeff2{k},num,trainD,BlockValue,BSPlusJ,Coeff2,k,Block_result);
%end
%Blvariance=var(lambda);
Blvariance=maxcrossMI;
%Blmean=mean(lambda);
Blmean=lambda;
%Blmean(isnan(Blmean))=0;


end
