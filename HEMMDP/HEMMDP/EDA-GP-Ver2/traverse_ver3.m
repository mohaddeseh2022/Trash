function len = traverse_ver3(buffer, buffercount)
global FSET_END

S=load('temp_global_parallel');
FSET_END=S.FSET_END;

 if (buffer(buffercount) > FSET_END)
    len = buffercount+1;
else
    len = traverse_ver3(buffer,traverse_ver3(buffer,buffercount+1));
end