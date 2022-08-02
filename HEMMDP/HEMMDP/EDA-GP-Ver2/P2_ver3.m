function [p2,p22]=P2_ver3(buffer,popSize,MI,par1,par2,par3,broth,n,alpha)

global FSET_END RAND_END

S=load('temp_global_parallel');
FSET_END=S.FSET_END;
RAND_END=S.RAND_END;


 A2=zeros(RAND_END,FSET_END,FSET_END);
 sum2=zeros(FSET_END,FSET_END);
 A22=zeros(RAND_END,FSET_END,FSET_END,RAND_END);
 sum22=zeros(FSET_END,FSET_END,RAND_END);

for j=1:popSize
    for i=1:n(j)
        if (par3{j}(i)==0 && par2{j}(i)~=0)
            for h=1:RAND_END
                for k=1:FSET_END
                    for u=1:FSET_END
                       if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u)
                           if broth{j}(i)==0
                               A2(h,k,u)=A2(h,k,u)+MI(j);
                               sum2(k,u)=sum2(k,u)+MI(j);
                           else
                               for b=1:RAND_END
                                  if broth{j}(i)==b
                                      A22(h,k,u,b)=A22(h,k,u,b)+MI(j);
                                      sum22(k,u,b)=sum22(k,u,b)+MI(j);
                                  end
                               end
                           end
                       end
                    end
                end
            end
        end
    end
end


p2=zeros(RAND_END,FSET_END,FSET_END);
p22=zeros(RAND_END,FSET_END,FSET_END,RAND_END);

for h=1:RAND_END
    for k=1:FSET_END
        for u=1:FSET_END
           if sum2(k,u)~=0
             p2(h,k,u)=A2(h,k,u)/sum2(k,u);
           else
             p2(h,k,u)=0;
           end
        end
    end
end

% p2=(1-alpha)*p2+alpha*(1/6);

for k=1:FSET_END
    for u=1:FSET_END
    if p2(:,k,u)==0;
      p2(:,k,u)=1/RAND_END;  
    else
    p2(:,k,u)=(1-alpha)*p2(:,k,u)+alpha*(1/RAND_END);
    end
end
end


for h=1:RAND_END
    for k=1:FSET_END
       for u=1:FSET_END
        for b=1:RAND_END
            if sum22(k,u,b)~=0
                 p22(h,k,u,b)=A22(h,k,u,b)/sum22(k,u,b);
            else
                 p22(h,k,u,b)=0;
            end
        end
                
      end
    end
end



for k=1:FSET_END
    for u=1:FSET_END
        for b=1:RAND_END
    if p22(:,k,u,b)==0;
      p22(:,k,u,b)=1/RAND_END;  
    else
    p22(:,k,u,b)=(1-alpha)*p22(:,k,u,b)+alpha*(1/RAND_END);
    end
end
    end
end




%p22=(1-alpha)*p22+alpha*(1/6);




