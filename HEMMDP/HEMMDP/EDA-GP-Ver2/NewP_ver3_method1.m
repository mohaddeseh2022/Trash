function [p0,p1,p11,p2,p22,p3,p33,p4,p44]=NewP_ver3_method1(buffer,popSize,MI,par1,par2,par3,par4,par5,broth,n,alpha)

global  FSET_END RAND_START Var_START RAND_END
S=load('temp_global_parallel');
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
sum0=0;
A0=zeros(1,FSET_END);%zeros(1,RAND_END);
A1=zeros(RAND_END,FSET_END);
sum1=zeros(1,FSET_END);
A11=zeros(RAND_END,FSET_END,RAND_END);
sum11=zeros(FSET_END,RAND_END);
A2=zeros(RAND_END,FSET_END,FSET_END);
sum2=zeros(FSET_END,FSET_END);
A22=zeros(RAND_END,FSET_END,FSET_END,RAND_END);
sum22=zeros(FSET_END,FSET_END,RAND_END);
A3=zeros(RAND_END,FSET_END,FSET_END,FSET_END);
sum3=zeros(FSET_END,FSET_END,FSET_END);
A33=zeros(RAND_END,FSET_END,FSET_END,FSET_END,RAND_END);
sum33=zeros(FSET_END,FSET_END,FSET_END,RAND_END);
A4=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
sum4=zeros(FSET_END,FSET_END,FSET_END,FSET_END);
A44=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
sum44=zeros(FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);
FS_END=FSET_END;

p0=0;
p1=zeros(RAND_END,FSET_END);
p11=zeros(RAND_END,FSET_END,RAND_END);
p2=zeros(RAND_END,FSET_END,FSET_END);
p22=zeros(RAND_END,FSET_END,FSET_END,RAND_END);
p3=zeros(RAND_END,FSET_END,FSET_END,FSET_END);
p33=zeros(RAND_END,FSET_END,FSET_END,FSET_END,RAND_END);
p4=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END);
p44=zeros(RAND_END,FSET_END,FSET_END,FSET_END,FSET_END,RAND_END);



for j=1:popSize
    
  
    M=MI(j);
   
    
   if M<0
   M=0;
   end
    for i=1:n(j)
        
        for h=1:RAND_END
          if (par1{j}(i)==0)
           if (buffer{j}(1)==h && h<=FS_END)
           A0(h)=A0(h)+M;
           sum0=sum0+M;
           end
          end
           
             
               for k=1:FS_END
                  if (par2{j}(i)==0 && par1{j}(i)~=0)
                   if (buffer{j}(i)==h && par1{j}(i)==k)
                        if broth{j}(i)==0
                            A1(h,k)=A1(h,k)+M;
                            sum1(k)=sum1(k)+M;
                        else
                            for b=1:RAND_END     
                                if broth{j}(i)==b
                                    A11(h,k,b)=A11(h,k,b)+M;
                                    sum11(k,b)=sum11(k,b)+M;
                                end
                            end
                        end
                   end
                  end
                    
                   
                    for u=1:FS_END
                       if (par3{j}(i)==0 && par2{j}(i)~=0)
                        if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u)
                           if broth{j}(i)==0
                               A2(h,k,u)=A2(h,k,u)+M;
                               sum2(k,u)=sum2(k,u)+M;
                           else
                               for b=1:RAND_END
                                  if broth{j}(i)==b
                                      A22(h,k,u,b)=A22(h,k,u,b)+M;
                                      sum22(k,u,b)=sum22(k,u,b)+M;
                                  end
                               end
                           end
                        end
                       end
                        
                        
                      
                        for v=1:FS_END
                           if (par4{j}(i)==0 && par3{j}(i)~=0)
                            if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v)
                               if broth{j}(i)==0
                                  A3(h,k,u,v)=A3(h,k,u,v)+M;
                                  sum3(k,u,v)=sum3(k,u,v)+M;
                               else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                       A33(h,k,u,v,b)=A33(h,k,u,v,b)+M;
                                       sum33(k,u,v,b)=sum33(k,u,v,b)+M;
                                    end
                                  end 
                               end
                            end
                           end
                            
                          if (par5{j}(i)==0 && par4{j}(i)~=0) %if parents exceed 4,if must go into for loop. 
                            for y=1:FS_END
                              if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v && par4{j}(i)==y)
                                if broth{j}(i)==0
                                  A4(h,k,u,v,y)=A4(h,k,u,v,y)+M;
                                  sum4(k,u,v,y)=sum4(k,u,v,y)+M;
                                else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                    A44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)+M;
                                    sum44(k,u,v,y,b)=sum44(k,u,v,y,b)+M;
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

