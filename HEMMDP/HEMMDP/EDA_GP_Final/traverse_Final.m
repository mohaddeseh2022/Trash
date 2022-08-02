function len = traverse_Final(buffer, buffercount)
global FSET_END
S=load('temp_global_parallel');
FSET_END=S.FSET_END;
 if (buffer(buffercount) > FSET_END)
    len = buffercount+1;
else
    len = traverse_Final(buffer,traverse_Final(buffer,buffercount+1));
end