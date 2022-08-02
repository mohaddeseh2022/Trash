function [p1,p11]=P1_Final(buffer,popSize,MI,par1,par2,broth,n,alpha,BSPlusJ)

global  FSET_END 
S=load('temp_global_parallel');
FSET_END=S.FSET_END;
%FSET_END =4;
 A1=zeros(BSPlusJ,FSET_END);
 sum1=zeros(1,FSET_END);
 A11=zeros(BSPlusJ,FSET_END,BSPlusJ);
 sum11=zeros(FSET_END,BSPlusJ);
FS_END=FSET_END;

for j=1:popSize
    M=MI(j);
    PT=PTi(j);
    for i=1:n(j)
        if (par2{j}(i)==0 && par1{j}(i)~=0)
            for h=1:BSPlusJ
                for k=1:FS_END
                    if (buffer{j}(i)==h && par1{j}(i)==k)
                        if broth{j}(i)==0
                            A1(h,k)=A1(h,k)+(M*PT);
                            sum1(k)=sum1(k)+(M*PT);
                        else
                            for b=1:BSPlusJ     %for b=1:6
                                if broth{j}(i)==b
                                    A11(h,k,b)=A11(h,k,b)+(M*PT);
                                    sum11(k,b)=sum11(k,b)+(M*PT);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

p1=zeros(BSPlusJ,FSET_END);
p11=zeros(BSPlusJ,FSET_END,BSPlusJ);

for h=1:BSPlusJ
   for k=1:FS_END
        if sum1(k)~=0
          p1(h,k)=A1(h,k)/sum1(k);
        else
          p1(h,k)=0;
        end
    end
end

for k=1:FS_END
    if p1(:,k)==0
      p1(:,k)=1/BSPlusJ;  
    else
    p1(:,k)=(1-alpha)*p1(:,k)+alpha*(1/BSPlusJ);
    end
end




for h=1:BSPlusJ
    for k=1:FS_END
        for b=1:BSPlusJ
            C=sum11(k,b);
            if C~=0
                 p11(h,k,b)=A11(h,k,b)/C;
            else
                 p11(h,k,b)=0;
            end
                
        end
    end
end


for k=1:FS_END
    for b=1:BSPlusJ
    if p11(:,k,b)==0
      p11(:,k,b)=1/BSPlusJ;  
    else
    p11(:,k,b)=(1-alpha)*p11(:,k,b)+alpha*(1/BSPlusJ);
    end
    end
end

%p11=(1-alpha)*p11+alpha*(1/6);





        