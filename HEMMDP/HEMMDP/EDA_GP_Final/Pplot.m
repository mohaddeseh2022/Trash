function Pplot(p0bar,gen,j)
iter=j;
Y=5*iter;
figure(Y)
plot(gen,p0bar(1));
title('p0bar(+) vs gen ')
xlabel('gen')
ylabel('p0bar(+)')
hold on