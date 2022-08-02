function [Par, broth]=NodeParent_Final(buffer,buffercounter)

global  FSET_END 
S=load('temp_global_parallel');
FSET_END=S.FSET_END;

     if (buffercounter==1 || buffercounter==0)
         Par=0;
         broth=0;
         
     elseif (buffer(buffercounter-1)>0 && buffer(buffercounter-1)<FSET_END+1) 
         Par=buffercounter-1;
         broth=0; 
         
     else 
     tra=traverse_Final(buffer,buffercounter);
        for i=buffercounter-1:-1:1
                nodetra=traverse_Final(buffer, i);
                if (nodetra==tra)
                    Par=i;
                    broth=Par+1;
                    break
                end
        end
         
     end
end

        
 
              