function [OUTBuff,OUTCoeff,j,MI1,SBlock_result,SBlock_result1,BlockValue,BlockRnd]=OriginalMainFunc(popSize,buffer,rnd,gen,trainD,validD,testD,paramet,~,~,Orgendofu,labind) %F1Block{j}{1}
%hWaitbar = waitbar(0, 'Iteration 1', 'Name', 'Solving problem','CreateCancelBtn','delete(gcbf)');
S=load('temp_global_parallel');
icount=0;
FSET_END=S.FSET_END;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;
 FinalRing=0;
  lab.flag=0;
 counte=0;
 
eliminatelab=zeros(24,1);
 d1=Orgendofu;
varnumber = size(trainD,2)-1;
Y = trainD(:,varnumber+1);
BSPlusJ=BLOCK_START+9;
nodesize=zeros(1,10);
BMI=zeros(1,20);
Coeff{20,10}=[];
Coeff1{20,10}=[];
F1Block{20,10}=[];
FBlock{20,10}=[];
BlockValue{20,10}=[];
BlockRnd{20,10}=[];
Block_result{20,10}=[];
Bbuffer{10}=[];
Brnd{10}=[];
bufferprime{popSize+10}=[];
rndprime{popSize+10}=[];
fitn=zeros(1,popSize+10);
Buffpr{20,50}=[];
preBuffpr{20,50}=[];
[rowsize,p2]=size(trainD);
trD= trainD(1:10:rowsize,:); %25 ta baraye 70000 taei
%  p = randperm(rowsize,500);
%  trD= trainD(p,:);  
% Rp = randperm(rowsize,floor(rowsize/25));
%  trD= trainD(Rp,:); 
[preRe,~] = run_ver3(buffer{popSize},1,trD,rnd{popSize});
preRe1=preRe;
premcorind=1;
preBuffpr{1}{premcorind}=buffer{popSize};

for j=1:4 %we can say while number of nodes in tree is less       
    %than a number

clear SigmaCorr
clear fitind
clear fit
clear fit1
clear savedu
 %BSPlusJ=BLOCK_START+10*(j-1)-1;
i = 0;
tprime=9;
while i < gen
i=i+1;
 NumberOFJ=j
 NumberOFI=i

 
%   Rp = randperm(rowsize,floor(rowsize/10));
%  trD= trainD(Rp,:); 

%trD= trainD(500*(i-1)+1:500*(i),:); 

%  send(q,i);
%  drawnow
% if ~ishandle(hWaitbar)
% % Stop the if cancel button was pressed
% disp('Stopped by user');
% break;
% else
% % Update the wait bar
% waitbar(i/5,hWaitbar, ['Iteration ' num2str(i)]);
% end

clear poprandom
if ((i>1 && j==1) || (i>0 && j>1))
clear buffer
clear rnd
end
clear fitss
clear expres
clear popsortmodel
clear sortedpop
 %must be set to BLOCK_END-BLOCK_START+1 to match concept

if i==1
    tprim=0; %tprime;
end



if j==1
 dummy=1;   
%poprandom = initialPopStGP_ver3(popSize+tprim,trainD);
elseif (j>1 && i==1)
poprandom = initialPopStGP_Final(popSize+tprim,trainD,BlockValue,newnum,BSPlusJ,Coeff,j,paramet);%%10 instead of num %10 instead of 10*(j-1)
end
%add eliminate similar here// for efficiency and speed 

if (i==1 && j>1)
    clear popmodel
    popmodel=poprandom;
end

if ((i>1 && j==1) || (i>0 && j>1))
  for h=1:popSize+tprim
  buffer{h}=popmodel.indiv(h).value;
  rnd{h}=popmodel.indiv(h).rand;
  end
end

if j>1
 [buffer,rnd,popS,~]=EliminateSimilar(buffer,rnd,popSize+tprim,trainD,validD,BlockValue,1,1,j,2); %i as the last input
elseif i>1
[buffer,rnd,popS,~]=EliminateSimilar(buffer,rnd,popSize+tprim,trainD,validD,1,1,1,j,2); 
end
if (i==1 && j==1) 
popS=popSize;
end
popSize=popS-tprim;




  if (i==1)
     pervMIMax=0;
     pervMIMax2=0;
     %newpervMIMax2=0;
  end
