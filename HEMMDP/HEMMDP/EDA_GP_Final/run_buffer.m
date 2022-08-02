
function [ReSbufferi,outbuf]=run_buffer(Sbuffer,jnum,BlockValue,trnD,rnd) 
S=load('temp_global_parallel');
RAND_END=S.RAND_END;
i=1;
    buffer2{jnum}{i}=Sbuffer;
     if jnum>1
     [buffer2,~]=CalccoefficientFinal(BlockValue,jnum,i,buffer2);
     end
     rnd2{i}=rnd;
     [ReSbufferi, ~]=run_verComb(buffer2{jnum}{i},1,trnD,rnd2{i},RAND_END);
     outbuf=buffer2{jnum}{i};
end
