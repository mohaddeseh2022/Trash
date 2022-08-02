
function [SMI,MIind,Sbuffer,Srnd,NSvarMI]=sortMI(buffer,rnd,popSize,varnumber,validD,trainD,BlockValue,k,flag)
S=load('temp_global_parallel');
RAND_END=S.RAND_END;
Y = trainD(:,varnumber+1);
Sbuffer{popSize}=[];
Srnd{popSize}=[];
 for j=1:popSize   
      buffer1{k}{j}=buffer{j};
      if k>1
     [buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,j,buffer1);
    [result, pos]=run_verComb(buffer1{k}{j},1,trainD,rnd{j},RAND_END);
      else
     [result, pos] = run_ver3(buffer{j},1,trainD,rnd{j});
      end
      if j==1
          Re=result;
      end
      if j>1
      Re=horzcat(Re,result);
      end
%  lambda=abs(corr(result,Y));
%       MI(j)=lambda;
%      if isnan(MI(j))
%          MI(j)=0;
%      end
 end
 MI=abs(corr(Re,Y));
 MI(isnan(MI))=0;
 varMI=abs(corr(Re,Re));
 varMI(isnan(varMI))=0;
 SvarMI=sum(varMI,2);
 NSvarMI=SvarMI/sum(SvarMI);
 if flag==1
FMI=MI;%./NSvarMI;
 else
 FMI=MI;
 end 
  FMI(isnan(FMI))=0;
  [SMI,MIind]=sort(FMI,'descend');
  for i=1:popSize
  Sbuffer{i}=buffer{MIind(i)}; 
 Srnd{i}=rnd{MIind(i)};
  end