fitss=1; %dummy

if (j==1)
[MI1,popMI,popvalidMI,popsortmodel,sortedpop,FinalRing,pervMIMax,pervMIMax2,t,tt]=MutualInf_ver3(buffer,rnd,popSize+tprim,varnumber,validD,trainD,fitss,pervMIMax,pervMIMax2);
else   
    
[MI1,popMI,popvalidMI,popsortmodel,sortedpop,FinalRing,pervMIMax,pervMIMax2,t,tt]=MutualInf_Final(buffer,rnd,popSize+tprim,varnumber,validD,trainD,fitss,BlockValue,BSPlusJ,Coeff,j,pervMIMax,pervMIMax2,Block_result);
end


 
BMI(j)=MI1(1);
if (j>1 && i==gen)
if (BMI(j)-BMI(j-1))<=(0.025*BMI(j-1)) %BMI(j)<=BMI(j-1) previously 0.005
    FinalRing=1;
break;        
end  
end

% if (popS==1 && i>1)
%     break;
% end
%tcount(j,i)=t;
 clear buffer
 clear rnd
 clear fitss
 clear expres
 
for h=1:tt   %%for h=1:popSize+tprime
buffer{h}=popsortmodel.indiv(h).value;
rnd{h}=popsortmodel.indiv(h).rand;
end

%observing statistics related to mutual information of model not mutual
%information of current population:

clear Bbuffer
clear Brnd
for h=1:t
Bbuffer{h}=sortedpop.indiv(h).value;
Brnd{h}=sortedpop.indiv(h).rand;
end
 yy=0;
popSizerandom=floor(yy*(popSize+tprim));
popSizemodel=popSize+tprim-popSizerandom;     

sum1=0;
sum2=0;
sum3=0;
num1=popSize;
for k=1:num1
sum1=sum1+popMI(k);
sum2=sum2+(popMI(k).^2);
sum3=sum3+popvalidMI(k);
end
MImean(i)=sum1/num1;
MIvalidmean(i)=sum3/num1;
EX2=sum2/num1;
MIvar(i)=EX2-((MImean(i)).^2);
MImax(i)=MI1(1);


 disp(MI1(1));


clear buffer
clear rnd
clear fitss
clear expres
for h=1:popSizerandom
buffer{h}=poprandom.indiv(h).value;
rnd{h}=poprandom.indiv(h).rand;
end
u=1;
for h=popSizerandom+1:popSizemodel+popSizerandom
buffer{h}=popsortmodel.indiv(u).value;
rnd{h}=popsortmodel.indiv(u).rand;
u=u+1;
end

popSizeprime=popSize+tprim;
% if i>1
% p0bartest=p0bar;  p1bartest=p1bar;  p4bartest=p4bar;
% end

%if we didnt have the random population we could use MI1 as an input in
%prob functions instead of calculating MI in these functions. 
% if j>1
% [SMI,MIind1,Sbuffer,Srnd]=sortMI(buffer,rnd,popSizeprime,varnumber,validD,trainD,BlockValue,j);
% else
% [SMI,MIind1,Sbuffer,Srnd]=sortMI(buffer,rnd,popSizeprime,varnumber,validD,trainD,1,j);
% end 
 knum=25;%floor(popSize/10);
%[nitchcount,Ma1,Ma2,Ma3,inSpC,inSpCRnd,Indp,IndpRnd,SpC,SpCRnd,count]=FitSh1(Sbuffer,Srnd,popSizeprime,knum,j);
%sig=2^(j+1);
sig=0.85;
 
clear Re
clear diu
clear dCor
sortflag=0;
Sflag=1;
    if j>1
[Buff,Rnd,Scount,~,SMI,endofu]= f1(buffer,rnd,popSize,tprim,trainD,validD,knum,varnumber,BlockValue,j,sig,sortflag,Sflag); 
% [SMI,~,Sbuffer,Srnd,~]=sortMI(buffer,rnd,popSize+tprim,varnumber,validD,trainD,BlockValue,j,sortflag);
    else
       
