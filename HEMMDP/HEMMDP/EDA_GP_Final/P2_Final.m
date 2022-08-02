function [p2,p22]=P2_Final(buffer,popSize,MI,par1,par2,par3,broth,n,alpha,BSPlusJ)

global  FSET_END 
S=load('temp_global_parallel');
FSET_END=S.FSET_END;

%FSET_END =4;

 A2=zeros(BSPlusJ,FSET_END,FSET_END);
 sum2=zeros(FSET_END,FSET_END);
 A22=zeros(BSPlusJ,FSET_END,FSET_END,BSPlusJ);
 sum22=zeros(FSET_END,FSET_END,BSPlusJ);
FS_END=FSET_END;
for j=1:popSize
    M=MI(j);
    PT=PTi(j);
    for i=1:n(j)
        if (par3{j}(i)==0 && par2{j}(i)~=0)
            for h=1:BSPlusJ
                for k=1:FS_END
                    for u=1:FS_END
                       if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u)
                           if broth{j}(i)==0
                               A2(h,k,u)=A2(h,k,u)+(M*PT);
                               sum2(k,u)=sum2(k,u)+(M*PT);
                           else
                               for b=1:BSPlusJ
                                  if broth{j}(i)==b
                                      A22(h,k,u,b)=A22(h,k,u,b)+(M*PT);
                                      sum22(k,u,b)=sum22(k,u,b)+(M*PT);
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


p2=zeros(BSPlusJ,FSET_END,FSET_END);
p22=zeros(BSPlusJ,FSET_END,FSET_END,BSPlusJ);

for h=1:BSPlusJ
    for k=1:FS_END
        for u=1:FS_END
            C=sum2(k,u);
           if C~=0
             p2(h,k,u)=A2(h,k,u)/C;
           else
             p2(h,k,u)=0;
           end
        end
    end
end

% p2=(1-alpha)*p2+alpha*(1/6);

for k=1:FS_END
    for u=1:FS_END
    if p2(:,k,u)==0
      p2(:,k,u)=1/BSPlusJ;  
    else
    p2(:,k,u)=(1-alpha)*p2(:,k,u)+alpha*(1/BSPlusJ);
    end
    end
end


for h=1:BSPlusJ
    for k=1:FS_END
       for u=1:FS_END
        for b=1:BSPlusJ
            C=sum22(k,u,b);
            if C~=0
                 p22(h,k,u,b)=A22(h,k,u,b)/C;
            else
                 p22(h,k,u,b)=0;
            end
        end
                
      end
    end
end



for k=1:FS_END
  for u=1:FS_END
    for b=1:BSPlusJ
    if p22(:,k,u,b)==0
      p22(:,k,u,b)=1/BSPlusJ;  
    else
    p22(:,k,u,b)=(1-alpha)*p22(:,k,u,b)+alpha*(1/BSPlusJ);
    end
    end
  end
end




%p22=(1-alpha)*p22+alpha*(1/6);




