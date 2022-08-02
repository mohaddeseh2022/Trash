function pop = initialPopStGP_Final(popSize,trainD,BlockValue,J,BSPlusJ,Coeff,k,paramet)
% global  RAND_START  RAND_END 
S=load('temp_global_parallel');
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;

minRand = -10;
maxRand = 10;
varnumber = size(trainD,2)-1;
randomnumbers=zeros(1,RAND_END-RAND_START+1);
for j=1:popSize        
    pop.indiv(j).value = [];
    %randomnumbers = minRand+(maxRand-minRand)*rand(1,(RAND_END-RAND_START+1));
    for i=1:RAND_END-RAND_START+1
        randomnumbers(i)=0.5;
    end
    buffer = randomIndiv_Final(varnumber,J,paramet);
    pop.indiv(j).value = buffer;
    pop.indiv(j).rand = randomnumbers;
    %buffer1{k}{j}=pop.indiv(j).value;
end




