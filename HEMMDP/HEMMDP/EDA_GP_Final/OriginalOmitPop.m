function [Fbuffer,Frnd,popS,flag,flag2]=OmitPop(buffer,rnd,popSize,trainD,validD,BlockValue,BSPlusJ,Coeff,k,Block_result)
Fbuffer=cell(550,1);
Fbuffer{550,1}=[];
Frnd=cell(550,1);
Frnd{550,1}=[];
C2=zeros(1,550);
C1=C(buffer,rnd,trainD,validD,popSize,1000000,BlockValue,BSPlusJ,Coeff,k,Block_result);
u=1;
flag=0;
nonbasecount=0;
flag2=0;
%parpool
for j=1:popSize
    
 h=0;  
    for l=1:popSize
        if l==j
            continue;
        else
            h=h+1;
        end
        buff{h}=buffer{l};
        rn{h}=rnd{l};
    end
    C2(j)=C(buff,rn,trainD,validD,popSize-1,100000000000,BlockValue,BSPlusJ,Coeff,k,Block_result);
   % C2(j)=C(buffer,rnd,trainD,validD,popSize,j,BlockValue,BSPlusJ,Coeff,k,Block_result);
     if (C1-C2(j))<0
         flag=1;
     end
         
    if (C1-C2(j))>=0
        flag2=1;
        Fbuffer{u}=buffer{j};
        Frnd{u}=rnd{j};
        u=u+1;
    end
        
end
if flag2==1
popS=u-1;
else
    popS=popSize;
    Fbuffer=buffer;
    Frnd=rnd;

end

