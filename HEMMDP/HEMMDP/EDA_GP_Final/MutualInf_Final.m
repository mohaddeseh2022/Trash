function [MIbest,MIone,MIp,Trpop,pop,FinalRing,pervMIMax,pervMIMax2,t,tt,MI]=MutualInf_Final(buffer,rnd,popSize,varnumber,validD,trainD,fitss,BlockValue,BSPlusJ,Coeff,k,pervMIMax,pervMIMax2,Block_result)

S=load('temp_global_parallel');
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;



%  RAND_START=53;
%  RAND_END=53;
Y = trainD(:,varnumber+1);
Yp=validD(:,varnumber+1);
 for j=1:popSize   
      buffer1{k}{j}=buffer{j};
     [buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,j,buffer1);
     %%%[result, pos] = run_Final(buffer1{k}{j},1,trainD,rnd{j},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
    [result, pos]=run_verComb(buffer1{k}{j},1,trainD,rnd{j},RAND_END);
     %[h1,h2,MII]=GMI(result',Y',min(result'),max(result'),min(Y'),max(Y'),2,1,5);
     %result1(j)=result;
%    [MII] = MuInf(result',Y',min(result'),max(result'),min(Y'),max(Y'),10,10);
%    [MII1] = MuInf(Y',Y',min(Y'),max(Y'),min(Y'),max(Y'),10,10);
%    [MII2]=MuInf(result',result',min(result'),max(result'),min(result'),max(result'),10,10);
%    [MII]=MII/max(MII1,MII2);   
%%7-6-98 [MII,lambda]=MutualInfo(result,Y);
if j==1
Re=result;
end
if j>1
Re=horzcat(Re,result);
end
%  lambda=abs(corr(result,Y));
% 
%  %%%%%%lambda = MutualInformation(result,Y);
% %N=size(Y,1);
% %X=result;
% %[I_xy] = MuInf(X,Y,min(X),max(X),min(Y),max(Y),20,N);
% % [MII1,lambda]=MutualInfo(Y,Y);
% % [MII2,lambda]=MutualInfo(result,result);
% % [MII]=MII/max(MII1,MII2);
%       %MI(j)=MII;
%       MI(j)=lambda;
%      if isnan(MI(j))
%          MI(j)=0;
%      end
%      
%      %if ~(isreal(MI(j)))
%       %   MI(j)=0;
%      %end
% %      if isinf(MI(j)) %infenity is the best MI, if it happens. So putting
% %      zero instead is not correct.putting a big number is more logical
% %          MI(j)=1000;
% %      end
%          
%      %if (max(result)==min(result)|| isinf(sum(result)))
%      %MI(j)=0;
%      %end
   
 end
MI=abs(corr(Re,Y));
MI(isnan(MI))=0;

  [MIone,MIind]=sort(MI,'descend');
 %%%%%%%%%%%%%%%%%% 
 %if both results validation and train data are fine we choose best buffer
 %calculated from train data as best buffer and 9 other buffers (if
 %available) totally as the 10 best buffers.
 i=0;
 while (i<popSize)
       i=i+1;
   buffer1{k}{MIind(i)}=buffer{MIind(i)};
     [buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,MIind(i),buffer1);
    [resultp, pos]=run_verComb(buffer1{k}{MIind(i)},1,validD,rnd{MIind(i)},RAND_END);
     lambdap=abs(corr(resultp,Yp));
    MIp(i)=lambdap;
     if isnan (MIp(i))
        MIp(i)=0;
     end
 end
 
  count=0; %we need 10 best buffers
  i=0;
  t=0;
  tt=0;
   while (i<popSize && count<10)
       i=i+1;
    %buffer1{k}{MIind(i)}=buffer{MIind(i)};
     %[buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,MIind(i),buffer1);
    %[resultp, pos]=run_verComb(buffer1{k}{MIind(i)},1,validD,rnd{MIind(i)},RAND_END);
   %%7-6-98 [MIIp,lambdap]=MutualInfo(resultp,Yp);
   %lambdap=abs(corr(resultp,Yp));
    %MIp=lambdap;
     %if isnan (MIp)
        % MIp=0;
     %end
     if (MIp(i)>=pervMIMax && MIone(i)>=pervMIMax2)
         t=t+1
         vMI(t)=MIp(i); 
         pop.indiv(t).value=buffer{MIind(i)}; %buffer1{k}{MIind(i)};
         pop.indiv(t).rand=rnd{MIind(i)};
         %pop.indiv(t).fit=fitss{MIind(i)};
         
         buffer2{k}{t}=buffer{MIind(i)};
         
         MIbest(t)=MIone(i);
         count=count+1; 
     end   
     
   end  
if t==0   
disp('t==============================================================0')
pop.indiv(1).value=RAND_START; 
pop.indiv(1).rand=0.5;
pop.indiv(1).expr=0.5;
t=1;
end
  for i=1:popSize
  % if (MIone(i)>=pervMIMax2)
         tt=tt+1
         Trpop.indiv(tt).value=buffer{MIind(i)}; 
         Trpop.indiv(tt).rand=rnd{MIind(i)};
         %Trpop.indiv(tt).fit=fitss{MIind(i)};
        
     % end
   end
  
%%%%%%%%%%%%%%%%%%%%%%%%   
    FinalRing=0; %Stop program execution
   if (count==0)
       FinalRing=1;
       MIbest=0;
   else
   pervMIMax=vMI(1); 
   pervMIMax2=MIbest(1);
   end
   
     for u=1:RAND_END-RAND_START+1
      randomnumbers(u)=0.5;
      end     
%%%%%%%%%%%%%%%%%%%%%%%%%%         
   
   
 % for i=1:popSize
 %  BestMI(i)=MI(MIind(i));
%  pop.indiv(i).value=buffer{MIind(i)};
 %  pop.indiv(i).rand=rnd{MIind(i)};
%   pop.indiv(i).fit=fitss{MIind(i)};
 %  for u=1:RAND_END-RAND_START+1
   %    randomnumbers(u)=0.5;
   %end
   % buffer2{k}{i}=buffer{MIind(i)};
 % end
  
  %for i=1:t %instead of i=1:popSize
   % buffer2=CalccoefficientFinal(BlockValue,k,i,buffer2);
  %[a2 expr] = printIndiv_Final(buffer2{k}{i},1,varnumber,randomnumbers,BlockValue,BSPlusJ,Coeff,k-1);
  %pop.indiv(i).expr=expr;
  %end
 
end
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% function [MIbest,MIone,MIp,Trpop,pop,FinalRing,pervMIMax,newpervMIMax2,pervMIMax2,t,tt]=MutualInf_Final(buffer,rnd,popSize,varnumber,validD,trainD,fitss,BlockValue,BSPlusJ,Coeff,k,pervMIMax,newpervMIMax2,pervMIMax2,Block_result,maxcrossMI)
%  global  RAND_START  RAND_END %%this MIone is different from MIone in main
% Y = trainD(:,varnumber+1);
% Yp=validD(:,varnumber+1);
% for k=1:popSize
%  b(k)=(popMI(k)/VmaxcrossMI(k));  
% end
% beta=min(b)+0.1;
%  for j=1:popSize   
%       buffer1{k}{j}=buffer{j};
%      %%[buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,j,buffer1);
%      [result, pos] = run_Final(buffer1{k}{j},1,trainD,rnd{j},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
%     %%[result, pos]=run_verComb(buffer1{k}{j},1,trainD,rnd{j},RAND_END);
%      %[h1,h2,MII]=GMI(result',Y',min(result'),max(result'),min(Y'),max(Y'),2,1,5);
%      %result1(j)=result;
% %    [MII] = MuInf(result',Y',min(result'),max(result'),min(Y'),max(Y'),10,10);
% %    [MII1] = MuInf(Y',Y',min(Y'),max(Y'),min(Y'),max(Y'),10,10);
% %    [MII2]=MuInf(result',result',min(result'),max(result'),min(result'),max(result'),10,10);
% %    [MII]=MII/max(MII1,MII2);   
% %%7-6-98 [MII,lambda]=MutualInfo(result,Y);
% size(result)
% size(Y)
%  lambda=abs(corr(result,Y));
% 
%  %%%%%%lambda = MutualInformation(result,Y);
% %N=size(Y,1);
% %X=result;
% %[I_xy] = MuInf(X,Y,min(X),max(X),min(Y),max(Y),20,N);
% % [MII1,lambda]=MutualInfo(Y,Y);
% % [MII2,lambda]=MutualInfo(result,result);
% % [MII]=MII/max(MII1,MII2);
%       %MI(j)=MII;
%       MI(j)=lambda;
%      if isnan (MI(j))
%          MI(j)=0;
%      end
%      
%      %if ~(isreal(MI(j)))
%       %   MI(j)=0;
%      %end
% %      if isinf(MI(j)) %infenity is the best MI, if it happens. So putting
% %      zero instead is not correct.putting a big number is more logical
% %          MI(j)=1000;
% %      end
%          
%      %if (max(result)==min(result)|| isinf(sum(result)))
%      %MI(j)=0;
%      %end
%   %newMI(j)=MI(j)/maxcrossMI(j); 
%   newMI(j)=MI(j)-beta*maxcrossMI(j);
%  end
%  
%  
%   [MIone,MIind]=sort(newMI,'descend');
%   [MI2,MIind2]=sort(MI,'descend');
%  %%%%%%%%%%%%%%%%%% 
%  %if both results validation and train data are fine we choose best buffer
%  %calculated from train data as best buffer and 9 other buffers (if
%  %available) totally as the 10 best buffers.
%  i=0;
%  while (i<popSize)
%        i=i+1;
%    buffer1{k}{MIind(i)}=buffer{MIind(i)};
%      [buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,MIind(i),buffer1);
%     [resultp, pos]=run_verComb(buffer1{k}{MIind(i)},1,validD,rnd{MIind(i)},RAND_END);
%      lambdap=abs(corr(resultp,Yp));
%     MIp(i)=lambdap;
%      if isnan (MIp(i))
%         MIp(i)=0;
%      end
%      %MIp(i)=MIp(i)/maxcrossMI(MIind(i));
%  end
%  
%   count=0; %we need 10 best buffers
%   i=0;
%   t=0;
%   tt=0;
%    while (i<popSize && count<10)
%        i=i+1;
%     %buffer1{k}{MIind(i)}=buffer{MIind(i)};
%      %[buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,MIind(i),buffer1);
%     %[resultp, pos]=run_verComb(buffer1{k}{MIind(i)},1,validD,rnd{MIind(i)},RAND_END);
%    %%7-6-98 [MIIp,lambdap]=MutualInfo(resultp,Yp);
%    %lambdap=abs(corr(resultp,Yp));
%     %MIp=lambdap;
%      %if isnan (MIp)
%         % MIp=0;
%      %end
%      if ( MIone(i)>=newpervMIMax2) %MIp(i)>=pervMIMax &&
%          t=t+1
%          vMI(t)=MIp(i); 
%          pop.indiv(t).value=buffer{MIind(i)}; 
%          pop.indiv(t).rand=rnd{MIind(i)};
%          %pop.indiv(t).fit=fitss{MIind(i)};
%          
%          buffer2{k}{t}=buffer{MIind(i)};
%          
%          MIbest(t)=MIone(i);
%          count=count+1; 
%      end   
%      
%    end  
%    MIb=pervMIMax2; 
%    i=0;
%    if t==0
%        vMI=pervMIMax;
%        MIbest=newpervMIMax2;
%        while (i<popSize && t<10)
%        i=i+1;     
%        if (MI2(i)>=pervMIMax2 && MIp(i)>=pervMIMax)
%          t=t+1;
%          pop.indiv(t).value=buffer{MIind2(i)}; 
%          pop.indiv(t).rand=rnd{MIind2(i)};
%          MIb(t)=MI2(i);
%          
%        end
%        end  
%    end
%    
%   if t==0
%     while (i<popSize && t<10)
%        i=i+1;     
%        if (MI2(i)>=pervMIMax2)
%          t=t+1;
%          pop.indiv(t).value=buffer{MIind2(i)}; 
%          pop.indiv(t).rand=rnd{MIind2(i)};
%          MIb(t)=MI2(i);
%          
%        end
%     end 
%      if t==0
%          t=1;
%         pop.indiv(1).value=buffer{MIind2(1)}; 
%          pop.indiv(1).rand=rnd{MIind2(1)};
%      end
%   end  
%    
%   for i=1:popSize
%   % if (MIone(i)>=pervMIMax2)
%          tt=tt+1
%          Trpop.indiv(tt).value=buffer{MIind(i)}; 
%          Trpop.indiv(tt).rand=rnd{MIind(i)};
%          %Trpop.indiv(tt).fit=fitss{MIind(i)};
%         
%      % end
%    end
%   
% %%%%%%%%%%%%%%%%%%%%%%%%   
%     FinalRing=0; %Stop program execution
%    %if (count==0)
%     %   FinalRing=1;
%      %  MIbest=0;
%    %else
%    pervMIMax=vMI(1); 
%    newpervMIMax2=MIbest(1);
%    pervMIMax2=MIb(1);
%   % end
%    
%      for u=1:RAND_END-RAND_START+1
%       randomnumbers(u)=0.5;
%       end     
% %%%%%%%%%%%%%%%%%%%%%%%%%%         
%    
%    
% 
%  
% end
%   
% 
