function [ testdataMI ] = TestMI_ver3( buffer,rnd,varnumber,testD )
 Y = testD(:,varnumber+1);
   
  [result, pos] = run_ver3(buffer,1,testD,rnd);
%%7-6-98 [MI,lambda]=MutualInfo(result,Y);
lambda=abs(corr(result,Y));% 15-1-99
%M=fastDcov(Y,Y);
%lambda=distcorr(result,Y);

   %%%%%%%lambda = MutualInformation(result,Y);
  MII=lambda;
    % if isnan (MII)
     %    MII=0;
     %end
     %if ~(isreal(MII))
      %   MII=0;
     %end
     %if (max(result)==min(result)|| isinf(sum(result)))
    % MII=0;
    % end
   
 testdataMI=MII;
end

