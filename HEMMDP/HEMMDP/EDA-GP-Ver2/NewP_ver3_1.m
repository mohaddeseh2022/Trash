
function [p0,p1,p11,p2,p22,p3,p33,p4,p44]=NewP_ver3_1(buffer,popSize,MI,PTr,par1,par2,par3,par4,par5,broth,n,alpha,gen,pstar0,pstar1,pstar11,pstar2,pstar22,pstar3,pstar33,pstar4,pstar44,alph,C1,C2)

S=load('temp_global_parallel');
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
V_START=Var_START;
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


Mat=(C1-C2)/C1;
Mat(Mat<0)=0;
SM1=sum(Mat);
%SM1=sum((C1-C2)/C1);
for j=1:popSize 
   
   % M1=MI(j);
     M1=(C1-C2(j))/C1;
     M1=M1/SM1;
   if M1<0
   M1=0;
   end
    PT=PTr(j);
    for i=1:n(j)
        
        for h=1:RAND_END
          if (par1{j}(i)==0)
           if (buffer{j}(1)==h && h<=FS_END)
           A0(h)=A0(h)+(M1*PT/pstar0(h));
           cou=cou+1;
               if A0(h)>1
                   savedcount=cou;
                   savedA0=A0(h);
                  savedPT=PT;
                  savedM1=(M1*PT/pstar0(h));
               end
%            elseif (buffer{j}(1)==h && h>FS_END)
%             A0(h)=0;   
          
           end
          end
           
             
               for k=1:FS_END
                  if (par2{j}(i)==0 && par1{j}(i)~=0)
                   if (buffer{j}(i)==h && par1{j}(i)==k)
                        if broth{j}(i)==0
                            A1(h,k)=A1(h,k)+(M1*PT/pstar1(h,k));
                           
                        else
                            for b=1:RAND_END     %for b=1:6
                                if broth{j}(i)==b
                                    A11(h,k,b)=A11(h,k,b)+(M1*PT/pstar11(h,k,b));
                                    
                                end
                            end
                        end
                   end
                  end
                    
                   
                    for u=1:FS_END
                       if (par3{j}(i)==0 && par2{j}(i)~=0)
                        if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u)
                           if broth{j}(i)==0
                               A2(h,k,u)=A2(h,k,u)+(M1*PT/pstar2(h,k,u));
                              
                           else
                               for b=1:RAND_END
                                  if broth{j}(i)==b
                                      A22(h,k,u,b)=A22(h,k,u,b)+(M1*PT/pstar22(h,k,u,b));
                                      
                                  end
                               end
                           end
                        end
                       end
                        
                        
                      
                        for v=1:FS_END
                           if (par4{j}(i)==0 && par3{j}(i)~=0)
                            if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v)
                               if broth{j}(i)==0
                                  A3(h,k,u,v)=A3(h,k,u,v)+(M1*PT/pstar3(h,k,u,v));
                                 
                               else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                       A33(h,k,u,v,b)=A33(h,k,u,v,b)+(M1*PT/pstar33(h,k,u,v,b));
                                      
                                    end
                                  end 
                               end
                            end
                           end
                            
                          if (par5{j}(i)==0 && par4{j}(i)~=0) %if parents exceed 4,if must go into for loop. 
                            for y=1:FS_END
                              if (buffer{j}(i)==h && par1{j}(i)==k && par2{j}(i)==u && par3{j}(i)==v && par4{j}(i)==y)
                                if broth{j}(i)==0
                                  A4(h,k,u,v,y)=A4(h,k,u,v,y)+(M1*PT/pstar4(h,k,u,v,y));
                                 
                                else
                                  for b=1:RAND_END
                                    if broth{j}(i)==b
                                    A44(h,k,u,v,y,b)=A44(h,k,u,v,y,b)+(M1*PT/pstar44(h,k,u,v,y,b));
                                   
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


%p0=pstar0;
Ex0=A0;
sigmakprime0=sum(pstar0./(1-(alph*Ex0)));
%p0(Ex0~=0)=pstar0(Ex0~=0)./(sigmakprime0*(1-alph*Ex0(Ex0~=0)));
p0=pstar0./(sigmakprime0*(1-alph*Ex0));
% if sum(p0)>1 
%   difp0=sum(p0)-1;
%   p0=p0-difp0/RAND_END;
% else
%   difp0=1-sum(p0);
%   p0=p0+difp0/RAND_END;
% end
    
%p0=p0./sum(p0);
%p0=(1-alpha)*p0+alpha*(1/RAND_END);

for k=1:FS_END
%p1=pstar1;
Ex1=A1(:,k);  
sigmakprime1(k)=sum(pstar1(:,k)./(1-(alph*Ex1)));
if sigmakprime1(k)==0
    sigmakprime1(k)=1;
end
%p1(Ex1~=0,k)=pstar1(Ex1~=0,k)./(sigmakprime1(k)*(1-alph*Ex1(Ex1~=0)));
p1(:,k)=pstar1(:,k)./(sigmakprime1(k)*(1-alph*Ex1));

