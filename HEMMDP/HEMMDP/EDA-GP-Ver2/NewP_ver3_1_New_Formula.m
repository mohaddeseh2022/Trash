function [p0,p1,p11,p2,p22,p3,p33,p4,p44]=NewP_ver3_1_New_Formula(buffer,popSize,MI,PTr,par1,par2,par3,par4,par5,broth,n,alpha,gen,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44,alph)

S=load('temp_global_parallel');
FSET_END=S.FSET_END;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
RAND_START=S.RAND_START;
cou=0;
A0=zeros(1,FSET_END);%(1,RAND_END);
A1=zeros(RAND_END,FSET_END);
sigmakprime1=zeros(1,FSET_END);
A11=zeros(RAND_END,FSET_END,RAND_END);
sigmakprime11=zeros(FSET_END,RAND_END);
A2=zeros(RAND_END,FSET_END,FSET_END);
sigmakprime2=zeros(FSET_END,FSET_END);
A22=zeros(RAND_END,FSET_END,FSET_END,RAND_END);
sigmakprime22=zeros(FSET_END,FSET_END,RAND_END);
A3=zeros(RAND_END,FSET_END,FSET_END,FSET_END);
sigmakprime3=zeros(FSET_END,FSET_END,FSET_END);
A33=zeros(RAND_END,FSET_END,FSET_END,FSET_END,RAND_END);
sigmakprime33=zeros(FSET_END,FSET_END,FSET_END,RAND_END);
A4=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
sigmakprime4=zeros(FSET_END,FSET_END,FSET_END,FSET_END);
A44=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
sigmakprime44=zeros(FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
FS_END=FSET_END;



p1=zeros(RAND_END,FSET_END);
p11=zeros(RAND_END,FSET_END,RAND_END);
p2=zeros(RAND_END,FSET_END,FSET_END);
p22=zeros(RAND_END,FSET_END,FSET_END,RAND_END);
p3=zeros(RAND_END,FSET_END,FSET_END,FSET_END);
p33=zeros(RAND_END,FSET_END,FSET_END,FSET_END,RAND_END);
p4=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
p44=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);


Sum_PT=0;
for j=1:popSize 
   
    M1=MI(j);
    
   if M1<0
   M1=0;
   end
    PT=PTr(j);
    Sum_PT=PT+Sum_PT;
    
    for i=1:n(j)      
        for h=1:RAND_END
          if (par1{j}(i)==0)
           if (buffer{j}(1)==h && h<=FS_END)
           A0(h)=A0(h)+(M1*PT);
           cou=cou+1;
               if A0(h)>1
                   savedcount=cou;
                   savedA0=A0(h);
                  savedPT=PT;
                  savedM1=(M1*PT);
               end
%            elseif (buffer{j}(1)==h && h>FS_END)
%             A0(h)=0;   
          
           end
          end
           
             
               for k=1:FS_END
                  if (par2{j}(i)==0 && par1{j}(i)~=0)
                   if (buffer{j}(i)==h && par1{j}(i)==k)
                        if broth{j}(i)==0
                            A1(h,k)=A1(h,k)+(M1*PT);
                           
                        else
                            for b=1:RAND_END     %for b=1:6
                                if broth{j}(i)==b
                                    A11(h,k,b)=A11(h,k,b)+(M1*PT);
                                    
                                end
                            end
                        end
                   end
                  end
                    
                   
                    for u=1:FS_END
                       if (par3{j}(i)==0 && par2{j}(i)~=0)
                        if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u)
                           if broth{j}(i)==0
                               A2(h,k,u)=A2(h,k,u)+(M1*PT);
                              
                           else
                               for b=1:RAND_END
                                  if broth{j}(i)==b
                                      A22(h,k,u,b)=A22(h,k,u,b)+(M1*PT);
                                      
                                  end
                               end
                           end
                        end
                       end
                        
                        
                      
                        for v=1:FS_END
                           if (par4{j}(i)==0 && par3{j}(i)~=0)
                            if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v)
                               if broth{j}(i)==0
                                  A3(h,k,u,v)=A3(h,k,u,v)+(M1*PT);
                                 
                               else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                       A33(h,k,u,v,b)=A33(h,k,u,v,b)+(M1*PT);
                                      
                                    end
                                  end 
                               end
                            end
                           end
                            
                          if (par5{j}(i)==0 && par4{j}(i)~=0) %if parents exceed 4,if must go into for loop. 
                            for y=1:FS_END
                              if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v && par4{j}(i)==y)
                                if broth{j}(i)==0
                                  A4(h,k,u,v,y)=A4(h,k,u,v,y)+(M1*PT);
                                 
                                else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                    A44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)+(M1*PT);
                                   
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