p0=A0/sum0;
p0=(1-alpha)*p0+alpha*(1/FS_END);

for h=1:RAND_END
    for k=1:FS_END
        C=sum1(k);
         if C~=0
          p1(h,k)=A1(h,k)/C;
        %else
          %p1(h,k)=0;
         end
        for u=1:FS_END
          C=sum2(k,u);
          if C~=0
           p2(h,k,u)=A2(h,k,u)/C;
          %else
           %p2(h,k,u)=0;
          end
            for v=1:FS_END
                 C=sum3(k,u,v);
                  if C~=0
                   p3(h,k,u,v)=A3(h,k,u,v)/C;
                  %else
                   %p3(h,k,u,v)=0;
                  end
                for y=1:FS_END
                    C=sum4(k,u,v,y);
                    if C~=0
                    p4(h,k,u,v,y)=A4(h,k,u,v,y)/C;
                    %else
                    %p4(h,k,u,v,y)=0;
                    end
                 end
             end
        end
    end
end

V_START=Var_START;
for k=1:FS_END
    if p1(:,k)==0
      p1(:,k)=1/RAND_END;  
    else
    p1(:,k)=(1-alpha)*p1(:,k)+alpha*(1/RAND_END);
    end
    for u=1:FS_END
        if p2(:,k,u)==0
         p2(:,k,u)=1/RAND_END;  
        else
         p2(:,k,u)=(1-alpha)*p2(:,k,u)+alpha*(1/RAND_END);
        end
        for v=1:FS_END
           if p3(:,k,u,v)==0
            p3(:,k,u,v)=1/RAND_END;  
           else
            p3(:,k,u,v)=(1-alpha)*p3(:,k,u,v)+alpha*(1/RAND_END);
           end
           for y=1:FS_END
             if p4(:,k,u,v,y)==0
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


for h=1:RAND_END
    for k=1:FSET_END
        for b=1:RAND_END
          C=sum11(k,b);
          if C~=0
            p11(h,k,b)=A11(h,k,b)/C;
          else
            p11(h,k,b)=0;
          end
                
        end
       for u=1:FSET_END
           for b=1:RAND_END
            C=sum22(k,u,b);
            if C~=0
              p22(h,k,u,b)=A22(h,k,u,b)/C;
            else
              p22(h,k,u,b)=0;
            end
           end
           for v=1:FSET_END
              for b=1:RAND_END
               C=sum33(k,u,v,b);
               if C~=0
                 p33(h,k,u,v,b)=A33(h,k,u,v,b)/C;
               else
                 p33(h,k,u,v,b)=0;
               end
             end
               for y=1:FSET_END
                  for b=1:RAND_END
                      C=sum44(k,u,v,y,b);
                    if C~=0
                      p44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)/C;
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
    for b=1:RAND_END
     if p11(:,k,b)==0
      p11(:,k,b)=1/RAND_END;  
     else
      p11(:,k,b)=(1-alpha)*p11(:,k,b)+alpha*(1/RAND_END);
     end
    end
    for u=1:FSET_END
        for b=1:RAND_END
         if p22(:,k,u,b)==0
          p22(:,k,u,b)=1/RAND_END;  
         else
          p22(:,k,u,b)=(1-alpha)*p22(:,k,u,b)+alpha*(1/RAND_END);
         end
        end
        for v=1:FSET_END
            for b=1:RAND_END
              if p33(:,k,u,v,b)==0
               p33(:,k,u,v,b)=1/RAND_END;  
              else
               p33(:,k,u,v,b)=(1-alpha)*p33(:,k,u,v,b)+alpha*(1/RAND_END);
              end
            end
            for y=1:FSET_END
                for b=1:RAND_END
                 if p44(:,k,u,v,y,b)==0
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






