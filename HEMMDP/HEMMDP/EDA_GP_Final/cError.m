function e = cError(Y1,Y2)

e = 0;
m = size(Y1,1);
if m==size(Y2,1)
    if (m==0)
        disp('Nan mishe Dige');
    else
        e = -sqrt(mean((Y1-Y2).^2));
    end
else
    disp('Warning: Dimension of Y1 and Y2 are not the same.');
end