Ex0=A0/Sum_PT;
sigmakprime0=sum(Ex0);
p0=(pstar0+alph*Ex0)./(alph*sigmakprime0+1);
p0(isnan(p0))=0;
for k=1:FS_END
Ex1=A1(:,k)/Sum_PT;  
sigmakprime1(k)=sum(Ex1);
p1(:,k)=(pstar1(:,k)+alph*Ex1)./(alph*sigmakprime1(k)+1);
p1(isnan(p1))=0;
for b=1:RAND_END
Ex11=A11(:,k,b)/Sum_PT;
sigmakprime11(k,b)=sum(Ex11);
p11(:,k,b)=(pstar11(:,k,b)+alph*Ex11)./(alph*sigmakprime11(k,b)+1);
p11(isnan(p11))=0;
end
for u=1:FS_END
Ex2= A2(:,k,u)/Sum_PT;  
sigmakprime2(k,u)=sum(Ex2);
p2(:,k,u)=(pstar2(:,k,u)+alph*Ex2)./(alph*sigmakprime2(k,u)+1);
p2(isnan(p2))=0;
for b=1:RAND_END
Ex22=A22(:,k,u,b)/Sum_PT;
sigmakprime22(k,u,b)=sum(Ex22);
p22(:,k,u,b)=(pstar22(:,k,u,b)+alph*Ex22)./(alph*sigmakprime22(k,u,b)+1); 
p22(isnan(p22))=0;
end    
for v=1:FS_END
Ex3=A3(:,k,u,v)/Sum_PT;
sigmakprime3(k,u,v)=sum(Ex3);
p3(:,k,u,v)=(pstar3(:,k,u,v)+alph*Ex3)./(alph*sigmakprime3(k,u,v)+1); 
p3(isnan(p3))=0;

for b=1:RAND_END
Ex33=A33(:,k,u,v,b)/Sum_PT;
sigmakprime33(k,u,v,b)=sum(Ex33);
p33(:,k,u,v,b)=(pstar33(:,k,u,v,b)+alph*Ex33)./(alph*sigmakprime33(k,u,v,b)+1);
p33(isnan(p33))=0;
end

for y=1:FS_END
Ex4=A4(:,k,u,v,y)/Sum_PT;
sigmakprime4(k,u,v,y)=sum(Ex4);
p4(:,k,u,v,y)=(pstar4(:,k,u,v,y)+alph*Ex4)./(alph*sigmakprime4(k,u,v,y)+1);
p4(isnan(p4))=0;
% [m1,n1]=size(p4(:,k,u,v,y));
% p=m1;
% for i=1:m1
% if isnan(p4(i,k,u,v,y))
%  p4(i,k,u,v,y)=0;
%  p=i;
% end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% p=RAND_START;
% if sum(p4(:,k,u,v,y))==0
% p4(p,k,u,v,y)=1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for b=FS_END+1:RAND_END
Ex44=A44(:,k,u,v,y,b)/Sum_PT;
sigmakprime44(k,u,v,y,b)=sum(Ex44);
p44(:,k,u,v,y,b)=(pstar44(:,k,u,v,y,b)+alph*Ex44)./(alph*sigmakprime44(k,u,v,y,b)+1);
p44(isnan(p44))=0;
% [m1,n1]=size(p44(:,k,u,v,y,b));
% for i=1:m1
% if isnan(p44(i,k,u,v,y,b))
%  p44(i,k,u,v,y,b)=0;
%  p=i;
% end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% p=RAND_START;
% if sum(p44(:,k,u,v,y,b))==0
% p44(p,k,u,v,y,b)=1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

