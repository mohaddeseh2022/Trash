function [pos,newbuffer]=P4Samp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ)

S=load('temp_global_parallel');
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;

% FSET_END = 4;
%  RAND_START =53;
newbuffer(pos)=RAND_START; %dummy assignment,, 6 is equavalent to a real number, this assignment is for finding the parent and brother
% the real newbuffer(pos) will be assigned later
[par1  broth]=NodeParent_Final(newbuffer,pos);
if broth==0
   newbuffer(pos+1)=RAND_START; %dummy assignment
end
[par2 uncle1]=NodeParent_Final(newbuffer,par1);
if (broth~=0 && uncle1==0)
   newbuffer(pos+1)=RAND_START; %dummy assignment
elseif (broth==0 && uncle1==0)
   newbuffer(pos+2)=RAND_START; %dummy assignment
end  
[par3 uncle2]=NodeParent_Final(newbuffer,par2);
if (broth~=0 && uncle1~=0 && uncle2==0)
  newbuffer(pos+1)=RAND_START; %dummy assignment
elseif (broth==0 && uncle1~=0 && uncle2==0)
  newbuffer(pos+2)=RAND_START; %dummy assignment    
elseif (broth~=0 && uncle1==0 && uncle2==0)
  newbuffer(pos+2)=RAND_START; %dummy assignment   
elseif (broth==0 && uncle1==0 && uncle2==0)
  newbuffer(pos+3)=RAND_START; %dummy assignment
end  
[par4 uncle3]=NodeParent_Final(newbuffer,par3);


if broth==0
 for k=1:FSET_END
     for u=1:FSET_END
         for v=1:FSET_END
             for y=1:FSET_END
      if (newbuffer(par4)==y && newbuffer(par3)==v && newbuffer(par2)==u && newbuffer(par1)==k)
           p2a=p4(:,k,u,v,y);
           [p2prime,ind]=sort(p2a);
           r=rand;
           if r<=p2prime(1)
              indx=ind(1);       
           else
               p2start=p2a(ind(1));
              for j=1:size(p2a,1)-1
                 if (r>p2start && r<=p2start+p2a(ind(j+1)))
                    indx=ind(j+1);
                    break;
                 end
                 p2start=p2start+p2a(ind(j+1));
              end
           end
      end
     end
    end
     end
 end

newbuffer(pos)=indx;
pos=pos+1; 

end



if broth~=0
 for k=1:FSET_END
     for u=1:FSET_END
       for v=1:FSET_END
           for y=1:FSET_END
         for b=1:BSPlusJ
      if (newbuffer(par4)==y && newbuffer(par3)==v && newbuffer(par2)==u && newbuffer(par1)==k && newbuffer(broth)==b)
           p2b=p44(:,k,u,v,y,b);
           [p2prime,ind]=sort(p2b);
           r=rand;
           if r<=p2prime(1)
              indx=ind(1);       
           else
               p2start=p2b(ind(1));
              for j=1:size(p2b,1)-1
                 if (r>p2start && r<=p2start+p2b(ind(j+1)))
                    indx=ind(j+1);
                    break;
                 end
                 p2start=p2start+p2b(ind(j+1));
              end
           end
      end
     end
     end
       end
     end
 end
 
newbuffer(pos)=indx;
pos=pos+1; 

 end


if (0<indx && indx<FSET_END+1)
    return  %dummy instruction because we dont have operation in depth 5
else
    if broth==0
    [pos,newbuffer]=P4Samp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ); %noncomplete tree:[pos,newbuffer]=P4bSamp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ);
    elseif uncle1==0
    [pos,newbuffer]=P3Samp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ); 
    elseif (uncle1~=0 && uncle2==0 && uncle3==0) %writing uncle3==0 is arbiturary
    [pos,newbuffer]=P2Samp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ);  
    elseif (uncle1~=0 && uncle2~=0 && uncle3==0)
    [pos,newbuffer]=P1Samp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ);  
    elseif (uncle1~=0 && uncle2~=0 && uncle3~=0)
        return
    
    end
end    
 


                     
           
       