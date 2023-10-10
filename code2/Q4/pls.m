clear;clc;
load 'X.mat';
mu=mean(X);sig=std(X);%求均值和标准差
rr=corrcoef(X);%求相关系数矩阵
data=zscore(X); %数据标准化,变量记做 X*和 Y*
n=22;m=2; %n 是自变量的个数,m 是因变量的个数
x0=X(:,1:n);y0=X(:,n+1:end); %原始的自变量和因变量数据
e0=data(:,1:n);f0=data(:,n+1:end); %标准化后的自变量和因变量数据
num=size(e0,1);%求样本点的个数
chg=eye(n); %w 到 w*变换矩阵的初始化
for i=1:n
    %以下计算 w，w*和 t 的得分向量，
    matrix=e0'*f0*f0'*e0;
    [vec,val]=eig(matrix); %求特征值和特征向量
    val=diag(val); %提出对角线元素，即提出特征值
    [val,ind]=sort(val,'descend');
    w(:,i)=vec(:,ind(1)); %提出最大特征值对应的特征向量
    w_star(:,i)=chg*w(:,i); %计算 w*的取值
    t(:,i)=e0*w(:,i); %计算成分 ti 的得分
    alpha=e0'*t(:,i)/(t(:,i)'*t(:,i)); %计算 alpha_i
    chg=chg*(eye(n)-w(:,i)*alpha'); %计算 w 到 w*的变换矩阵
    e=e0-t(:,i)*alpha'; %计算残差矩阵
    e0=e;
    %以下计算 ss(i)的值
    beta=t\f0; %求回归方程的系数，数据标准化，没有常数项
    cancha=f0-t*beta; %求残差矩阵
    ss(i)=sum(sum(cancha.^2)); %求误差平方和
    %以下计算 press(i)
    for j=1:num
        t1=t(:,1:i);f1=f0;
        she_t=t1(j,:);she_f=f1(j,:); %把舍去的第 j 个样本点保存起来
        t1(j,:)=[];f1(j,:)=[]; %删除第 j 个观测值
        beta1=[t1,ones(num-1,1)]\f1; %求回归分析的系数,这里带有常数项
        cancha=she_f-she_t*beta1(1:end-1,:)-beta1(end,:); %求残差向量
        press_i(j)=sum(cancha.^2); %求误差平方和
        
    end
    
   
   
    press(i)=sum(press_i);
    Q_h2(1)=1;
    if i>1, Q_h2(i)=1-press(i)/ss(i-1); end
    if Q_h2(i)<0.0975
    fprintf('提出的成分个数 r=%d',i); break
end

end
beta_z=t\f0; %求 Y*关于 t 的回归系数
xishu=w_star*beta_z; %求 Y*关于 X*的回归系数，每一列是一个回归方程
mu_x=mu(1:n);mu_y=mu(n+1:end); %提出自变量和因变量的均值
sig_x=sig(1:n);sig_y=sig(n+1:end); %提出自变量和因变量的标准差
ch0=mu_y-(mu_x./sig_x*xishu).*sig_y; %计算原始数据回归方程的常数项
for i=1:m
    xish(:,i)=xishu(:,i)./sig_x'*sig_y(i); %计算原始数据回归方程的系数
end
sol=[ch0;xish]; %显示回归方程的系数，每一列是一个方程，每一列的第一个数是常数项

y1 = zeros(352,2);
ch0=repmat(ch0,num,1);
yhat=ch0+x0*xish;

a = (yhat-y0) ./ y0;
b = max(abs(a));

save mydata x0 y0 num xishu ch0 xish



