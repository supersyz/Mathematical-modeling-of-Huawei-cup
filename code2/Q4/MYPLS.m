clear;clc;
load 'X.mat';

n=22;m=2;
x0=X(:,1:n);y0=X(:,n+1);
[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(x0,y0);

figure(1)
cumsum(100*PCTVAR(1,:))
plot(cumsum(100*PCTVAR(1,:)),'-bo');
xlabel('PLS成分数');
ylabel('自变量方差解释程度');
figure(2)
plot(cumsum(100*PCTVAR(2,:)),'-bo');
xlabel('PLS成分数');
ylabel('因变量方差解释程度');