[Buff,Rnd,Scount,~,SMI,endofu]= f1(buffer,rnd,popSize,tprim,trainD,validD,knum,varnumber,1,j,sig,sortflag,Sflag); 
% [SMI,~,Sbuffer,Srnd,~]=sortMI(buffer,rnd,popSize+tprim,varnumber,validD,trainD,1,j,sortflag);
    end 
    
    if (j>1 && i==1)
        premcorind=1;
        preBuffpr{j}{premcorind}=Buff{premcorind}{Scount(premcorind)+1};
    end
     
     for u=1:endofu 
     Buffpr{j}{u}=Buff{u}{Scount(u)+1};
      if j>1
     [Buffpr,~]=CalccoefficientFinal(BlockValue,j,u,Buffpr);
    [ReBuff, ~]=run_verComb(Buffpr{j}{u},1,trD,Rnd{u}{Scount(u)+1},RAND_END);
      else
     [ReBuff,~] = run_ver3(Buff{u}{Scount(u)+1},1,trD,Rnd{u}{Scount(u)+1});
      end
      if u==1
      Re=ReBuff;
      end
      if u>1
      Re=horzcat(Re,ReBuff);
      end 
%      [o1,o2]=size(setdiff(Buffpr{j}{u}, preBuffpr{j}{premcorind}));
%      [o3,o4]=size(setdiff(preBuffpr{j}{premcorind},Buffpr{j}{u}));
%      diu(u)=o2+o4;
      end
%      
%      clear OrgRe
%      for u=1:Orgendofu
%      [OrgReBuff,~] = run_ver3(OrgBuff{1}{u},1,trainD,OrgRnd{1}{u});
%      if u==labindex
%          continue;
%      end
%      if u==1
%       OrgRe=OrgReBuff;
%      end
%       if (labindex==1 && u==2)
%       OrgRe=OrgReBuff;
%       end
%       if u>1
%       OrgRe=horzcat(OrgRe,OrgReBuff);
%       end 
%      end 
%      
%       Cri=abs(corr(Re,OrgRe));
%       Cri(isnan(Cri))=0;
%       SCri=sum(Cri,2);
%       NSCri=SCri/sum(SCri);
% 
% 
%%%%%%%%%%%%%%%%
%      if (j>1 && i==1)
%       preRe=Re(:,1);
%         
%      end
%%%%%%%%%%%%%%%%     
      
for w=1:endofu
if all(imag(Re(:,w))~=0) && all(imag(preRe)~=0)
dCor(w)=distcorr(abs(Re(:,w)),abs(preRe));
elseif all(imag(Re(:,w))~=0) || all(imag(preRe)~=0)
dCor(w)=0;
elseif all(imag(Re(:,w))==0) && all(imag(preRe)==0)
 dCor(w)=distcorr(Re(:,w),preRe); 
else
  dCor(w)=0;

end
end

SdCor=sum(dCor);

CrosMI=abs(dCor./SdCor);%abs(Cor/SCor)*
CrosMI(isnan(CrosMI))=0;
[~,mcorind]= max(CrosMI);
      endofu
     mcorind
      [m,n]=size(Re)
      %preRe=Re(:,mcorind); %deactivated on monday 4 mordad 1400
      premcorind=mcorind;
       preBuffpr{j}{mcorind}=Buffpr{j}{mcorind};
  Sbuffer=Buff{mcorind};
  Srnd=Rnd{mcorind};
  popSizeprime1=Scount(mcorind)+1;
 


% fitnss=SMI./nitchcount;
fitnss=SMI;

if (j==1 && i<=1) 
    alph=0.9999;%0.8;

FSET_EN=FSET_END;
RAND_EN=RAND_END;
   p0bar=(1/FSET_EN)*ones(1,FSET_EN); %p0bar=(1/RAND_END)*ones(1,RAND_END); 
   p1bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN);
   %p1bar(RAND_END,:)=zeros(1,FSET_END);
   p11bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,RAND_EN);
   %p11bar(RAND_END,:,:)=zeros(1,FSET_END,RAND_END);
   p2bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN);
   %p2bar(RAND_END,:,:)=zeros(1,FSET_END,FSET_END);
   p22bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,RAND_EN);
   %p22bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,RAND_END);
   p3bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,FSET_EN);
   %p3bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END);
   p33bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,FSET_EN,RAND_EN);
   %p33bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,RAND_END);
   p4bar=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
   p44bar=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
   p4bar(Var_START:RAND_END,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END)=1/(RAND_END-Var_START+1)*ones(RAND_END-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN);
   %p4bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END);
   p44bar(Var_START:RAND_END,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END,Var_START:RAND_END)=1/(RAND_END-Var_START+1)*ones(RAND_END-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN,RAND_END-Var_START+1);
   %p44bar(RAND_END,:,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);

   [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,i,alph,fitnss);
