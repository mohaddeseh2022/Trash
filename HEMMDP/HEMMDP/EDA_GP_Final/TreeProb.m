function [PTr]=TreeProb(buffer,popSize,par1,par2,par3,par4,par5,broth,n,BSPlusJ,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44)

global FSET_END 
S=load('temp_global_parallel');
FSET_END=S.FSET_END;
%  FSET_END=4;
%  RAND_START=53; 
%  Var_START=5; 


FS_END=FSET_END;
PTr=zeros(1,popSize);

for j=1:popSize
   A=1;
    for i=1:n(j)
        
        for h=1:FSET_END %BSPlusJ
          if (par1{j}(i)==0)
           if buffer{j}(1)==h 
           A=A*(pstar0(h));
           end
          end
           
             
               for k=1:FS_END
                  if (par2{j}(i)==0 && par1{j}(i)~=0)
                   if (buffer{j}(i)==h && par1{j}(i)==k)
                        if broth{j}(i)==0
                            A=A*(pstar1(h,k));
                        else
                            for b=1:BSPlusJ     %for b=1:6
                                if broth{j}(i)==b
                                    A=A*pstar11(h,k,b);
                                end
                            end
                        end
                   end
                  end
                    
                   
                    for u=1:FS_END
                       if (par3{j}(i)==0 && par2{j}(i)~=0)
                        if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u)
                           if broth{j}(i)==0
                               A=A*pstar2(h,k,u);
                           else
                               for b=1:BSPlusJ
                                  if broth{j}(i)==b
                                      A=A*pstar22(h,k,u,b);
                                  end
                               end
                           end
                        end
                       end
                        
                        
                      
                        for v=1:FS_END
                           if (par4{j}(i)==0 && par3{j}(i)~=0)
                            if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v)
                               if broth{j}(i)==0
                                  A=A*pstar3(h,k,u,v);
                               else
                                  for b=1:BSPlusJ
                                    if broth{j}(i)==b
                                       A=A*pstar33(h,k,u,v,b);
                                    end
                                  end 
                               end
                            end
                           end
                            
                          if (par5{j}(i)==0 && par4{j}(i)~=0) %if parents exceed 4,if must go into for loop. 
                            for y=1:FS_END
                              if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v && par4{j}(i)==y)
                                if broth{j}(i)==0
                                  A=A*pstar4(h,k,u,v,y);
                                else
                                  for b=1:BSPlusJ
                                    if broth{j}(i)==b
                                    A=A*pstar44(h,k,u,v,y,b);
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
        PTr(j)=A;
    end




