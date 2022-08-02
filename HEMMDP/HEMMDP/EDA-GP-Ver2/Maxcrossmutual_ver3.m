function [maxcrossMI]=Maxcrossmutual_ver3(buffer,rnd,popSize,trainD)

crossMI=zeros(popSize,popSize);
maxcrossMI=zeros(1,popSize);
for j=1:popSize   
       [result1, pos] = run_ver3(buffer{j},1,trainD,rnd{j});
       crossMI(j,1:j)=crossMI(1:j,j)';
     for  t=j+1:popSize 
        % if t~=j
      [result2, pos] = run_ver3(buffer{t},1,trainD,rnd{t});
    % [MII,lambda]=MutualInfo(result1,result2);
     lambda=abs(corr(result1,result2));
     crossMI(j,t)=lambda;
         %end
         if isnan (crossMI(j,t))
         crossMI(j,t)=0;
        end
         
     end
    
     if (j>1 && j<popSize)
  maxcrossMI(j)=sum(crossMI(j,1:j-1))+sum(crossMI(j,j+1:popSize));%max(max(crossMI(j,1:j-1)),max(crossMI(j,j+1:popSize)));%%sum(crossMI(j,1:j-1))+sum(crossMI(j,j+1:popSize));
     elseif j==1
      maxcrossMI(j)=sum(crossMI(j,j+1:popSize));   
     elseif j==popSize
      maxcrossMI(j)=sum(crossMI(j,1:j-1));   
     end
%  if (j>1 && j<popSize)
%   maxcrossMI(j)=max(max(crossMI(j,1:j-1)),max(crossMI(j,j+1:popSize)));%%sum(crossMI(j,1:j-1))+sum(crossMI(j,j+1:popSize));
%      elseif j==1
%       maxcrossMI(j)=max(crossMI(j,j+1:popSize));   
%      elseif j==popSize
%       maxcrossMI(j)=max(crossMI(j,1:j-1));   
%  end
% % maxcrossMI(j)= maxcrossMI(j)-sum(crossMI(j,:)==1)+1;

 if maxcrossMI(j)==0 
     maxcrossMI(j)=0.001;
 end
 
end
maxcrossMI=maxcrossMI/(popSize-1);