%[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,fitnss);   
elseif (j==1 && i>1)
    alph=0.85;%0.4;
  [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,i,alph,fitnss);
elseif (j~=1 && i<=1)
    BSPlus=BSPlusJ;
    alph=0.9999;%0.7;
   p0bar=(1/FSET_END)*ones(1,FSET_END); %p0bar=(1/BSPlusJ)*onesones(1,BSPlusJ); 
   p1bar=(1/BSPlus)*ones(BSPlusJ,FSET_END);
   %p1bar(RAND_END,:)=zeros(1,FSET_END);
   p11bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,BSPlusJ);
   %p11bar(RAND_END,:,:)=zeros(1,FSET_END,BSPlusJ);
   p2bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END);
   %p2bar(RAND_END,:,:)=zeros(1,FSET_END,FSET_END);
   p22bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END,BSPlusJ);
   %p22bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,BSPlusJ);
   p3bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END,FSET_END);
  % p3bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END);
   p33bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END,FSET_END,BSPlusJ);
  % p33bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,BSPlusJ);
   p4bar=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END);
   p44bar=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);
   p4bar(Var_START:BSPlusJ,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END)=1/(BSPlus-Var_START+1)*ones(BSPlusJ-Var_START+1,FSET_END,FSET_END,FSET_END,FSET_END);
   %p4bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END);
   p44bar(Var_START:BSPlusJ,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END,Var_START:BSPlusJ)=1/(BSPlus-Var_START+1)*ones(BSPlusJ-Var_START+1,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ-Var_START+1);
   %p44bar(RAND_END,:,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);


[~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,Block_result,i,alph,fitnss);
 %[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,Block_result,fitnss);
elseif (j~=1 && i>1) 
    alph=0.85;%0.4;
[~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,Block_result,i,alph,fitnss);
end

if (p0(1)<0 || p0(2)<0 || p0(3)<0 || p0(4)<0)
    break;
end
 p0bar=p0; p1bar=p1; p11bar=p11; p2bar=p2; p22bar=p22; p3bar=p3; p33bar=p33; p4bar=p4; p44bar=p44;

  
popSize=200;%150;
%  pretprim=tprim;
tprim=t; 
clear popmodel
if j==1
popmodel = PopEDAGP_ver3(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize+tprim,trainD);
else
popmodel = PopEDAGP_Final(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize+tprim,trainD,BlockValue,BSPlusJ,Coeff,j);
end
 
 u=1;
 k=popSize+tprim; 
 while k>popSize
 popmodel.indiv(k).value=Bbuffer{u};
 popmodel.indiv(k).rand=Brnd{u};
 u=u+1;
 k=k-1;
 end
 
 

 if j==1
     i
     sortedpop
[ testdataMI ] = TestMI_ver3( sortedpop.indiv(1).value,sortedpop.indiv(1).rand,varnumber,testD );
else
 [testdataMI ] = TestMI_Final( sortedpop.indiv(1).value,sortedpop.indiv(1).rand,varnumber,testD,BlockValue,BSPlusJ,Coeff,j);
 end   

TestMI(i)=testdataMI;
%  if (i>10 && MIvalidmean(i)<= (0.9*MIvalidmean(i-10)))
% icount=icount+1;
%  end
% if (icount==3)
%    break;
% end



end

if FinalRing==1;
break;        
end  

% send(q,MImean);
% send(q,MIvalidmean);
% send(q,MIvar);
% send(q,MImax);
% send(q,TestMI);
% send(q,i);
% send(q,j);

plot_Final(MImean,MIvalidmean,MIvar,MImax,i,j)
plot_Test(TestMI,i,j)


% if j>1
% prenewnum=num;
% end

if t>10
    num=10;
else
    num=t;
end
  for k=1:popSizeprime
  bufferprime{k}=popsortmodel.indiv(k).value;
  rndprime{k}=popsortmodel.indiv(k).rand;
  end

  
for k=1:popSizeprime
    fitn(k)=popMI(k);
if isnan(fitn(k))
  fitn(k)=0;
