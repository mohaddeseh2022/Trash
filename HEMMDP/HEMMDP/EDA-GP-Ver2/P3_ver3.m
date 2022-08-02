function [p3,p33]=P3_ver3(buffer,popSize,MI,par1,par2,par3,par4,broth,n,alpha)

global FSET_END  RAND_END
S=load('temp_global_parallel');
FSET_END=S.FSET_END;
RAND_END=S.RAND_END;
 A3=zeros(RAND_END,FSET_END,FSET_END,FSET_END);
 sum3=zeros(FSET_END,FSET_END,FSET_END);
 A33=zeros(RAND_END,FSET_END,FSET_END,FSET_END,RAND_END);
 sum33=zeros(FSET_END,FSET_END,FSET_END,RAND_END);

for j=1:popSize
    for i=1:n(j)
        if (par4{j}(i)==0 && par3{j}(i)~=0)
            for h=1:RAND_END
                for k=1:FSET_END
                    for u=1:FSET_END
                        for v=1:FSET_END
                           if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v)
                               if broth{j}(i)==0
                                  A3(h,k,u,v)=A3(h,k,u,v)+MI(j);
                                  sum3(k,u,v)=sum3(k,u,v)+MI(j);
                               else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                       A33(h,k,u,v,b)=A33(h,k,u,v,b)+MI(j);
                                       sum33(k,u,v,b)=sum33(k,u,v,b)+MI(j);
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
end


p3=zeros(RAND_END,FSET_END,FSET_END,FSET_END);
p33=zeros(RAND_END,FSET_END,FSET_END,FSET_END,RAND_END);

for h=1:RAND_END
    for k=1:FSET_END
        for u=1:FSET_END
            for v=1:FSET_END
              if sum3(k,u,v)~=0
                p3(h,k,u,v)=A3(h,k,u,v)/sum3(k,u,v);
              else
               p3(h,k,u,v)=0;
              end
            end
        end
    end
end
%p3=(1-alpha)*p3+alpha*(1/6);

for k=1:FSET_END
    for u=1:FSET_END
        for v=1:FSET_END
    if p3(:,k,u,v)==0;
      p3(:,k,u,v)=1/RAND_END;  
    else
    p3(:,k,u,v)=(1-alpha)*p3(:,k,u,v)+alpha*(1/RAND_END);
    end
end
    end
end


for h=1:RAND_END
    for k=1:FSET_END
       for u=1:FSET_END
           for v=1:FSET_END
             for b=1:RAND_END
                if sum33(k,u,v,b)~=0
                    p33(h,k,u,v,b)=A33(h,k,u,v,b)/sum33(k,u,v,b);
                else
                    p33(h,k,u,v,b)=0;
                end
             end
                
           end
       end
    end
end
%p33=(1-alpha)*p33+alpha*(1/6);

for k=1:FSET_END
    for u=1:FSET_END
        for v=1:FSET_END
            for b=1:RAND_END
    if p33(:,k,u,v,b)==0;
      p33(:,k,u,v,b)=1/RAND_END;  
    else
    p33(:,k,u,v,b)=(1-alpha)*p33(:,k,u,v,b)+alpha*(1/RAND_END);
    end
end
    end
    end
end






