%%神经网络预测
clear;clc;
load 'data.mat';
load 'NN.mat'
num = size(X1,1);
yhat = zeros(97,1);
for i=1:num
    r = sim(net,X1(i,:)');
    yhat(i,:) = r;
end

plot(yhat) ;hold on;
plot(Y1)
xlabel('样本')
ylabel('辛烷值')
legend('BP预测辛烷值','实际辛烷值')
e = yhat - Y1;
er = e./Y1;
max(er)
mean(er)
%%神经网络预测end