end
if fitn(k)<0
  fitn(k)=abs(fitn(k));
end

end


[~,fitind]=sort(fitn,'descend');

for k=1:popSizeprime
popsortmodel2.indiv(k).value=bufferprime{fitind(k)};
popsortmodel2.indiv(k).rand=rndprime{fitind(k)};
end

for k=1:num
BlockValue{j}{k}=Bbuffer{k};%popsortmodel2.indiv(1).value;
BlockRnd{j}{k}=Brnd{k};%popsortmodel2.indiv(1).rand;
end

newnum=num;
if j==1
     for k=1:num%newnum
   [res,~]=run_ver3(BlockValue{j}{k},1,trainD,BlockRnd{j}{k});
   [res1,~]=run_ver3(BlockValue{j}{k},1,testD,BlockRnd{j}{k});
   Block_result{j}{k}=res;
   Block_result1{j}{k}=res1;
     end
else
    for k=1:num%newnum
%    [res,pos]=run_Final(BlockValue{j}{k},1,trainD,BlockRnd{j}{k},BlockValue,BSPlusJ,Coeff,j,RAND_END,Block_result); 
%    Block_result{j}{k}=res;
[FBlock,nodesize(k)]=CalccoefficientFinal(BlockValue,j,k,BlockValue);
F1Block{j}{k}=FBlock{j}{k};
Coeff1{j}{k}=BlockRnd{j}{k};
%[res,pos]=run_ver3(F1Block{j}{k},1,trainD,Coeff1{j}{k});
[res, ~]=run_verComb(F1Block{j}{k},1,trainD,Coeff1{j}{k},RAND_END);
[res1, ~]=run_verComb(F1Block{j}{k},1,testD,Coeff1{j}{k},RAND_END);

%run_verComb is the same as run_ver3
Block_result{j}{k}=res;
Block_result1{j}{k}=res1;
    end
end
SBlock_result=Block_result{j}{1};
SBlock_result1=Block_result1{j}{1};
for k=1:num%newnum     %%for k=1:num %for k=10*(j-1)+1: 10*j
Coeff{j}{k}=BlockRnd{j}{k};
end
% PreBSPlusJ=BSPlusJ;
BSPlusJ=BLOCK_START+num-1; %%BLOCK_START+num-1;

CCoeff=Coeff;
icount=1;
while icount<=num%newnum
[FBlock,nodesize(icount)]=CalccoefficientFinal(BlockValue,j,icount,BlockValue);
F1Block{j}{icount}=FBlock{j}{icount};
Coeff1{j}{icount}=CCoeff{j}{icount};
icount=icount+1; 
end
clear OUTBuff
clear OUTCoeff
OUTBuff=F1Block{j}{1};
OUTCoeff=Coeff1{j}{1};
%[weights,TrainErr(j),TestErr(j),ValidErr(j),T]=Combination(F1Block,Coeff1,num,trainD,validD,testD,j);
%[Blvariance(j,:),Blmean(j,:)]= BlockVar(F1Block,j,newnum,trainD,Coeff1,varnumber,BlockValue,BSPlusJ,Block_result);
if (p0(1)<0 || p0(2)<0 || p0(3)<0 || p0(4)<0)
    break;
end


% for k=1:popSizeprime
% BlValue{j}{k}=Sbuffer{k};%popsortmodel2.indiv(1).value;
% BlRnd{j}{k}=Srnd{k};%popsortmodel2.indiv(1).rand;
% end
% for k=1:popSizeprime
% Coeffp{j}{k}=BlRnd{j}{k};
% end
% CCoeffp=Coeffp;
% icount=1;
% while icount<=popSizeprime
% [FBlock,nodesize(icount)]=CalccoefficientFinal(BlockValue,j,icount,BlValue);
% F1Blockp{j}{icount}=FBlock{j}{icount};
% Coeff1p{j}{icount}=CCoeffp{j}{icount};
% icount=icount+1; 
% end



clear MImean
clear MIvalidmean
clear TestMI
clear MIvar
clear MImax