end
end
end
end


p0=(1-alpha)*p0+alpha*(1/FSET_END);
V_START=Var_START;
for k=1:FS_END
    if (all(p1(:,k)<=0) || any(p1(:,k)<0))
      p1(:,k)=1/RAND_END;  
    else
    p1(:,k)=(1-alpha)*p1(:,k)+alpha*(1/RAND_END);
    end
    
    for u=1:FS_END
        if (all(p2(:,k,u)<=0) || any(p2(:,k,u)<0))
         p2(:,k,u)=1/RAND_END;  
        else
         p2(:,k,u)=(1-alpha)*p2(:,k,u)+alpha*(1/RAND_END);
        end
        
        for v=1:FS_END
           if (all(p3(:,k,u,v)<=0) || any(p3(:,k,u,v)<0))
            p3(:,k,u,v)=1/RAND_END;  
           else
            p3(:,k,u,v)=(1-alpha)*p3(:,k,u,v)+alpha*(1/RAND_END);
           end
          
           for y=1:FS_END
             if (all(p4(:,k,u,v,y)<=0) || any(p4(:,k,u,v,y)<0))
              for i=Var_START:RAND_START-1
               p4(i,k,u,v,y)=1/(RAND_END-V_START+1);  
              end
              for i=RAND_START:RAND_END
              p4(i,k,u,v,y)=1/(RAND_END-V_START+1); 
              end
              
             else
                for i=Var_START:RAND_END
                 p4(i,k,u,v,y)= (1-alpha)*p4(i,k,u,v,y)+alpha*(1/(RAND_END-V_START+1)); 
                end
                 
             end
             
           end
    end
    end
end



V_START=Var_START;

for k=1:FSET_END
    for b=1:RAND_END
     if (all(p11(:,k,b)<=0) || any(p11(:,k,b)<0))
      p11(:,k,b)=1/RAND_END;  
     else
      p11(:,k,b)=(1-alpha)*p11(:,k,b)+alpha*(1/RAND_END);
     end
    end
    
    for u=1:FSET_END
        for b=1:RAND_END
         if (all(p22(:,k,u,b)<=0) || any(p22(:,k,u,b)<0))
          p22(:,k,u,b)=1/RAND_END;  
         else
          p22(:,k,u,b)=(1-alpha)*p22(:,k,u,b)+alpha*(1/RAND_END);
         end
        end
        
        for v=1:FSET_END
            for b=1:RAND_END
              if (all(p33(:,k,u,v,b)<=0) || any(p33(:,k,u,v,b)<0))
               p33(:,k,u,v,b)=1/RAND_END;  
              else
               p33(:,k,u,v,b)=(1-alpha)*p33(:,k,u,v,b)+alpha*(1/RAND_END);
              end
               
            end
            for y=1:FSET_END
                for b=1:RAND_END
                 if (all(p44(:,k,u,v,y,b)<=0) || any(p44(:,k,u,v,y,b)<0))
                  for i=Var_START:RAND_START-1
                   p44(i,k,u,v,y,b)=1/(RAND_END-V_START+1);  
                  end
                  for i=RAND_START:RAND_END
                   p44(i,k,u,v,y,b)=1/(RAND_END-V_START+1); 
                  end   
                 else
                     for i=Var_START:RAND_END
                      p44(i,k,u,v,y,b)= (1-alpha)* p44(i,k,u,v,y,b)+alpha*(1/(RAND_END-V_START+1)); 
                     end
                 end
                
                end
            end
       end
    end
end


