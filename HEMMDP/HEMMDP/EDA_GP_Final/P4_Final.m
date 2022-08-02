function [p4,p44]=P4_Final(buffer,popSize,MI,par1,par2,par3,par4,par5,broth,n,BSPlusJ)

global FSET_END RAND_START Var_START 

S=load('temp_global_parallel');

FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
Var_START=S.Var_START;

% FSET_END=4;
% RAND_START=53;
% Var_START=5; 

 A4=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END);
 sum4=zeros(FSET_END,FSET_END,FSET_END,FSET_END);
 A44=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);
 sum44=zeros(FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);
FS_END=FSET_END;
for j=1:popSize
    M=MI(j);
    PT=PTi(j);
    for i=1:n(j)
        if (par5{j}(i)==0 && par4{j}(i)~=0)
            for h=1:BSPlusJ
               for k=1:FS_END
                    for u=1:FS_END
                        for v=1:FS_END
                            for y=1:FS_END
                              if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v && par4{j}(i)==y)
                                if broth{j}(i)==0
                                  A4(h,k,u,v,y)=A4(h,k,u,v,y)+(M*PT);
                                  sum4(k,u,v,y)=sum4(k,u,v,y)+(M*PT);
                                else
                                  for b=1:BSPlusJ
                                    if broth{j}(i)==b
                                    A44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)+(M*PT);
                                    sum44(k,u,v,y,b)=sum44(k,u,v,y,b)+(M*PT);
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
end


p4=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END);
p44=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);

for h=1:BSPlusJ
    for k=1:FS_END
        for u=1:FS_END
            for v=1:FS_END
                for y=1:FS_END
                    C=sum4(k,u,v,y);
                  if C~=0
                    p4(h,k,u,v,y)=A4(h,k,u,v,y)/C;
                  else
                   p4(h,k,u,v,y)=0;
                  end
                end
            end
        end
    end
end

V_START=Var_START;
for k=1:FS_END
    for u=1:FS_END
        for v=1:FS_END
            for y=1:FS_END
    if p4(:,k,u,v,y)==0
        for i=Var_START:RAND_START-1
      p4(i,k,u,v,y)=1/(BSPlusJ-V_START+1);  
        end
        for i=RAND_START:BSPlusJ
      p4(i,k,u,v,y)=1/(BSPlusJ-V_START+1); 
        end
    end
    end
    end
    end
end


for h=1:BSPlusJ
    for k=1:FSET_END
       for u=1:FSET_END
           for v=1:FSET_END
               for y=1:FSET_END
                  for b=1:BSPlusJ
                    if sum44(k,u,v,y,b)~=0
                      p44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)/sum44(k,u,v,y,b);
                    else
                      p44(h,k,u,v,y,b)=0;
                    end
                  end
                
               end
           end
       end
    end
end

V_START=Var_START;
for k=1:FSET_END
    for u=1:FSET_END
        for v=1:FSET_END
            for y=1:FSET_END
                for b=1:BSPlusJ
    if p44(:,k,u,v,y,b)==0
        for i=Var_START:RAND_START-1
      p44(i,k,u,v,y,b)=1/(BSPlusJ-V_START+1);  
        end
       for i=RAND_START:BSPlusJ
      p44(i,k,u,v,y,b)=1/(BSPlusJ-V_START+1); 
       end
    end
end
    end
    end
    end
end






