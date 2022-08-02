function pop = PopEDAGP_Final(p0,p1,p11,p2,p22,p3,p33,p4,p44,popSize,trainD,BlockValue,BSPlusJ,Coeff,k)
global  RAND_START  RAND_END

S=load('temp_global_parallel');
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;

% RAND_START=53;
% RAND_END=53;
%minRand = -10;
%maxRand = 10;
varnumber = size(trainD,2)-1;
for j=1:popSize        
    pop.indiv(j).value = [];
    %randomnumbers = minRand+(maxRand-minRand)*rand(1,100);
     for i=1:RAND_END-RAND_START+1
       randomnumbers(i)=0.5;%(sum(trainD(:,varnumber+1))/size(trainD,1));%0.5;
    end
    buffer = P0Samp_Final(p0,p1,p11,p2,p22,p3,p33,p4,p44,BSPlusJ);
    pop.indiv(j).value = buffer;
    pop.indiv(j).rand = randomnumbers;
    buffer1{k}{j}=pop.indiv(j).value;
end
%for j=1:popSize 
  %  buffer1=CalccoefficientFinal(BlockValue,k,j,buffer1);
%[a2 expr] = printIndiv_Final(buffer1{k}{j},1,varnumber,randomnumbers,BlockValue,BSPlusJ,Coeff,k-1);
  %  pop.indiv(j).expr = expr;
   % fitness = compStFit_Final(pop,j,trainD,BlockValue,BSPlusJ,Coeff,k);
   % pop.indiv(j).fit = fitness;
    
 %end