% if sum(p1(:,k))>1 
%   difp1(k)=sum(p1(:,k))-1;
%   p1(:,k)=p1(:,k)-difp1(:,k)/RAND_END;
% else
%   difp1(k)=1-sum(p1(:,k));
%   p1(:,k)=p1(:,k)+difp1(k)/RAND_END;
% end
    
%p1(:,k)=p1(:,k)./sum(p1(:,k));
for b=1:RAND_END
%p11=pstar11;
Ex11=A11(:,k,b);
sigmakprime11(k,b)=sum(pstar11(:,k,b)./(1-(alph*Ex11)));
if sigmakprime11(k,b)==0
    sigmakprime11(k,b)=1;
end
%p11(Ex11~=0,k,b)=pstar11(Ex11~=0,k,b)./(sigmakprime11(k,b)*(1-alph*Ex11(Ex11~=0)));
p11(:,k,b)=pstar11(:,k,b)./(sigmakprime11(k,b)*(1-alph*Ex11));
% if sum(p11(:,k,b))>1 
%   difp11(k,b)=sum(p11(:,k,b))-1;
%   p11(:,k,b)=p11(:,k,b)-difp11(k,b)/RAND_END;
% else
%   difp11(k,b)=1-sum(p11(:,k,b));
%   p11(:,k,b)=p11(:,k,b)+difp11(k,b)/RAND_END;
% end
    
%p11(:,k,b)=p11(:,k,b)./sum(p11(:,k,b));
end
for u=1:FS_END
%p2=pstar2;
Ex2= A2(:,k,u);  
sigmakprime2(k,u)=sum(pstar2(:,k,u)./(1-(alph*Ex2)));
if sigmakprime2(k,u)==0
    sigmakprime2(k,u)=1;
end
p2(:,k,u)=pstar2(:,k,u)./(sigmakprime2(k,u)*(1-alph*Ex2));
% if sum(p2(:,k,u))>1 
%   difp2(k,u)=sum(p2(:,k,u))-1;
%   p2(:,k,u)=p2(:,k,u)-difp2(k,u)/RAND_END;
% else
%   difp2(k,u)=1-sum(p2(:,k,u));
%   p2(:,k,u)=p2(:,k,u)+difp2(k,u)/RAND_END;
% end
    
%p2(:,k,u)=p2(:,k,u)./sum(p2(:,k,u));
for b=1:RAND_END
 % p22=pstar22;
Ex22=A22(:,k,u,b);
sigmakprime22(k,u,b)=sum(pstar22(:,k,u,b)./(1-(alph*Ex22)));
if sigmakprime22(k,u,b)==0
    sigmakprime22(k,u,b)=1;
end
%p22(Ex22~=0,k,u,b)=pstar22(Ex22~=0,k,u,b)./(sigmakprime22(k,u,b)*(1-alph*Ex22(Ex22~=0))); 
p22(:,k,u,b)=pstar22(:,k,u,b)./(sigmakprime22(k,u,b)*(1-alph*Ex22)); 


% if sum(p22(:,k,u,b))>1 
%   difp22(k,u,b)=sum(p22(:,k,u,b))-1;
%   p22(:,k,u,b)=p22(:,k,u,b)-difp22(k,u,b)/RAND_END;
% else
%   difp22(k,u,b)=1-sum(p22(:,k,u,b));
%   p22(:,k,u,b)=p22(:,k,u,b)+difp22(k,u,b)/RAND_END;
% end
    
%p22(:,k,u,b)=p22(:,k,u,b)./sum(p22(:,k,u,b));
end    
for v=1:FS_END
 %p3=pstar3;
Ex3=A3(:,k,u,v);
sigmakprime3(k,u,v)=sum(pstar3(:,k,u,v)./(1-(alph*Ex3)));
if sigmakprime3(k,u,v)==0
  sigmakprime3(k,u,v)=1;
end
%p3(Ex3~=0,k,u,v)=pstar3(Ex3~=0,k,u,v)./(sigmakprime3(k,u,v)*(1-alph*Ex3(Ex3~=0))); 
p3(:,k,u,v)=pstar3(:,k,u,v)./(sigmakprime3(k,u,v)*(1-alph*Ex3)); 

% if sum(p3(:,k,u,v))>1 
%   difp3(k,u,v)=sum(p3(:,k,u,v))-1;
%   p3(:,k,u,v)=p3(:,k,u,v)-difp3(k,u,v)/RAND_END;
% else
%   difp3(k,u,v)=1-sum(p3(:,k,u,v));
%   p3(:,k,u,v)=p3(:,k,u,v)+difp3(k,u,v)/RAND_END;
% end
%     

%p3(:,k,u,v)=p3(:,k,u,v)./sum(p3(:,k,u,v)); 
for b=1:RAND_END
%p33=pstar33;
Ex33=A33(:,k,u,v,b);
sigmakprime33(k,u,v,b)=sum(pstar33(:,k,u,v,b)./(1-(alph*Ex33)));
if sigmakprime33(k,u,v,b)==0
  sigmakprime3(k,u,v,b)=1;
