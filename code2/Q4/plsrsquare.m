clear;clc;
load 'X.mat';
mu=mean(X);sig=std(X);%求均值和标准差
rr=corrcoef(X);%求相关系数矩阵
data=zscore(X); %数据标准化,变量记做 X*和 Y*
n=22;m=2; %n 是自变量的个数,m 是因变量的个数
x0=X(:,1:n);y0=X(:,n+1:end); %原始的自变量和因变量数据
e0=data(:,1:n);f0=data(:,n+1:end); %标准化后的自变量和因变量数据
num=size(e0,1);%求样本点的个数
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] =plsregress(e0,f0);
xw = stats.W; %求自变量提出成分系数，每列对应一个成分，这里xw等于stats.W
yw = f0\YS;  %求因变量提出成分的系数
a_0=PCTVAR(1,:);b_0=PCTVAR(2,:);
a_1=cumsum(a_0);b_1=cumsum(b_0);
i=1;%赋初始值
%判断提出成分对的个数
while ((a_1(i)<0.9)&(a_0(i)>0.05)&(b_1(i)<0.9)&(b_0(i)>0.05))
    i=i+1;
end
ncomp=i;
fprintf('%d对成分分别为：\n',ncomp);

for i=1:ncomp
    fprintf('第%d对成分：\n',i);
    fprintf('u%d=',i);
    for k=1:22%此处为变量x的个数
        fprintf('+(%f*x_%d)',xw(k,i),k);
    end
    fprintf('\n');
        fprintf('v%d=',i);
    for k=1:2%此处为变量y的个数
        fprintf('+(%f*y_%d)',yw(k,i),k);
    end
    fprintf('\n');
    
end

[XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] =plsregress(e0,f0,ncomp);
n=size(e0,2); m=size(f0,2);%n是自变量的个数,m是因变量的个数
beta3(1,:)=mu(n+1:end)-mu(1:n)./sig(1:n)*BETA2([2:end],:).*sig(n+1:end); %原始数据回归方程的常数项
beta3([2:n+1],:)=(1./sig(1:n))'*sig(n+1:end).*BETA2([2:end],:); %计算原始变量x1,...,xn的系数，每一列是一个回归方程
fprintf('最后得出如下回归方程：\n')
for i=1:2%此处为变量y的个数
    fprintf('y%d=%f',i,beta3(1,i));
    for j=1:22%此处为变量x的个数
        fprintf('+(%f*x%d)',beta3(j+1,i),j);
    end
    fprintf('\n');
end
figure(1)
a = BETA2(:,1)';
bar(BETA2(:,1)',0.8,'k')   %画直方图
xlabel('自变量序号')
ylabel('自变量标准化系数')
% for i=1:length(a)
% 
%     text(i,a(i),num2str(a(i))
% 
% end
fprintf('因变量y的预测值：\n');
yhat=repmat(beta3(1,:),[size(e0,1),1])+X(:,[1:n])*beta3([2:end],:);  %求y1,..,ym的预测值

e = yhat-y0;
er = e./y0;
max(abs(er))
min(abs(er))
mean(abs(er))
ymax=max([yhat;X(:,[n+1:end])]); %求预测值和观测值的最大值
%下面画y1,y2,y3的预测图，并画直线y=x
figure(2)
plot(yhat(:,1),X(:,n+1),'*',[0:100],[0:100],'Color','k')
legend('辛烷值预测图')
axis([82,94,82,94]);
% plot(yhat(:,2),X(:,n+2),'O',[0:ymax(2)],[0:ymax(2)],'Color','k')
% legend('弯曲成绩预测图',2)
figure(3)
 bar(beta3(:,1)',0.8,'k') 
xlabel('自变量序号')
ylabel('自变量系数')

