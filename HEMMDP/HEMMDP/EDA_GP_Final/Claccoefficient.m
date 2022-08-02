 function [Coeff,BlockValue]=Claccoefficient(BlockValue,BlockRnd,BSPlusJ,trainD,Coeff,k,counter,e1,s1,Scount,Fcount,sigma,sigcount)

global RAND_START  RAND_END 

if counter==1
     j=1:10;
     
     iteration=k-1;
     iter=5*iteration;
     figure(5+iter)
    plot(j,-e1(j))
    title('Error of each block')
    xlabel('number of block')
    ylabel('RMSE of block')
   
    
    return
end 

%BlockValue is a Buffer. The best Buffers until now are stored in
%BlockValue
desiredresult = size(trainD,2);


if ((Scount/Fcount)>0.2 && sigcount>9)
sigma=sigma/0.9;
sigcount=0;
end

for j=1:10  %10 is the number of blocks in each stage 
     n(j)=size(BlockRnd{k}{j},2);  
     m(j)=size(BlockValue{k}{j},2);
end


for j=1:10 %10 is the number of blocks in each stage
    
     [result1, pos]=run_Final(BlockValue{k}{j},1,trainD,Coeff{k}{j},BlockValue,BSPlusJ,Coeff,k-1); %Coe is the Coefficients obtained for inner blocks. 
     e1(j)=cError(result1,trainD(:,desiredresult));
    
     count(1:10)=zeros(1,10);
     t=RAND_START;
    for i=1:m(j)
         if (RAND_START-1<BlockValue{k}{j}(i) && BlockValue{k}{j}(i)<RAND_END +1)  
             BlockValue{k}{j}(i)=t;
             t=t+1;
             count(j)=count(j)+1;
         end
    end
     
     if count(j)>0
     r = normrnd(0,sigma,1,count(j));
     u=1;
     for i=1:count(j)
        Coe{k}{j}(i)=Coeff{k}{j}(i)+r(u);
         u=u+1;
     end
     
    
    [result2, pos]=run_Final(BlockValue{k}{j},1,trainD,Coe{k}{j},BlockValue,BSPlusJ,Coeff,k-1);
    e2(j)=cError(result2,trainD(:,desiredresult));
    
     else
       Coe{k}{j}(i)=BlockRnd{k}{j}(i); %dummy
       e2(j)=e1(j);
     end
    
    
end  

s2=-mean(e2)
s1=-mean(e1)

u=0;
for j=1:10
 %if s2<s1  
  if -e2(j)<-e1(j)
   Coeff{k}{j}=Coe{k}{j};  
   u=u+1;
  end
    
end

if (u>2)
    Scount=Scount+1;
end
Fcount=Fcount+1;

sigcount=sigcount+1;
%try to make it a correct iterative program
[Coeff,BlockValue]=Claccoefficient(BlockValue,Coeff,BSPlusJ,trainD,Coeff,k,counter-1,e1,s1,Scount,Fcount,sigma,sigcount);
          
end


%r = normrnd(0,sigma,1,count);



