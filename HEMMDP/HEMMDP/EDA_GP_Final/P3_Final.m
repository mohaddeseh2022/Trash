function [p3,p33]=P3_Final(buffer,popSize,MI,par1,par2,par3,par4,broth,n,alpha,BSPlusJ)

global FSET_END

S=load('temp_global_parallel');
FSET_END=S.FSET_END;
%FSET_END =4;
 A3=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END);
 sum3=zeros(FSET_END,FSET_END,FSET_END);
 A33=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,BSPlusJ);
 sum33=zeros(FSET_END,FSET_END,FSET_END,BSPlusJ);
FS_END=FSET_END;
for j=1:popSize
    M=MI(j);
    PT=PTi(j);
    for i=1:n(j)
        if (par4{j}(i)==0 && par3{j}(i)~=0)
            for h=1:BSPlusJ
                for k=1:FS_END
                    for u=1:FS_END
                        for v=1:FS_END
                           if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v)
                               if broth{j}(i)==0
                                  A3(h,k,u,v)=A3(h,k,u,v)+(M*PT);
                                  sum3(k,u,v)=sum3(k,u,v)+(M*PT);
                               else
                                  for b=1:BSPlusJ
                                    if broth{j}(i)==b
                                       A33(h,k,u,v,b)=A33(h,k,u,v,b)+(M*PT);
                                       sum33(k,u,v,b)=sum33(k,u,v,b)+(M*PT);
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


p3=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END);
p33=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,BSPlusJ);

for h=1:BSPlusJ
    for k=1:FS_END
        for u=1:FS_END
            for v=1:FS_END
                C=sum3(k,u,v);
              if C~=0
                p3(h,k,u,v)=A3(h,k,u,v)/C;
              else
               p3(h,k,u,v)=0;
              end
            end
        end
    end
end
%p3=(1-alpha)*p3+alpha*(1/6);

for k=1:FS_END
    for u=1:FS_END
        for v=1:FS_END
         if p3(:,k,u,v)==0
          p3(:,k,u,v)=1/BSPlusJ;  
         else
         p3(:,k,u,v)=(1-alpha)*p3(:,k,u,v)+alpha*(1/BSPlusJ);
         end
       end
    end
end


for h=1:BSPlusJ
    for k=1:FSET_END
       for u=1:FSET_END
           for v=1:FSET_END
             for b=1:BSPlusJ
                 C=sum33(k,u,v,b);
                if C~=0
                    p33(h,k,u,v,b)=A33(h,k,u,v,b)/C;
                else
                    p33(h,k,u,v,b)=0;
                end
             end
                
           end
       end
    end
end
%p33=(1-alpha)*p33+alpha*(1/6);

for k=1:FS_END
    for u=1:FS_END
        for v=1:FS_END
            for b=1:BSPlusJ
              if p33(:,k,u,v,b)==0
               p33(:,k,u,v,b)=1/BSPlusJ;  
              else
               p33(:,k,u,v,b)=(1-alpha)*p33(:,k,u,v,b)+alpha*(1/BSPlusJ);
              end
            end
        end
    end
end






