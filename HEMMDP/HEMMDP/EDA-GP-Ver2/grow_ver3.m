function [pos, buffer] = grow_ver3(buffer, pos, d, varnumber,Var_START, RAND_START,RAND_END, max, FSET_START, FSET_END,paramet)

if (pos >= max || pos==-1)
pos = -1;
else
    if (pos == 1)
        prim = 0;
    else
        prim = rand;
    end
    switch(paramet)
        case(1)
            prob1=0.85;
            prob2=0.5;
            newprob=0;
            
        case(2)
            prob1=0.4;
            prob2=0;
             newprob=0;
            
        case(3)
            prob1=0.25;
            prob2=0;
            newprob=0;
        case(4)
            prob1=0.8;
            prob2=0;
            newprob=0;
        case(5)
            prob1=0.7;
            prob2=0.3;
             newprob=0;
            
        case(6)
            prob1=0.25;
            prob2=0.3;
             newprob=0;
        case(7)
            prob1=0.8;
            prob2=0.3;
             newprob=0;
        case(8)
            prob1=0.5;
            prob2=0.3;
             newprob=0;
    end
    if (prim > prob1 || d == 0) 
        varoran=rand;
        if (varoran > prob2)
            var = rand;
            buffer = [buffer Var_START+floor((varnumber)*var)];
            pos = pos + 1;
        else
            var = rand;
            buffer = [buffer RAND_START+floor((RAND_END-RAND_START+1)*var)];
            pos = pos + 1;
        end
    else
         newvaroran=rand;
        if (newvaroran > newprob)
        op = rand;
        buffer = [buffer (FSET_START+2)+floor((FSET_END-FSET_START-2+1)*op)]; %Div MUL
        pos = pos + 1;
        [pos, buffer] = grow_ver3(buffer, pos, d - 1, varnumber,Var_START, RAND_START, RAND_END, max, FSET_START, FSET_END,paramet);
        else
        op = rand;
        buffer = [buffer FSET_START+floor((FSET_END-FSET_START-2+1)*op)]; %ADD SUB
        pos = pos + 1;
        [pos, buffer] = grow_ver3(buffer, pos, d - 1, varnumber,Var_START, RAND_START, RAND_END, max, FSET_START, FSET_END,paramet); 
        end
        if pos ~= -1
            [pos, buffer] = grow_ver3(buffer, pos, d - 1, varnumber,Var_START, RAND_START, RAND_END, max, FSET_START, FSET_END,paramet);
        end
    end
end