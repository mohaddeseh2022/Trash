clear all

global ADD SUB MUL DIV Var Rand FSET_START FSET_END RAND_START Var_START RAND_END

ADD = 1;
SUB = 2;
MUL = 3;
DIV = 4;
FSET_START = ADD;
FSET_END = DIV;
RAND_START=10;
RAND_END=10;
Var_START=5;

popSize=500;
gen=50;
%  load('E:\PHDThesis1396\Standard GP\bm1.mat')
%  load('E:\PHDThesis1396\Standard GP\bm1Test.mat')
% 
 trainD=load('C:\Users\SONY\SONY first backup\Desktop\TinyGP\b14-train');
 testD=load('C:\Users\SONY\SONY first backup\Desktop\TinyGP\b14-test');
%   Dat=xlsread('C:\Users\SONY\SONY first backup\Desktop\F2.xlsx');
%    trainD(:,1)=Dat(:,1);
%    trainD(:,2)=Dat(:,2);
%    trainD(:,3)=Dat(:,3);


%   trainD=[0.25 1.2656;1 3;2 11;3 31;4 69;5 131;6 223;7 351;8 521;9 939;10 1011; 11 1343;12 1741;13  2211; 14 2759; 15 3391;16 4113;17 4931;18 5851;19 6879;20 8021;21 9283;22 10671;23 12191;24 13849;25 15651;26 17603;27 19711;28 21981;29 24419;30 27031;31 29823;32 32801;33 35971;34 39339;35 42911;36 46693;37 50691;38 54911;39 59359;40 64041;41 68963;42 74131;43 79551;44 85229;45 91171;46 97383;47 103871;48 110641;49 117699;50 125051]; 
%   testD=trainD;

%       trainD=[1 2;2 3;3 4;4 5;5 6;6 7;7 8;8 9;9 10;10 11];
%       testD=trainD;

%      trainD=[1 2;2 5;3 10;4 17;5 26;6 37;7 50;8 65;9 82;10 101];
%      testD=trainD;
varnumber = size(trainD,2)-1;
trainErrorSt=zeros(1,gen);
testErrorSt=zeros(1,gen);


i = 0;
while i < gen
i=i+1;

clear poprandom
clear buffer
clear rnd
clear fitss
clear expres
clear popsortmodel
tprime=3;

poprandom = initialPopStGP_ver3(popSize+tprime,trainD);
if i==1
    popmodel=poprandom;
end

  for h=1:popSize+tprime
  buffer{h}=popmodel.indiv(h).value;
  rnd{h}=popmodel.indiv(h).rand;
  fitss{h}=popmodel.indiv(h).fit;
  expres{h}=popmodel.indiv(h).expr;
  end

  
[MI1,popsortmodel,MIind]=MutualInf_ver3(buffer,rnd,popSize+tprime,varnumber,trainD,fitss);
 
 clear buffer
 clear rnd
 clear fitss
 clear expres
 
for h=1:popSize+tprime
buffer{h}=popsortmodel.indiv(h).value;
rnd{h}=popsortmodel.indiv(h).rand;
fitss{h}=popsortmodel.indiv(h).fit;
expres{h}=popsortmodel.indiv(h).expr;
end


sum1=0;
sum2=0;
num1=floor(0.5*popSize);
for k=1:num1
sum1=sum1+MI1(k);
sum2=sum2+(MI1(k).^2);
end
MImean(i)=sum1/num1;
EX2=sum2/num1;
MIvar(i)=EX2-((MImean(i)).^2);
MImax(i)=MI1(1);


 disp(popsortmodel.indiv(1).expr);
 disp(popsortmodel.indiv(1).fit);
 disp(MI1(1));
 
for h=1:tprime
Bbuffer{h}=popsortmodel.indiv(h).value;
Brnd{h}=popsortmodel.indiv(h).rand;
Bfitss{h}=popsortmodel.indiv(h).fit;
Bexpres{h}=popsortmodel.indiv(h).expr;
end



if i<201
y=1-((9/1990)*(i-1));
else
y=0.1;
end
    
popSizerandom=floor(y*(popSize+tprime));
popSizemodel=(popSize+tprime)-popSizerandom;

clear buffer
clear rnd
clear fitss
clear expres
for h=1:popSizerandom
buffer{h}=poprandom.indiv(h).value;
rnd{h}=poprandom.indiv(h).rand;
fitss{h}=poprandom.indiv(h).fit;
expres{h}=poprandom.indiv(h).expr;
end
u=1;
for h=popSizerandom+1:popSize+tprime
%u=1+floor(rand*(popSize+tprime-popSizerandom+1));
buffer{h}=popsortmodel.indiv(u).value;
rnd{h}=popsortmodel.indiv(u).rand;
fitss{h}=popsortmodel.indiv(u).fit;
expres{h}=popsortmodel.indiv(u).expr;
u=u+1;
end


popSizeprime=popSize+tprime; 
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
popmodel = PopEDAGP_ver3(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize+tprime,trainD);

 
%  u=1;
%  k=popSize+1;
%  while k<popSize+tprime+1
%  popmodel.indiv(k).value=Bbuffer{u};
%  popmodel.indiv(k).rand=Brnd{u};
%  popmodel.indiv(k).fit=Bfitss{u};
%  popmodel.indiv(k).expr=Bexpres{u}; 
%  u=u+1;
%  k=k+1;
%  end
%  popSize=popSize+tprime;
% end

 u=1;
 k=popSize+tprime;
 while k>popSize
 popmodel.indiv(k).value=Bbuffer{u};
 popmodel.indiv(k).rand=Brnd{u};
 popmodel.indiv(k).fit=Bfitss{u};
 popmodel.indiv(k).expr=Bexpres{u}; 
 u=u+1;
 k=k-1;
 end
end

popsort=sortpop(popsortmodel);
disp(popsort.indiv(1).expr);
disp(-popsort.indiv(1).fit);
disp(popsort.indiv(1).value);
trainErrorSt=-popsort.indiv(1).fit; 
testErrorSt=-compStFit_ver3(popsort,1,testD);


fitmean=0;
fitvar=0;
fitmax=0;
plot_ver3(MImean,fitmean,MIvar,fitvar,MImax,fitmax,gen)


%regress(