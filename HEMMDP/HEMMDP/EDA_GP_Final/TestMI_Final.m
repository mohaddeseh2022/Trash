function [ testdataMI ] = TestMI_Final( buffer,rnd,varnumber,testD,BlockValue,BSPlusJ,Coeff,k)
%RAND_END=2000;
global RAND_END
S=load('temp_global_parallel');
RAND_END=S.RAND_END;
 %RAND_END=53;
 Y = testD(:,varnumber+1);
 %buffer1=BlockValue; checl if necessary??
    buffer1{k}{1}=buffer;
  [buffer1,dummyn]=CalccoefficientFinal(BlockValue,k,1,buffer1);
  %[result, pos] = run_Final(buffer1{k}{1},1,testD,rnd,BlockValue,BSPlusJ,Coeff,k,RAND_END,Block_result);
   [result,pos]=run_verComb(buffer1{k}{1},1,testD,rnd,RAND_END);
%%7-6-98[MI,lambda]=MutualInfo(result,Y);
lambda=abs(corr(result,Y));     %99-1-15        %%%%%%%%%lambda = MutualInformation(result,Y);
%M=fastDcov(Y,Y);
%lambda=distcorr(result,Y);

  MII=lambda;
     %if isnan (MII)
      %   MII=0;
     %end
     %if ~(isreal(MII))
      %   MII=0;
     %end
    % if (max(result)==min(result)|| isinf(sum(result)))
    % MII=0;
    % end
   
 testdataMI=MII;
end

