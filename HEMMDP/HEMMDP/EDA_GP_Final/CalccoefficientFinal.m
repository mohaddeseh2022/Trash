function [FBlock,n]=CalccoefficientFinal(BlockValue,k,j,FBlock)

global ADD SUB MUL DIV FSET_START FSET_END RAND_START Var_START RAND_END BLOCK_START BLOCK_END

S=load('temp_global_parallel');
ADD=S.ADD;
SUB =S.SUB;
MUL =S.MUL;
DIV =S.DIV;
FSET_START=S.FSET_START;
FSET_END=S.FSET_END;
RAND_START=S.RAND_START;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;
BLOCK_END=S.BLOCK_END;

% RAND_END=13;
% BLOCK_START=RAND_END+1;
n=size(FBlock{k}{j},2); 
end_of_string=n;
saved=k;

  for step=saved:-1:2
      i=1;
      while i<=end_of_string
          
     FinalB{saved}{j}=FBlock{saved}{j};
     
    if FinalB{saved}{j}(i)>=BLOCK_START
         n1=size(BlockValue{step-1}{FinalB{saved}{j}(i)-BLOCK_START+1},2);
         FBlock{saved}{j}(1:i-1)=FinalB{saved}{j}(1:i-1);
         FBlock{saved}{j}(i:i+n1-1)=BlockValue{step-1}{FinalB{saved}{j}(i)-BLOCK_START+1}(1:n1);
         FBlock{saved}{j}(i+n1:n1+n-1)=FinalB{saved}{j}(i+1:n);
         
        end_of_string=end_of_string+n1-1;
         i=i+n1;
         n=size(FBlock{saved}{j},2); 
    else
        i=i+1;
         
    end 
      end
  end
  