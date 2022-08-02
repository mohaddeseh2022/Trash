
clear all


global ADD SUB MUL DIV Var Rand FSET_START FSET_END RAND_START Var_START RAND_END

ADD = 1;
SUB = 2;
MUL = 3;
DIV = 4;
FSET_START = ADD;
FSET_END = DIV;
RAND_START=6;
RAND_END=6;
Var_START=5;
Var=5;
Rand = 6;


popSize=500;
gen=50;
 load('E:\PHDThesis1396\Standard GP\bm1.mat')
 load('E:\PHDThesis1396\Standard GP\bm1Test.mat')

% trainD=xlsread('C:\Users\SONY\SONY first backup\Desktop\Bource_Data.xlsx');
% testD=trainD;

%      trainD=[1 3;2 11;3 31;4 69;5 131;6 223;7 351;8 521;9 939;10 1011];
%      testD=trainD;

%     trainD=[1 2;2 3;3 4;4 5;5 6;6 7;7 8;8 9;9 10;10 11];
%     testD=trainD;

%      trainD=[1 2;2 5;3 10;4 17;5 26;6 37;7 50;8 65;9 82;10 101];
%     testD=trainD;

varnumber = size(trainD,2)-1;
trainErrorSt=zeros(1,gen);
testErrorSt=zeros(1,gen);
randomnumbers=0.5;
pmn=0.2;


i = 1;
while i < gen+1
clear poprandom
clear buffer
clear rnd
clear fitss
clear expres
clear popsortmodel


 poprandom = initialPopStGP_ver3(popSize,trainD);
if i==1
    popmodel=poprandom;
end

tprime=3;
popsortmodel=sortPop(popmodel);

disp(popsortmodel.indiv(1).expr);
disp(-popsortmodel.indiv(1).fit);
trainErrorSt(i)=-popsortmodel.indiv(1).fit; 
testErrorSt(i)=-compStFit_ver3(popsortmodel, 1, testD);

sum1=0;
sum2=0;
for k=1:popSize
sum1=sum1+(popmodel.indiv(k).fit);
sum2=sum2+((popmodel.indiv(k).fit).^2);
end
fitmean(i)=sum1/popSize;
EX2=sum2/popSize;
fitvar(i)=EX2-((fitmean(i)).^2);
fitmax(i)=popsortmodel.indiv(1).fit;


for h=1:tprime
Bbuffer{h}=popsortmodel.indiv(h).value;
Brnd{h}=popsortmodel.indiv(h).rand;
Bfitss{h}=popsortmodel.indiv(h).fit;
Bexpres{h}=popsortmodel.indiv(h).expr;
end

y=1-((20/1990)*(i-1));
popSizerandom=floor(y*popSize);
popSizemodel=popSize-popSizerandom;

for h=1:popSizerandom
buffer{h}=poprandom.indiv(h).value;
rnd{h}=poprandom.indiv(h).rand;
fitss{h}=poprandom.indiv(h).fit;
expres{h}=poprandom.indiv(h).expr;
end

for h=popSizerandom+1:popSize
u=1+floor(rand*(popSize-popSizerandom+1));
buffer{h}=popsortmodel.indiv(u).value;
rnd{h}=popsortmodel.indiv(u).rand;
fitss{h}=popsortmodel.indiv(u).fit;
expres{h}=popsortmodel.indiv(u).expr;
end

popSizeprime=popSize; 
[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3(buffer,rnd,popSizeprime,varnumber,trainD);
 Beta=1/2;
  if i==1
      p0bar=p0; p1bar=p1; p11bar=p11; p2bar=p2; p22bar=p22; p3bar=p3; p33bar=p33; p4bar=p4; p44bar=p44;
  end
  
 p0bar=(Beta)*p0+(1-Beta)*p0bar;
 p1bar=(Beta)*p1+(1-Beta)*p1bar;
 p11bar=(Beta)*p11+(1-Beta)*p11bar;
 p2bar=(Beta)*p2+(1-Beta)*p2bar;
 p22bar=(Beta)*p22+(1-Beta)*p22bar;
 p3bar=(Beta)*p3+(1-Beta)*p3bar;
 p33bar=(Beta)*p33+(1-Beta)*p33bar;
 p4bar=(Beta)*p4+(1-Beta)*p4bar;
 p44bar=(Beta)*p44+(1-Beta)*p44bar;
 
 
clear popmodel 
popmodel = PopEDAGP_ver3(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize,trainD);


 if i>100
 for num=1:popSize  
 num=1+floor(rand*(popSize));
 buffer = popmodel.indiv(num).value;
 newind = mutation_ver3(buffer, pmn, varnumber);
 popmodel.indiv(num).value=newind;
 fitness = compStFit_ver3(popmodel,num,trainD);
 popmodel.indiv(num).fit=fitness;
 [a2 exp] = printIndiv_ver3(newind,1,varnumber,randomnumbers);
 popmodel.indiv(num).expr=exp;
 end
 end


i=i+1;


%     nu=5;
%  
%    [MIind,BestMI,BestBuffers,BestRnds]=MutualInf(buffer,rnd,popSize,nu,varnumber,trainD);
%    
%     disp(popsort.indiv(MIind(1)).expr);
%     disp(popsort.indiv(MIind(1)).fit);
%     disp(BestMI(1));
%     trainErrorSt(i)=-popsort.indiv(MIind(1)).fit; 
%     testErrorSt(i)=-compStFit_ver2(popsort, MIind(1), testD);
  
 
u=1;
k=popSize+1;
tprime=3;
  
 while k<popSize+tprime+1
 popmodel.indiv(k).value=Bbuffer{u};
 popmodel.indiv(k).rand=Brnd{u};
 popmodel.indiv(k).fit=Bfitss{u};
 popmodel.indiv(k).expr=Bexpres{u}; 
 u=u+1;
 k=k+1;
 end
 popSize=popSize+tprime;
 
end

MImean=0;
MIvar=0;
MImax=0;
plot_ver3(MImean,fitmean,MIvar,fitvar,MImax,fitmax,gen)
