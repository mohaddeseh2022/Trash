function [maxcrossMI]=Maxcrossmutual_Final_2(buffer,rnd,popSize,trainD,BlockValue,BSPlusJ,Coeff,k,Block_result)
 global  RAND_END
maxcrossMI=zeros(1,popSize);
for j=1:popSize   
      buffer1{k}{j}=buffer{j};
     [result1(:,j), pos] = run_Final(buffer1{k}{j},1,trainD,rnd{j},BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
end

meanRes1=mean(result1);
VplusT=var(meanRes1);

for j=1:popSize    
    
    if (j>1 && j<popSize)
      Res2=horzcat(result1(:,1:j-1),result1(:,j+1:popSize));
      elseif j==1
      Res2=result1(:,j+1:popSize);
      elseif j==popSize
       Res2=result1(:,1:j-1);
    end
     
    meanRes2=mean(Res2);
    VminT=var(meanRes2);
    
    if VplusT-VminT>0
        lambda=1/(VplusT-VminT);
    else
          lambda=100000000000; % lambda=0;
    end
      
      maxcrossMI(j)=lambda;
        
         if isnan (maxcrossMI(j))
            maxcrossMI(j)=100000000000;%maxcrossMI(j)=0;
         end
            
%  if maxcrossMI(j)==0 
%      maxcrossMI(j)=0.00000000000000000000001;
%  end
%  
end