end
%p33(Ex33~=0,k,u,v,b)=pstar33(Ex33~=0,k,u,v,b)./(sigmakprime33(k,u,v,b)*(1-alph*Ex33(Ex33~=0)));
p33(:,k,u,v,b)=pstar33(:,k,u,v,b)./(sigmakprime33(k,u,v,b)*(1-alph*Ex33));

% if sum(p33(:,k,u,v,b))>1 
%   difp33(k,u,v,b)=sum(p33(:,k,u,v,b))-1;
%   p33(:,k,u,v,b)=p33(:,k,u,v,b)-difp33(k,u,v,b)/RAND_END;
% else
%   difp33(k,u,v,b)=1-sum(p33(:,k,u,v,b));
%   p33(:,k,u,v,b)=p33(:,k,u,v,b)+difp33(k,u,v,b)/RAND_END;
% end

%p33(:,k,u,v,b)=p33(:,k,u,v,b)./sum(p33(:,k,u,v,b));
end

for y=1:FS_END
    %p4=pstar4;
Ex4=A4(:,k,u,v,y);
sigmakprime4(k,u,v,y)=sum(pstar4(:,k,u,v,y)./(1-(alph*Ex4)));
if sigmakprime4(k,u,v,y)==0 
 sigmakprime4(k,u,v,y)=1;
end
%p4(Ex4~=0,k,u,v,y)=pstar4(Ex4~=0,k,u,v,y)./(sigmakprime4(k,u,v,y)*(1-alph*Ex4(Ex4~=0)));
p4(:,k,u,v,y)=pstar4(:,k,u,v,y)./(sigmakprime4(k,u,v,y)*(1-alph*Ex4));

% if sum(p4(:,k,u,v,y))>1 
%   difp4(k,u,v,y)=sum(p4(:,k,u,v,y))-1;
%   p4(p4(:,k,u,v,y)>0,k,u,v,y)=p4(p4(:,k,u,v,y)>0,k,u,v,y)-difp4(k,u,v,y)/(RAND_END-V_START+1);
% else
%   difp4(k,u,v,y)=1-sum(p4(:,k,u,v,y));
%   p4(p4(:,k,u,v,y)>0,k,u,v,y)=p4(p4(:,k,u,v,y)>0,k,u,v,y)+difp4(k,u,v,y)/(RAND_END-V_START+1);
% end

%p4(:,k,u,v,y)=p4(:,k,u,v,y)./sum(p4(:,k,u,v,y));
[m1,n1]=size(p4(:,k,u,v,y));
p=m1;
for i=1:m1
if isnan(p4(i,k,u,v,y))
 p4(i,k,u,v,y)=0;
 p=i;
end
end
if sum(p4(:,k,u,v,y))==0
p4(p,k,u,v,y)=1;
end


for b=FS_END+1:RAND_END
    %p44=pstar44;
Ex44=A44(:,k,u,v,y,b);
sigmakprime44(k,u,v,y,b)=sum(pstar44(:,k,u,v,y,b)./(1-(alph*Ex44)));
if sigmakprime44(k,u,v,y,b)==0
 sigmakprime44(k,u,v,y,b)=1;
end
%p44(Ex44~=0,k,u,v,y,b)=pstar44(Ex44~=0,k,u,v,y,b)./(sigmakprime44(k,u,v,y,b)*(1-alph*Ex44(Ex44~=0)));
p44(:,k,u,v,y,b)=pstar44(:,k,u,v,y,b)./(sigmakprime44(k,u,v,y,b)*(1-alph*Ex44));

% if sum(p44(:,k,u,v,y,b))>1 
%   difp44(k,u,v,y,b)=sum(p44(:,k,u,v,y,b))-1;
%   p44(p44(:,k,u,v,y,b)>0,k,u,v,y,b)=p44(p44(:,k,u,v,y,b)>0,k,u,v,y,b)-difp44(k,u,v,y,b)/(RAND_END-V_START+1);
% else
%   difp44(k,u,v,y,b)=1-sum(p44(:,k,u,v,y,b));
%   p44(p44(:,k,u,v,y,b)>0,k,u,v,y,b)=p44(p44(:,k,u,v,y,b)>0,k,u,v,y,b)+difp44(k,u,v,y,b)/(RAND_END-V_START+1);
% end
%p44(:,k,u,v,y,b)=p44(:,k,u,v,y,b)./sum(p44(:,k,u,v,y,b));
[m1,n1]=size(p44(:,k,u,v,y,b));
for i=1:m1
if isnan(p44(i,k,u,v,y,b))
 p44(i,k,u,v,y,b)=0;
 p=i;
end
end
if sum(p44(:,k,u,v,y,b))==0
p44(p,k,u,v,y,b)=1;
end

end

end
end
end
end
