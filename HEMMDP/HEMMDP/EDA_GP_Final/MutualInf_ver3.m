function [MIbest,MIone,MIp,Trpop,pop,FinalRing,pervMIMax,pervMIMax2,t,tt,MI]=MutualInf_ver3(buffer,rnd,popSize,varnumber,validD,trainD,fitss,pervMIMax,pervMIMax2)
S=load('temp_global_parallel');
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;

% pop.indiv(1).value=RAND_START; 
% pop.indiv(1).rand=0.5;
% pop.indiv(1).expr=0.5;

 Y = trainD(:,varnumber+1);
 Yp=validD(:,varnumber+1);
 for j=1:popSize    
     [result, pos] = run_ver3(buffer{j},1,trainD,rnd{j});
     %[h1,h2,MII]=GMI(result',Y',min(result'),max(result'),min(Y'),max(Y'),2,1,5);
     %result1(j)=result;
%    [MII] = MuInf(result',Y',min(result'),max(result'),min(Y'),max(Y'),10,10);
%    [MII1] = MuInf(Y',Y',min(Y'),max(Y'),min(Y'),max(Y'),10,10);
%    [MII2]=MuInf(result',result',min(result'),max(result'),min(result'),max(result'),10,10);
%    [MII]=MII/max(MII1,MII2);   
%%%7-6-98 [MII,lambda]=MutualInfo(result,Y);
if j==1
Re=result;
end
if j>1
Re=horzcat(Re,result);
end
% lambda=abs(corr(result,Y));
%  %%%%%%%lambda = MutualInformation(result,Y);
% %N=size(Y,1);
% %X=result;
% %[I_xy] = MuInf(X,Y,min(X),max(X),min(Y),max(Y),20,N);
% % [MII1,lambda]=MutualInfo(Y,Y);
% % [MII2,lambda]=MutualInfo(result,result);
% % [MII]=MII/max(MII1,MII2);
%       %MI(j)=MII;
%      MI(j)=lambda;
%      if isnan (MI(j))
%          MI(j)=0;
%      end
%     % if ~(isreal(MI(j)))
%      %    MI(j)=0;
%      %end
% %      if isinf(MI(j)) %infenity is the best MI, if it happens. So putting
% %      zero instead is not correct.putting a big number is more logical
% %          MI(j)=1000;
% %      end
         
    % if (max(result)==min(result)|| isinf(sum(result)))
    % MI(j)=0;
    % end
   
 end
 popSize
MI=abs(corr(Re,Y));
MI(isnan(MI))=0;
MI(isinf(MI))=0;

[MIone,MIind]=sort(MI,'descend');
  
   %%%%%%%%%%%%%%%%%% 
 %if both results validation and train data are fine we choose best buffer
 %calculated from train data as best buffer and 9 other buffers (if
 %available) totally as the 10 best buffers.
 i=0;
 while (i<popSize)
       i=i+1;
  [resultp, pos] = run_ver3(buffer{MIind(i)},1,validD,rnd{MIind(i)});
  lambdap=abs(corr(resultp,Yp));
    MIp(i)=lambdap;
    
     if (isnan(MIp(i)) || isinf(MIp(i)))
      MIp(i)=0;
     end 
 end
 
 count=0; %we need 10 best buffers
  i=0;
  t=0;
  tt=0;
  
 % for k=1:popSize
 % bufferprime{k}=buffer{MIind(k)};
 % rndprime{k}=rnd{MIind(k)};
 % end
   %[VmaxcrossMI]=Maxcrossmutual_ver3(bufferprime,rndprime,popSize,validD);
   while (i<popSize && count<10)
       i=i+1;
  %[resultp, pos] = run_ver3(buffer{MIind(i)},1,validD,rnd{MIind(i)});
  %%%7-6-98 [MIIp,lambdap]=MutualInfo(resultp,Yp);
  %lambdap=abs(corr(resultp,Yp));
  
   % MIp=lambdap;
   
     %if isnan(MIp)
      %MIp=0;
     %end
     if ( MIp(i)>=pervMIMax && MIone(i)>=pervMIMax2 ) 
         t=t+1
         vMI(t)=MIp(i); 
         pop.indiv(t).value=buffer{MIind(i)}; 
         pop.indiv(t).rand=rnd{MIind(i)};
         %pop.indiv(t).fit=fitss{MIind(i)};
         buffer2{t}=buffer{MIind(i)};
         count=count+1;
         MIbest(t)=MIone(i);
     end  
   end
   
if t==0   
    disp('t==================0')
pop.indiv(1).value=RAND_START; 
pop.indiv(1).rand=0.5;
pop.indiv(1).expr=0.5;
t=1;
end
   
   if t==0
       pop=0;
   end
   for i=1:popSize
       %if (MIone(i)>=pervMIMax2)
         tt=tt+1;
         Trpop.indiv(tt).value=buffer{MIind(i)}; 
         Trpop.indiv(tt).rand=rnd{MIind(i)};
         %Trpop.indiv(tt).fit=fitss{MIind(i)};
       %end
   end
  
%%%%%%%%%%%%%%%%%%%%%%%%   
    FinalRing=0; %Stop program execution
   if (count==0)
       FinalRing=1;
        MIbest=0;
%  vMI=MIp; 
%  MIbest=MIone;
%  for i=1:popSize
%  pop.indiv(i).value=buffer{MIind(i)}; 
%  pop.indiv(i).rand=rnd{MIind(i)};
%  end
%  pervMIMax=vMI(1); 
%    pervMIMax2=MIbest(1);
   else
   pervMIMax=vMI(1); 
   pervMIMax2=MIbest(1);
   end
   
     for u=1:RAND_END-RAND_START+1
      randomnumbers(u)=0.5;
      end     
%%%%%%%%%%%%%%%%%%%%%%%%%%     
  
  
  
 % for i=1:popSize
  % BestMI(i)=MI(MIind(i));
  %pop.indiv(i).value=buffer{MIind(i)};
  % pop.indiv(i).rand=rnd{MIind(i)};
  % pop.indiv(i).fit=fitss{MIind(i)};
   
   % for u=1:RAND_END-RAND_START+1
   %    randomnumbers(u)=0.5;
   % end
  %[a2 expr] = printIndiv_ver3(buffer{MIind(i)},1,varnumber,randomnumbers);
  %pop.indiv(i).expr=expr;
% end
  
for i=1:t
[a2 expr] = printIndiv_ver3(buffer2{i},1,varnumber,randomnumbers);
pop.indiv(i).expr=expr;
end

 MIone

end