 function [FBlock,Coeff,e1]=Calccoefficient2(FBlock,BlockRnd,BlockValue,BSPlusJ,trainD,Coeff,k,j)
global RAND_START  
RAND_END=2000;
desiredresult = size(trainD,2);

Scount=0;
Fcount=1;
sigma=0.1;
sigcount=0;
countt=0;
n=size(BlockRnd{k}{j},2);  
m=size(FBlock{k}{j},2);
t=RAND_START;
    for i=1:m
         if (RAND_START-1<FBlock{k}{j}(i) && FBlock{k}{j}(i)<RAND_END +1)  
             FBlock{k}{j}(i)=t;
             t=t+1;
             countt=countt+1
         end
    end
     
for i=1:RAND_END-RAND_START+1
     Coeff{k}{j}(i)=0.5;
end
check=0;    
for counter=1:25000
%while check==0
    
if ((Scount/Fcount)>0.2 && sigcount>9)
sigma=sigma/0.85;
sigcount=0;
end



%[result1, pos]=run_Final(FBlock{k}{j},1,trainD,Coeff{k}{j},BlockValue,BSPlusJ,Coeff,k-1,RAND_END); %Coe is the Coefficients obtained for inner blocks.
[result1, pos]=run_verComb(FBlock{k}{j},1,trainD,Coeff{k}{j},RAND_END);     
e1=cError(result1,trainD(:,desiredresult));
    
    
    
     if countt>0
     r = normrnd(0,sigma,1,countt);
     u=1;
     for i=1:countt
        Coe{k}{j}(i)=Coeff{k}{j}(i)+r(u);
         u=u+1;
     end
    
    %[result2, pos]=run_Final(FBlock{k}{j},1,trainD,Coe{k}{j},BlockValue,BSPlusJ,Coeff,k-1,RAND_END);
    [result2, pos]=run_verComb(FBlock{k}{j},1,trainD,Coe{k}{j},RAND_END);
    e2=cError(result2,trainD(:,desiredresult));
    
     else
       Coe{k}{j}=BlockRnd{k}{j}; %dummy %%when there is no coefficient to be fixed
       e2=e1;
       break;
     end
     
    e22=-e2;
    e11=-e1;
    
  if e22<e11
  Coeff{k}{j}=Coe{k}{j};  
  Scount=Scount+1;
   
  %if (e22>=(e11-(0.01*e11)))
      %check=1;
  %end
  end 
Fcount=Fcount+1;

sigcount=sigcount+1;  
end  


 

end

