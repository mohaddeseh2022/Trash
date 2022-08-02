
function [MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_method1(buffer,rnd,popSize,varnumber,trainD,fitnss)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %claculating CPD or conditional probability table
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 j=1;
 while j <= popSize  %identifying parent nodes up to 4 ancistors and brother and uncle nodes
                     %for each tree individual           
         n(j)=size(buffer{j},2);  
         
         for i=1:n(j)  %i is buffercounter 
            
             [Par11  broth1]=NodeParent_ver3(buffer{j}, i);
             [Par22 uncle11]=NodeParent_ver3(buffer{j}, Par11);
             [Par33 uncle22]=NodeParent_ver3(buffer{j}, Par22);
             [Par44 uncle33]=NodeParent_ver3(buffer{j}, Par33); 
             [Par55 uncle44]=NodeParent_ver3(buffer{j}, Par44); 
             
             
             if Par11~=0 
               Par1{j}(i)=buffer{j}(Par11);
             else
               Par1{j}(i)=0;
             end
             if Par22~=0 
               Par2{j}(i)=buffer{j}(Par22);
             else
               Par2{j}(i)=0;
             end
             if Par33~=0 
               Par3{j}(i)=buffer{j}(Par33);
             else
               Par3{j}(i)=0;
             end
             if Par44~=0 
               Par4{j}(i)=buffer{j}(Par44);
             else
               Par4{j}(i)=0;
             end
             if Par55~=0 
               Par5{j}(i)=buffer{j}(Par44);
             else
               Par5{j}(i)=0;
             end
             if broth1~=0 
               broth{j}(i)=buffer{j}(broth1);
             else
               broth{j}(i)=0;
             end
             if uncle11~=0 
               uncle1{j}(i)=buffer{j}(uncle11);
             else
               uncle1{j}(i)=0;
             end
             if uncle22~=0 
               uncle2{j}(i)=buffer{j}(uncle22);
             else
               uncle2{j}(i)=0;
             end
             if uncle33~=0 
               uncle3{j}(i)=buffer{j}(uncle33);
             else
               uncle3{j}(i)=0;
             end
             if uncle44~=0 
               uncle4{j}(i)=buffer{j}(uncle44);
             else
               uncle4{j}(i)=0;
             end
                
         end
           
          j=j+1;
 end
 
 %%%%%%%%%%%%%%%%%%%
 %calculating probability of each object of terminal and nonterminal sets
 %%%%%%%%%%%%%%%%%%%
 sum1=0;   
 Y = trainD(:,varnumber+1);
 
%  for j=1:popSize  %calculate the sum of mutual informations of trees output and the desired output
%      [result, pos] = run_ver3(buffer{j},1,trainD,rnd{j});
%     
%      %[h1,h2,MI1]=GMI(result',Y',min(result'),max(result'),min(Y'),max(Y'),2,1,5);
% %      [MI1] = MuInf(result',Y',min(result'),max(result'),min(Y'),max(Y'),10,10);
% %      %MI(j)=MI1;
% %      [MII1] = MuInf(Y',Y',min(Y'),max(Y'),min(Y'),max(Y'),10,10);
% %      [MII2]=MuInf(result',result',min(result'),max(result'),min(result'),max(result'),10,10);
% %      MI(j)=MI1/max(MII1,MII2); 
% %%7-6-98[MII,lambda]=MutualInfo(result,Y);
% lambda=abs(corr(result,Y));
% %%%%%%% lambda = MutualInformation(result,Y);
% %N=size(Y,1);
% %X=result;
% %[I_xy] = MuInf(X,Y,min(X),max(X),min(Y),max(Y),20,N);
% % [MII1,lambda]=MutualInfo(Y,Y);
% % [MII2,lambda]=MutualInfo(result,result);
% % [MII]=MII/max(MII1,MII2);
%      MI(j)=lambda;
%      if isnan (MI(j))
%          MI(j)=0;
%      end
%     
%      %if max(result)==min(result)
%      %MI(j)=0;
%      %end
%      %if ~(isreal(MI(j)))
%       %   MI(j)=0;
%     % end
% %      if isinf(MI(j))
% %          MI(j)=1000;
% %      end
%    
%      %sum1=sum1+MI(j);
%  %   
%  end

MI=fitnss;
   alpha=0.1;
  %p0=P0_ver3(buffer,popSize,MI,alpha);
 %[p1,p11]=P1_ver3(buffer,popSize,MI,Par1,Par2,broth,n,alpha);
 %[p2,p22]=P2_ver3(buffer,popSize,MI,Par1,Par2,Par3,broth,n,alpha);
 %[p3,p33]=P3_ver3(buffer,popSize,MI,Par1,Par2,Par3,Par4,broth,n,alpha);
 %[p4,p44]=P4_ver3(buffer,popSize,MI,Par1,Par2,Par3,Par4,Par5,broth,n);
 [p0,p1,p11,p2,p22,p3,p33,p4,p44]=NewP_ver3_method1(buffer,popSize,MI,Par1,Par2,Par3,Par4,Par5,broth,n,alpha);
end

  