% if (j>1 )
% %[TrainErr(j+1),TestErr(j+1),ValidErr(j+1),TrnErr,TstErr,VldErr,milo(j),pp0,pp1]=LinearMatch(BlockValue,BlockRnd,num,trainD,validD,testD,PreBSPlusJ,Coeff,j,Block_result,varnumber,prenewnum);
% [TrainErr(j+1),TestErr(j+1),ValidErr(j+1),TrnErr,TstErr,VldErr,milo(j),pp0,pp1]=LinearMatch(BlValue,BlRnd,BlockValue,BlockRnd,popSizeprime,trainD,validD,testD,PreBSPlusJ,Coeff,j,1,varnumber,prenewnum);
% TrErr(j)=TrainErr(j+1);
% TsErr(j)=TestErr(j+1);
% VlErr(j)=ValidErr(j+1);
% end

% if j>2
% 
%     [weights1,TraErr(j),TesErr(j),ValiErr(j),T1]=Combination(F1Blockp,Coeff1p,popSizeprime,trainD,validD,testD,j);
% end
%labBarrier
% if d1>1
% source = labind
% destination=[];
% for e=1:Orgendofu
%     if e==labind 
%         continue
%     end
%     if j>1 
%       if  any(eliminatelab==e)
%           continue
%       end
%     end
%        destination = horzcat(destination,e);
% end
% %if labind == source 
% 
% labSend(OUTBuff, destination); % send a structure
% j
% %elseif any(destination == labind)
% % Receive on destination lab
% for h=1:Orgendofu
%     if h==labind
%         continue;
%     end
%     if j>1 
%       if  any(eliminatelab==h)
%           continue;
%       end
%     end
%     j
%     h
%     if j>1
%     eliminatelab
%     end
%     
%     %while(1)
%     %if labProbe(h)
%    recvdata{h} = labReceive(h);
%    %break
%     %else
% %         continue
% %     end
% %     end
%     
% end
% %end
% %labBarrier
% n=size(trainD,1);
% mat1=[];
% for e=1:Orgendofu
%     if e==source
%         continue
%     end
%     if j>1
%       if  any(eliminatelab==e)
%            continue
%       end
%     end
%     [res,~]=run_ver3(recvdata{e},1,trainD,OUTCoeff);
%     helpy(:,1)=res;
%     mat1=horzcat(mat1,helpy);
% end
% %if j>1
%     D=abs(corr(mat1,Block_result{j}{1}))
%     D(isnan(D))=0;
%     [maxim,maximind]=max(D)
%     %[d1,d2]=size(D);
%      lab.labi=labind;
%      lab.flag=0;
%     if maxim>0.6
%         %if labind == source
%         lab.flag=1;
%        labSend(lab.flag,destination)
%         %end
%          break;
%     else
%      labSend(lab.flag,destination)
% %      lab.flag=1;
% %      labsend(lab.flag,destination)
%     end
%     counte=0;
%     k=0;
%     eliminatelab
%     for h=1:Orgendofu
%         Fl=0;
%             if h==source
%                if lab.flag==1;
%                 eliminatelab(h)=h;  
%                end
%              continue;
%             end
% %             if j==1
% %                  Fl=1;
% %             end
%             
%             if  ~(any(eliminatelab==h)) %j>1 &&
%                 recvdat1{h} = labReceive(h);
%                 Fl= recvdat1{h} ;
%             end
%             if Fl==1 %&& ~(any(eliminatelab==h))
%            %recvdat{h} = labReceive(h);
%            %if recvdat{h}==1
%               % k=k+1;
%                eliminatelab(h)=h; 
%            %end
%            
%             end
%     end
%      d1=Orgendofu-sum(eliminatelab~=0);
% %end
%end
%labBarrier
end



