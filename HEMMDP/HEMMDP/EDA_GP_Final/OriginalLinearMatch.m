 function [TrainErr,TestErr,ValidErr,TrnErr,TstErr,VldErr,milo,FTrcor,FTscor]=LinearMatch(BlockValue,BlockRnd,popSi,trainD,validD,testD,BSPlusJ,Coeff,j,Block_result,varnumber,prenewnum) %Block_result,varnumber) 
p0=1;
p0bar=1;

S=load('temp_global_parallel');
FSET_END=S.FSET_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;
RAND_END=S.RAND_END;
SaC1=0;
Si=0;
Bnum=0;
Blockbuffer{1000,1000}=[];
Blockrand{1000,1000}=[];
C1=0;
C2prime=zeros(500,1);
C2=zeros(500,1); 


i = 0;
tprime=0;
gen=10;
% popSize=200; 
popSize=popSi;
% randompop=popSize-popSi;
while i < gen
i=i+1

clear poprandom
clear buffer
clear rnd
 %if (i>1) 
    popSize=10;  
    %randompop=popSize-180;
 %end
 

 if (i==1)  
    tprime=popSi;   
 end
 

if i==1
   for h=1:popSi 
  Bbuffer{h}= BlockValue{j}{h};             
  Brnd{h}= BlockRnd{j}{h};            
  end
  tprime=popSi;
  buffer=Bbuffer;
  rnd=Brnd;
  popSize=popSi;
else
   for h=1:popSize
   buffer{h}=popmodel.indiv(h).value;  
   rnd{h}=popmodel.indiv(h).rand;
   end
   u=1;
 
end

  
  if i>1
  u=1;
  
  for h=popSize+1:popSize+tprime
  buffer{h}=Bbuffer{u};
  rnd{h}=Brnd{u};
  u=u+1;
  end
  end
preBnum=Bnum;
preBlockbuffer=Blockbuffer;
preBlockrand=Blockrand;
preC1=C1;
preC2prim=C2prime;
preC2=C2;  
popSizeprime=popSize+tprime;
if i==1
  popSizeprime=popSi;
end
clear Fbuffer
clear Frnd
if popSizeprime>1
if j==1
[Fbuffer,Frnd,popS,Eflag]=EliminateSimilar(buffer,rnd,popSizeprime,trainD,validD,1,1,1,j,2);   
else
[Fbuffer,Frnd,popS,Eflag]=EliminateSimilar(buffer,rnd,popSizeprime,trainD,validD,BlockValue,BSPlusJ,Coeff,j,Block_result);
end
else
popS=popSizeprime;
Fbuffer=buffer;
Frnd=rnd;
end
popS


flag=1;
omitcount=0;
while (flag==1 && popS>1)
if j==1
 [Fbuffer,Frnd,popS,flag,flag2]=OmitPop(Fbuffer,Frnd,popS,trainD,validD,1,1,1,j,1);
else
[Fbuffer,Frnd,popS,flag,flag2]=OmitPop(Fbuffer,Frnd,popS,trainD,validD,BlockValue,BSPlusJ,Coeff,j,Block_result);
end
omitcount=omitcount+1
end

if popS>1
if j==1
[C1,C2]=Ccalc(Fbuffer,Frnd,popS,trainD,validD,1,1,1,j,1);
else
[C1,C2]=Ccalc(Fbuffer,Frnd,popS,trainD,validD,BlockValue,BSPlusJ,Coeff,j,Block_result);
end
else
  Blockbuffer= Fbuffer;
  Blockrand= Frnd;
  Bnum=1;
  C1=C(Fbuffer,Frnd,trainD,validD,popS,1000000,BlockValue,BSPlusJ,Coeff,j,Block_result);
  C2prime=0;
end
if popS>1
clear Blockbuffer
clear Blockrand
Cdiffbar=mean(C1-C2);                                      
[Blockbuffer,Blockrand,Bnum,C2prime]=FindBlocks1(Fbuffer,Frnd,min(popSize,popS),Cdiffbar,C1,C2);
end
flag=0;
if abs(C1)>=abs(preC1)
    Bnum=Bnum;
