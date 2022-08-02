function plot_Final(MImean,MIvalidmean,MIvar,MImax,gennum,j)
%the same as plot_ver2

%iteration=j-1;
%iter=4*iteration;
gen=1:gennum;

%figure(1+iter)
figure(j)
subplot(2,2,1)
plot(gen,MImean,gen,MIvalidmean,'--');
title('MImean\MIvalidmean vs gen ')
xlabel('gen')
ylabel('MImean\MIvalidmean')
%print(fig,'MImeanvsgen','-dpng')


%figure(2+iter)
subplot(2,2,2)
plot(gen,MIvar);
title('MIvar vs gen ')
 xlabel('gen')
 ylabel('MIvar')
%print(fig,'MIvarvsgen','-dpng')

 
% %figure(3+iter)
% subplot(2,2,3)
% plot(gen,MImax,gen,SigmaCorr,'--');
% title('MImax vs gen\SigmaCorr vs gen ')
%  xlabel('gen')
%  ylabel('MImax\SigmaCorr')
% 

 subplot(2,2,3)
plot(gen,MImax);
title('MImax vs gen')
 xlabel('gen')
 ylabel('MImax')
 


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