% % RAND_EN=RAND_END;
% % BSPlus=BSPlusJ;
% 
% FSET_EN=FSET_END-SUB;
% if (j==1 && i<=1) 
%     alph=0.98;%0.8;
% RAND_EN=RAND_END-SUB;
%    p0bar(MUL:FSET_END)=(1/FSET_EN)*ones(1,FSET_EN); %p0bar=(1/RAND_END)*ones(1,RAND_END); 
%    p1bar(MUL:RAND_END,MUL:FSET_END)=(1/RAND_EN)*ones(RAND_EN,FSET_EN);
%    %p1bar(RAND_END,:)=zeros(1,FSET_END);
%    p11bar(MUL:RAND_END,MUL:FSET_END,MUL:RAND_END)=(1/RAND_EN)*ones(RAND_EN,FSET_EN,RAND_EN);
%    %p11bar(RAND_END,:,:)=zeros(1,FSET_END,RAND_END);
%    p2bar(MUL:RAND_END,MUL:FSET_END,MUL:FSET_END)=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN);
%    %p2bar(RAND_END,:,:)=zeros(1,FSET_END,FSET_END);
%    p22bar(MUL:RAND_END,MUL:FSET_END,MUL:FSET_END,MUL:RAND_END)=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,RAND_EN);
%    %p22bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,RAND_END);
%    p3bar(MUL:RAND_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END)=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,FSET_EN);
%    %p3bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END);
%    p33bar(MUL:RAND_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,MUL:RAND_END)=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,FSET_EN,RAND_EN);
%    %p33bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,RAND_END);
%    p4bar(1:RAND_END,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END)=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
%    p44bar(1:RAND_END,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END,1:RAND_END)=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
%    p4bar(Var_START:RAND_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END)=1/(RAND_END-Var_START+1)*ones(RAND_END-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN);
%    %p4bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END);
%    p44bar(Var_START:RAND_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,Var_START:RAND_END)=1/(RAND_END-Var_START+1)*ones(RAND_END-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN,RAND_END-Var_START+1);
%    %p44bar(RAND_END,:,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
% 
%    [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,i,alph,fitnss);
% %[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,fitnss);   
% elseif (j==1 && i>1)
%     alph=0.98;%0.4;
%   [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,i,alph,fitnss);
% elseif (j~=1 && i<=1)
%     BSPlus=BSPlusJ-SUB;
%     alph=0.98;%0.7;
%    p0bar(MUL:FSET_END)=(1/FSET_EN)*ones(1,FSET_EN); %p0bar=(1/BSPlusJ)*onesones(1,BSPlusJ); 
%    p1bar(MUL:BSPlusJ,MUL:FSET_END)=(1/BSPlus)*ones(BSPlus,FSET_EN);
%    %p1bar(RAND_END,:)=zeros(1,FSET_END);
%    p11bar(MUL:BSPlusJ,MUL:FSET_END,MUL:BSPlusJ)=(1/BSPlus)*ones(BSPlus,FSET_EN,BSPlus);
%    %p11bar(RAND_END,:,:)=zeros(1,FSET_END,BSPlusJ);
%    p2bar(MUL:BSPlusJ,MUL:FSET_END,MUL:FSET_END)=(1/BSPlus)*ones(BSPlus,FSET_EN,FSET_EN);
%    %p2bar(RAND_END,:,:)=zeros(1,FSET_END,FSET_END);
%    p22bar(MUL:BSPlusJ,MUL:FSET_END,MUL:FSET_END,MUL:BSPlusJ)=(1/BSPlus)*ones(BSPlus,FSET_EN,FSET_EN,BSPlus);
%    %p22bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,BSPlusJ);
%    p3bar(MUL:BSPlusJ,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END)=(1/BSPlus)*ones(BSPlus,FSET_EN,FSET_EN,FSET_EN);
%   % p3bar(RAND_END,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END);
%    p33bar(MUL:BSPlusJ,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,MUL:BSPlusJ)=(1/BSPlus)*ones(BSPlus,FSET_EN,FSET_EN,FSET_EN,BSPlus);
%   % p33bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,BSPlusJ);
%    p4bar(1:BSPlusJ,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END)=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END);
%    p44bar(1:BSPlusJ,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END,1:BSPlusJ)=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);
%    p4bar(Var_START:BSPlusJ,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END)=1/(BSPlusJ-Var_START+1)*ones(BSPlusJ-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN);
%    %p4bar(RAND_END,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END);
%    p44bar(Var_START:BSPlusJ,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,MUL:FSET_END,Var_START:BSPlusJ)=1/(BSPlusJ-Var_START+1)*ones(BSPlusJ-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN,BSPlusJ-Var_START+1);
%    %p44bar(RAND_END,:,:,:,:,:)=zeros(1,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);
% 
% 
% [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,Block_result,i,alph,fitnss);
%  %[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,Block_result,fitnss);
% elseif (j~=1 && i>1) 
%     alph=0.98;%0.4;
% [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1_method1(Sbuffer,Srnd,popSizeprime1,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSizerandom,Block_result,i,alph,fitnss);
% end
% 
