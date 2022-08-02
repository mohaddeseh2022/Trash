function [pos,newbuffer]=P1Samp_ver3(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos)

global FSET_END RAND_START RAND_END

S=load('temp_global_parallel');

FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;

newbuffer(pos)=RAND_START; %dummy assignment,, 6 is equavalent to a real number, this assignment is for finding the parent and brother
% the real newbuffer(pos) will be assigned later
[par1  broth]=NodeParent_ver3(newbuffer,pos);

if broth==0
for k=1:FSET_END
if newbuffer(1)==k   
           p1a=p1(:,k);
           [p1prime,ind]=sort(p1a);
           r=rand;
           if r<=p1prime(1)
              indx=ind(1);       
           else
               p1start=p1a(ind(1));
              for j=1:size(p1a,1)-1
                 if (r>p1start && r<=p1start+p1a(ind(j+1)))
                    indx=ind(j+1);
                    break;
                 end
                  p1start=p1start+p1a(ind(j+1));
              end
           end
end
end
       

newbuffer(pos)=indx;
pos=pos+1; 

end


if broth~=0
for k=1:FSET_END
    for b=1:RAND_END
if (newbuffer(1)==k && newbuffer(2)==b)   
           p1b=p11(:,k,b);
           [p1prime,ind]=sort(p1b);
           r=rand;
           if r<=p1prime(1)
              indx=ind(1);       
           else
               p1start=p1b(ind(1));
              for j=1:size(p1b,1)-1
                 if (r>p1start && r<=p1start+p1b(ind(j+1)))
                    indx=ind(j+1);
                    break;
                 end
                  p1start=p1start+p1b(ind(j+1));
              end
           end
end
end
end
       
newbuffer(pos)=indx;
pos=pos+1; 

end

 
 if (0<indx && indx<FSET_END+1)
    [pos,newbuffer]=P2Samp_ver3(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos); 
 else
    if broth==0
    [pos,newbuffer]=P1Samp_ver3(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos);%non complete tree:[pos,newbuffer]=P1bSamp_ver3(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos);
    else
       return    
    end    
 end    
 





      