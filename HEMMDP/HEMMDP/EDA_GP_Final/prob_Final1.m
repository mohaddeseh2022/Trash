
% function [p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1(buffer,rnd,popSize,varnumber,trainD,BlockValue,BSPlusJ,Coeff,k,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44,maxcrossMI,Block_result,gen,C1,C2)
% 
% global RAND_END
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %claculating CPD or conditional probability table
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  j=1;
%  while j <= popSize  %identifying parent nodes up to 4 ancistors and brother and uncle nodes
%                      %for each tree individual           
%          n(j)=size(buffer{j},2);  
%          
%          for i=1:n(j)  %i is buffercounter 
%             
%              [Par11  broth1]=NodeParent_Final(buffer{j}, i);
%              [Par22 uncle11]=NodeParent_Final(buffer{j}, Par11);
%              [Par33 uncle22]=NodeParent_Final(buffer{j}, Par22);
%              [Par44 uncle33]=NodeParent_Final(buffer{j}, Par33); 
%              [Par55 uncle44]=NodeParent_Final(buffer{j}, Par44); 
%              
%              
%              if Par11~=0 
%                Par1{j}(i)=buffer{j}(Par11);
%              else
%                Par1{j}(i)=0;
%              end
%              if Par22~=0 
%                Par2{j}(i)=buffer{j}(Par22);
%              else
%                Par2{j}(i)=0;
%              end
%              if Par33~=0 
%                Par3{j}(i)=buffer{j}(Par33);
%              else
%                Par3{j}(i)=0;
%              end
%              if Par44~=0 
%                Par4{j}(i)=buffer{j}(Par44);
%              else
%                Par4{j}(i)=0;
%              end
%              if Par55~=0 
%                Par5{j}(i)=buffer{j}(Par44);
%              else
%                Par5{j}(i)=0;
%              end
%              if broth1~=0 
%                broth{j}(i)=buffer{j}(broth1);
%              else
%                broth{j}(i)=0;
%              end
%              if uncle11~=0 
%                uncle1{j}(i)=buffer{j}(uncle11);
%              else
%                uncle1{j}(i)=0;
%              end
%              if uncle22~=0 
%                uncle2{j}(i)=buffer{j}(uncle22);
%              else
%                uncle2{j}(i)=0;
%              end
%              if uncle33~=0 
%                uncle3{j}(i)=buffer{j}(uncle33);
%              else
%                uncle3{j}(i)=0;
%              end
%              if uncle44~=0 
%                uncle4{j}(i)=buffer{j}(uncle44);
%              else
%                uncle4{j}(i)=0;
%              end
%                 
%          end
%            
%           j=j+1;
%  end
%  
%  %%%%%%%%%%%%%%%%%%%
%  %calculating probability of each object of terminal and nonterminal sets
%  %%%%%%%%%%%%%%%%%%%
%    
% %  Y = trainD(:,varnumber+1);
% %  ressum=0;
% %  for j=1:popSize  %calculate the sum of mutual informations of trees output and the desired output
% %      buffer1{k}{j}=buffer{j};
% %     %%%[buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,j,buffer1);
% %      [result, pos] = run_Final(buffer1{k}{j},1,trainD,rnd{j},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
% % lambda=abs(corr(result,Y));
%  MI=0;
% %      MI(j)=lambda;
% %      if isnan (MI(j))
% %          MI(j)=0;
% %      end
% %      
% %      if j>1
% %      if j<10 && (round(MI(j)*10000)~=round(MI(j-1)*10000) && round(MI(j)*10000)<0.985*round(MI(j-1)*10000))
% %      ressum=result+ressum;
% %      end
% %      else
% %          ressum=result;
% %      end
% %     
% %  end
% % reslambda=abs(corr(ressum,Y));
%    alpha=0.24;
%   
%  [PTr]=TreeProb(buffer,popSize,Par1,Par2,Par3,Par4,Par5,broth,n,BSPlusJ,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44);
%  [p0,p1,p11,p2,p22,p3,p33,p4,p44]=NewP_Final1(buffer,popSize,MI,PTr,Par1,Par2,Par3,Par4,Par5,broth,n,alpha,BSPlusJ,maxcrossMI,gen,C1,C2);
% 
% end
% 
% 
% 
% 
% 
% 


function [p0,p1,p11,p2,p22,p3,p33,p4,p44,Ex0,Ex1]=prob_Final1(buffer,rnd,popSize,varnumber,trainD,BlockValue,BSPlusJ,Coeff,k,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44,Block_result,gen,alph,C1,C2)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %claculating CPD or conditional probability table
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 j=1;
 while j <= popSize  %identifying parent nodes up to 4 ancistors and brother and uncle nodes
                     %for each tree individual           
         n(j)=size(buffer{j},2);  
         
         for i=1:n(j)  %i is buffercounter 
            
             [Par11  broth1]=NodeParent_Final(buffer{j}, i);
             [Par22 uncle11]=NodeParent_Final(buffer{j}, Par11);
             [Par33 uncle22]=NodeParent_Final(buffer{j}, Par22);
             [Par44 uncle33]=NodeParent_Final(buffer{j}, Par33); 
             [Par55 uncle44]=NodeParent_Final(buffer{j}, Par44); 
             
             
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
   
 Y = trainD(:,varnumber+1);

%  for j=1:popSize  %calculate the sum of mutual informations of trees output and the desired output
%      buffer1{k}{j}=buffer{j};
%     %%%[buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,j,buffer1);
%      [result, pos] = run_Final(buffer1{k}{j},1,trainD,rnd{j},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
%      %%% [result, pos]=run_verComb(buffer1{k}{j},1,trainD,rnd{j},RAND_END);
%      %[h1,h2,MI1]=GMI(result',Y',min(result'),max(result'),min(Y'),max(Y'),2,1,5);
% %      [MI1] = MuInf(result',Y',min(result'),max(result'),min(Y'),max(Y'),10,10);
% %      %MI(j)=MI1;
% %      [MII1] = MuInf(Y',Y',min(Y'),max(Y'),min(Y'),max(Y'),10,10);
% %      [MII2]=MuInf(result',result',min(result'),max(result'),min(result'),max(result'),10,10);
% %      MI(j)=MI1/max(MII1,MII2); 
% %%7-6-98[MII,lambda]=MutualInfo(result,Y);
% lambda=abs(corr(result,Y));
%  %%%%%%lambda = MutualInformation(result,Y);
% % N=size(Y,1);
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
%     
%      %if max(result)==min(result)
%      %MI(j)=0;
%      %end
%     % if ~(isreal(MI(j)))
%      %    MI(j)=0;
%      %end
% %      if isinf(MI(j))
% %          MI(j)=1000;
% %      end
%    
%   
%  end

   alpha=0.24;
  
 [PTr]=TreeProb(buffer,popSize,Par1,Par2,Par3,Par4,Par5,broth,n,BSPlusJ,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44);
 [p0,p1,p11,p2,p22,p3,p33,p4,p44,Ex0,Ex1]=NewP_Final1(buffer,popSize,1,PTr,Par1,Par2,Par3,Par4,Par5,broth,n,alpha,BSPlusJ,gen,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44,alph,C1,C2);

end

  

  

  