
function [p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final(buffer,popSize,BSPlusJ,maxcrossMI,gen,C1,C2)

global RAND_END
S=load('temp_global_parallel');
RAND_END=S.RAND_END;

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
   
% Y = trainD(:,varnumber+1);
% ressum=0;

%  for j=1:popSize  
%      buffer1{k}{j}=buffer{j};
%      [result, pos] = run_Final(buffer1{k}{j},1,trainD,rnd{j},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
%      
% lambda=abs(corr(result,Y));
MI=0;
%      if isnan (MI(j))
%          MI(j)=0;
%      end
%      
%      if j>1
%      if j<10 && (round(MI(j)*10000)~=round(MI(j-1)*10000))
%      ressum=result+ressum;
%      end
%      else
%          ressum=result;
%      end
    
    
%  end
%reslambda=abs(corr(ressum,Y));
   alpha=0.24;
 [p0,p1,p11,p2,p22,p3,p33,p4,p44]=NewP_Final(buffer,popSize,MI,Par1,Par2,Par3,Par4,Par5,broth,n,alpha,BSPlusJ,maxcrossMI,gen,C1,C2);
 
end

  