else
    Bnum=preBnum;
    Blockbuffer=preBlockbuffer;
    Blockrand=preBlockrand;
    C1=preC1;
    C2prime=preC2prim;
    C2=preC2;
    flag=1;
end


% figure
% SaC1=[SaC1 C1];
% Si=[Si i];
%plot(i,C1)


%tprime=Bnum;
maxcrossMI=ones(1,1000);
if i==1
alph=0.9999;
else
alph=0.95;
end
if (j==1 && i<=1)
   FSET_EN=FSET_END;
   RAND_EN=RAND_END;
   p0bar=(1/FSET_EN)*ones(1,FSET_EN); %p0bar=(1/RAND_END)*ones(1,RAND_END); 
   p1bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN);
   p11bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,RAND_EN);
   p2bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN);
   p22bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,RAND_EN);
   p3bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,FSET_EN);
   p33bar=(1/RAND_EN)*ones(RAND_EN,FSET_EN,FSET_EN,FSET_EN,RAND_EN);
   p4bar=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
   p44bar=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
   p4bar(Var_START:RAND_END,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END)=1/(RAND_END-Var_START+1)*ones(RAND_END-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN);
   p44bar(Var_START:RAND_END,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END,Var_START:RAND_END)=1/(RAND_END-Var_START+1)*ones(RAND_END-Var_START+1,FSET_EN,FSET_EN,FSET_EN,FSET_EN,RAND_END-Var_START+1);
  [p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1(Blockbuffer,Blockrand,Bnum,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,i,alph,C1,C2prime);  
elseif (j==1 && i>1)
  [p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1(Blockbuffer,Blockrand,Bnum,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,i,alph,C1,C2prime);
elseif (j~=1 && i<=1)
 [p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final(Blockbuffer,Bnum,BSPlusJ,maxcrossMI,i,C1,C2prime);
elseif (j~=1 && i>1)
[p0,p1,p11,p2,p22,p3,p33,p4,p44,Ex0,Ex1]=prob_Final1(Blockbuffer,Blockrand,Bnum,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,Block_result,i,alph,C1,C2prime);
end

if i>=2
 p0bar=p0; p1bar=p1; p11bar=p11; p2bar=p2; p22bar=p22; p3bar=p3; p33bar=p33; p4bar=p4; p44bar=p44;
end
%   
popSize=10; %popSize=300  ham khoob bod %popSize=80 
%tprim=t; 
clear popmodel
if j==1
popmodel = PopEDAGP_ver3(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize,trainD);
else
popmodel = PopEDAGP_Final(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize,trainD,BlockValue,BSPlusJ,Coeff,j);
end

 u=1;
 k=popSize+tprime; 
 while k>popSize
 popmodel.indiv(k).value=Bbuffer{u};
 popmodel.indiv(k).rand=Brnd{u};
 u=u+1;
 k=k-1;
 end
 
newnum=Bnum;

clear BlockValue
clear BlockRnd
for h=1:Bnum
BlockValue{j}{h}=Blockbuffer{h};
BlockRnd{j}{h}=Blockrand{h};
end

for k=1:newnum     
CCoeff{j}{k}=BlockRnd{j}{k};
end

icount=1;
while icount<=newnum
[FBlock,nodesize(icount)]=CalccoefficientFinal(BlockValue,j,icount,BlockValue);
F1Block{j}{icount}=FBlock{j}{icount};
Coeff1{j}{icount}=CCoeff{j}{icount};
icount=icount+1; 
end

 [weights,TrainErr,TestErr,ValidErr,~,FTrcorr,FTscorr]=Combination(F1Block,Coeff1,newnum,trainD,validD,testD,j);
TrnErr(i)=TrainErr;
TstErr(i)=TestErr;
VldErr(i)=ValidErr;
Trcorr(i)=FTrcorr;
Tscorr(i)=FTscorr;

end %end of while
[mi,milo]=min(abs(VldErr));

TrainErr=TrnErr(milo);
TestErr=TstErr(milo);
ValidErr=VldErr(milo);
FTrcor=Trcorr(milo);
FTscor=Tscorr(milo);
%bazar bere ta ta j=10 bad az in code estefadeh kon, age on moghe javab
%nadad bargardon be halate ghabl
