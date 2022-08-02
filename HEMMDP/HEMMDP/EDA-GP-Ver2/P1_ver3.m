function [p1,p11]=P1_ver3(buffer,popSize,MI,par1,par2,broth,n,alpha)

global FSET_END RAND_END

S=load('temp_global_parallel');

FSET_END=S.FSET_END;
RAND_END=S.RAND_END;

 A1=zeros(RAND_END,FSET_END);
 sum1=zeros(1,FSET_END);
 A11=zeros(RAND_END,FSET_END,RAND_END);
 sum11=zeros(FSET_END,RAND_END);

for j=1:popSize
    for i=1:n(j)
        if (par2{j}(i)==0 && par1{j}(i)~=0)
            for h=1:RAND_END
                for k=1:FSET_END
                    if (buffer{j}(i)==h && par1{j}(i)==k)
                        if broth{j}(i)==0
                            A1(h,k)=A1(h,k)+MI(j);
                            sum1(k)=sum1(k)+MI(j);
                        else
                            for b=1:6
                                if broth{j}(i)==b
                                    A11(h,k,b)=A11(h,k,b)+MI(j);
                                    sum11(k,b)=sum11(k,b)+MI(j);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

p1=zeros(RAND_END,FSET_END);
p11=zeros(RAND_END,FSET_END,RAND_END);

for h=1:RAND_END
    for k=1:FSET_END
        if sum1(k)~=0
          p1(h,k)=A1(h,k)/sum1(k);
        else
          p1(h,k)=0;
        end
    end
end

for k=1:FSET_END
    if p1(:,k)==0;
      p1(:,k)=1/RAND_END;  
    else
    p1(:,k)=(1-alpha)*p1(:,k)+alpha*(1/RAND_END);
    end
end




for h=1:RAND_END
    for k=1:FSET_END
        for b=1:RAND_END
            if sum11(k,b)~=0
                 p11(h,k,b)=A11(h,k,b)/sum11(k,b);
            else
                 p11(h,k,b)=0;
            end
                
        end
    end
end


for k=1:FSET_END
    for b=1:RAND_END
    if p11(:,k,b)==0;
      p11(:,k,b)=1/RAND_END;  
    else
    p11(:,k,b)=(1-alpha)*p11(:,k,b)+alpha*(1/RAND_END);
    end
    end
end

%p11=(1-alpha)*p11+alpha*(1/6);





        