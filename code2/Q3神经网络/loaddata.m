%%������Ԥ��
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
xlabel('����')
ylabel('����ֵ')
legend('BPԤ������ֵ','ʵ������ֵ')
e = yhat - Y1;
er = e./Y1;
max(er)
mean(er)
%%������Ԥ��end