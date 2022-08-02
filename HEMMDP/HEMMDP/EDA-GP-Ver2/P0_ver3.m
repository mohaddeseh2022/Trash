function p0=P0_ver3(buffer,popSize,MI,alpha)

global  RAND_END
S=load('temp_global_parallel');
RAND_END=S.RAND_END;
sum0=0;
A0=zeros(1,RAND_END);
for j=1:popSize
    for i=1:RAND_END
        if buffer{j}(1)==i 
            A0(i)=A0(i)+MI(j);
            sum0=sum0+MI(j);
        end
    end
end

p0=A0/sum0;
p0=(1-alpha)*p0+alpha*(1/RAND_END);


