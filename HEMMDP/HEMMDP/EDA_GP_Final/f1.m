function [Buff,Rnd,Scount,popS,SMI1,endofu]= f1(buffer,rnd,popSize,tprim,trainD,validD,knumA,varnumber,BlockValue,j,sig,flag,Sflag) 

% if j>1
%     [Fbuffer,Frnd,popS,Eflag]=EliminateSimilar(buffer,rnd,popSize+tprim,trainD,validD,BlockValue,1,1,j,1);
% else
% [Fbuffer,Frnd,popS,Eflag]=EliminateSimilar(buffer,rnd,popSize+tprim,trainD,validD,1,1,1,j,1);
% end

popS=popSize+tprim;
Abuffer=buffer;
Arnd=rnd;
% for h=1:popS%popSize+tprim
%   Abuffer{h}=Fbuffer{h};%poprandom.indiv(h).value;
%   Arnd{h}=Frnd{h};%poprandom.indiv(h).rand;
% end
%[SMI1,MIindx,SAbuffer,SArnd]=sortMI(Abuffer,Arnd,popS,varnumber,validD,trainD,1,j);
if j>1
[SMI1,~,SAbuffer,SArnd,~]=sortMI(Abuffer,Arnd,popS,varnumber,validD,trainD,BlockValue,j,flag);
else
[SMI1,~,SAbuffer,SArnd,~]=sortMI(Abuffer,Arnd,popS,varnumber,validD,trainD,1,j,flag);
end 
[~,~,~,~,inSpC,inSpCRnd,~,~,SpC,SpCRnd,Scount,endofu]=FitSh1(SAbuffer,SArnd,popS,knumA,j,sig,BlockValue,rnd,trainD,Sflag);
 
 k=0;
 Buff{endofu,popS}=[];
 Rnd{endofu,popS}=[];
 for h=1:endofu
      k=k+1;
     if Scount(h)~=0
     Buff{k}=inSpC{h};
     Rnd{k}=inSpCRnd{h};
     end
      Buff{k}{Scount(h)+1}=SpC{h};
      Rnd{k}{Scount(h)+1}=SpCRnd{h};
 end
