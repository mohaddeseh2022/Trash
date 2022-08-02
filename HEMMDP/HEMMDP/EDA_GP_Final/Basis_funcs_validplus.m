function [TrainErr,Tr_corr,TestErr,Ts_corr]=Basis_funcs_validplus(BlockValue,BlockRnd,popSi,trainD,validD,testD,varnumber)
 %[TrainErr,TestErr,ValidErr,TrnErr,TstErr,VldErr,milo,FTrcor,FTscor,FBlmean,FBlvariance]
 S=load('temp_global_parallel');
 FSET_END=S.FSET_END;
 Var_START=S.Var_START;
 BLOCK_START=S.BLOCK_START;
 RAND_END=S.RAND_END;
 popS=popSi;
 Y=zeros(size(trainD,1),popS);
 Ytest=zeros(size(testD,1),popS);
 Yvalid=zeros(size(validD,1),popS);
 Ystar=trainD(:,varnumber+1);
 Yteststar=testD(:,varnumber+1);
 Ystarvalid=validD(:,varnumber+1);
 ind=1; %dummy definition
 SV(ind)=-10; %dummy definition
 
 for i=1:popS
     [res,~]=run_ver3(BlockValue{1}{i},1,trainD,BlockRnd{1}{i});
     Y(:,i)=res;
     [restest,~]=run_ver3(BlockValue{1}{i},1,testD,BlockRnd{1}{i});
     Ytest(:,i)=restest;
     [resvalid,~]=run_ver3(BlockValue{1}{i},1,validD,BlockRnd{1}{i});
     Yvalid(:,i)=resvalid;
 end
counter=0;
while SV(ind)<=0
    W=pinv(Y'*Y)*Y'*Ystar;
    e=(Yvalid*W-Ystarvalid)'*(Yvalid*W-Ystarvalid);
    savedW=W;
    clear YEXTk
    clear YEXTk_test
    clear YEXTk_valid
    YEXTk=zeros(popS,size(trainD,1),popS-1);
    YEXTk_test=zeros(popS,size(testD,1),popS-1);
    YEXTk_valid=zeros(popS,size(validD,1),popS-1);
    for k=1:popS
        YEXTk(k,:,1:k-1)=Y(:,1:k-1);
        YEXTk(k,:,k:popS-1)=Y(:,k+1:end);
        YEXTk_test(k,:,1:k-1)=Ytest(:,1:k-1);
        YEXTk_test(k,:,k:popS-1)=Ytest(:,k+1:end);
        YEXTk_valid(k,:,1:k-1)=Yvalid(:,1:k-1);
        YEXTk_valid(k,:,k:popS-1)=Yvalid(:,k+1:end);
    end
    clear W
    clear YEXk
    clear YEXkvalid
    YEXk=zeros(size(trainD,1),popS-1);
    YEXkvalid=zeros(size(validD,1),popS-1);
     clear SV
    for  k=1:popS
        YEXk(:,:)=YEXTk(k,:,:);
        YEXkvalid(:,:)=YEXTk_valid(k,:,:);
        W=pinv(YEXk'*YEXk)*YEXk'*Ystar;
        eEXTk=(YEXkvalid*W-Ystarvalid)'*(YEXkvalid*W-Ystarvalid);
        SV(k)=(eEXTk-e);
        
    end
    [~,ind]=min(SV);
    if SV(ind)<=0
        counter=counter+1
        YEXTk= reshape(YEXTk(ind,:,:),size(trainD,1),popS-1);
        Y=YEXTk;
        YEXTk_test= reshape(YEXTk_test(ind,:,:),size(testD,1),popS-1);
        Ytest=YEXTk_test;
        YEXTk_valid= reshape(YEXTk_valid(ind,:,:),size(validD,1),popS-1);
        Yvalid=YEXTk_valid;
        popS=popS-1;
    end
end
% size(savedW)
% popS
% size(Y)
%TrainErr=sqrt(e/popS);
TrainErr=cError(Y*savedW,Ystar);
Tr_corr=abs(corr(Y*savedW,Ystar));
%etest=(Ytest*savedW-Yteststar)'*(Ytest*savedW-Yteststar);
%TestErr=sqrt(etest/popS);
TestErr=cError(Ytest*savedW,Yteststar);
Ts_corr=abs(corr(Ytest*savedW,Yteststar));


