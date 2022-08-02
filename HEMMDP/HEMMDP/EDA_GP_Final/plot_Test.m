function plot_Test(TestMI,gennum,j)

%iteration=j-1;
%iter=4*iteration;
gen=1:gennum;
%figure(4+iter)
subplot(2,2,4)
plot(gen,TestMI);
title('TestMIvsgen ')
xlabel('gen')
ylabel('TestMI')
%print(fig,'TestMIvsgen','-dpng')


% figure(4)
% plot(gen,fitmean);
% title('fitmean vs gen ')
%  xlabel('gen')
%  ylabel('fitmean')
% 
% figure(5)
% plot(gen,fitvar);
% title('fitvar vs gen ')
%  xlabel('gen')
%  ylabel('fitvar')
% 
% figure(6)
% plot(gen,fitmax);
% title('fitmax vs gen ')
%  xlabel('gen')
%  ylabel('fitmax')











