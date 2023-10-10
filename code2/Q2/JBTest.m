%% JBºÏ—È
clear;clc;
load 'X.mat';
n = size(Test,2);
H = zeros(1,6);
p = zeros(1,6);
for i = 1:n
    [h,p] = jbtest(Test(:,i),0.05);  
    H(i) = h;
    p(i)= p;
end
%%JBºÏ—Èend
