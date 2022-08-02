function pop = PopEDAGP_ver3(p0,p1,p11,p2,p22,p3,p33,p4,p44,popSize,trainD)


S=load('temp_global_parallel');

RAND_START=S.RAND_START;
RAND_END=S.RAND_END;

%minRand = -10;
%maxRand = 10;
varnumber = size(trainD,2)-1;
for j=1:popSize        
    pop.indiv(j).value = [];
    %randomnumbers = minRand+(maxRand-minRand)*rand(1,100);
     for i=1:RAND_END-RAND_START+1
       randomnumbers(i)=0.5;%(sum(trainD(:,varnumber+1))/size(trainD,1));%0.5;
    end
    buffer = P0Samp_ver3(p0,p1,p11,p2,p22,p3,p33,p4,p44);
    pop.indiv(j).value = buffer;
    buffer
    pop.indiv(j).rand = randomnumbers;
    %[a2 expr] = printIndiv_ver3(buffer,1,varnumber,randomnumbers);
   % expr="5";
   % disp(expr);
    %pop.indiv(j).expr = expr;
    %fitness = compStFit_ver3(pop,j,trainD);
    pop.indiv(j).fit = 2;
end

