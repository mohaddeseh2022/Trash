function [p4,p44]=P4_ver3(buffer,popSize,MI,par1,par2,par3,par4,par5,broth,n)

global FSET_END RAND_START Var_START RAND_END

S=load('temp_global_parallel');

FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;

 A4=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
 sum4=zeros(FSET_END,FSET_END,FSET_END,FSET_END);
 A44=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
 sum44=zeros(FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);

for j=1:popSize
    for i=1:n(j)
        if (par5{j}(i)==0 && par4{j}(i)~=0)
            for h=1:RAND_END
                for k=1:FSET_END
                    for u=1:FSET_END
                        for v=1:FSET_END
                            for y=1:FSET_END
                              if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v && par4{j}(i)==y)
                                if broth{j}(i)==0
                                  A4(h,k,u,v,y)=A4(h,k,u,v,y)+MI(j);
                                  sum4(k,u,v,y)=sum4(k,u,v,y)+MI(j);
                                else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                    A44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)+MI(j);
                                    sum44(k,u,v,y,b)=sum44(k,u,v,y,b)+MI(j);
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


p4=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
p44=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);

for h=1:RAND_END
    for k=1:FSET_END
        for u=1:FSET_END
            for v=1:FSET_END
                for y=1:FSET_END
                  if sum4(k,u,v,y)~=0
                    p4(h,k,u,v,y)=A4(h,k,u,v,y)/sum4(k,u,v,y);
                  else
                   p4(h,k,u,v,y)=0;
                  end
                end
            end
        end
    end
end

for k=1:FSET_END
    for u=1:FSET_END
        for v=1:FSET_END
            for y=1:FSET_END
    if p4(:,k,u,v,y)==0
        for i=Var_START:RAND_START-1
      p4(i,k,u,v,y)=1/(RAND_END-Var_START+1);  
        end
        for i=RAND_START:RAND_END
      p4(i,k,u,v,y)=1/(RAND_END-Var_START+1); 
        end
    end
    end
    end
    end
end


for h=1:RAND_END
    for k=1:FSET_END
       for u=1:FSET_END
           for v=1:FSET_END
               for y=1:FSET_END
                  for b=1:RAND_END
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

for k=1:FSET_END
    for u=1:FSET_END
        for v=1:FSET_END
            for y=1:FSET_END
                for b=1:RAND_END
    if p44(:,k,u,v,y,b)==0
        for i=Var_START:RAND_START-1
      p44(i,k,u,v,y,b)=1/(RAND_END-Var_START+1);  
        end
       for i=RAND_START:RAND_END
      p44(i,k,u,v,y,b)=1/(RAND_END-Var_START+1); 
       end
    end
end
    end
    end
    end
end






