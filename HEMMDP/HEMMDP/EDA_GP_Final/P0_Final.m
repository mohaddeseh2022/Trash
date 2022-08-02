function p0=P0_Final(buffer,popSize,MI,alpha,BSPlusJ)

sum0=0;
A0=zeros(1,BSPlusJ);
for j=1:popSize
    M=MI(j);
    PT=PTi(j);
    for i=1:BSPlusJ
        if buffer{j}(1)==i 
            A0(i)=A0(i)+(M*PT);
            sum0=sum0+(M*PT);
        end
    end
end

p0=A0/sum0;
p0=(1-alpha)*p0+alpha*(1/BSPlusJ);


