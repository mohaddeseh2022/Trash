function  [newbuffer] = P0Samp_Final(p0,p1,p11,p2,p22,p3,p33,p4,p44,BSPlusJ)

global  FSET_END
S=load('temp_global_parallel');
FSET_END=S.FSET_END;
%FSET_END = 4;
[p0prime,ind]=sort(p0);

r=rand;
if r<=p0prime(1)
    indx=ind(1);       
else
    p0start=p0(ind(1));
    for j=1:size(p0,2)-1
         if (r>p0start && r<=p0start+p0(ind(j+1)))
             indx=ind(j+1);
             break;
         end
         p0start=p0start+p0(ind(j+1));
         
    end
end

% sum(p0)
% sum(p1)
% sum(p11)
% sum(p2)
% sum(p22)
% sum(p3)
  newbuffer(1)=indx;
  pos=2;
     
  if (0<indx && indx<FSET_END+1)
  [pos,newbuffer]=P1Samp_Final(p1,p11,p2,p22,p3,p33,p4,p44,newbuffer,pos,BSPlusJ);   
  end


    