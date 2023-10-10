%%因变量自变量spearman相关筛选
clear;clc;
load 'X.mat';
load 'Y.mat';
load 'Y1.mat';
n = size(Test,2);
R = zeros(1,358);
P = zeros(1,358);
R1 = zeros(1,358);
P1 = zeros(1,358);
for i = 1:n
    [r,p] = corr(Y,Test(:,i),'type','Spearman');
    R(i) = r;
    P(i) = p;

end
for i = 1:n
    [r1,p1] = corr(Y1,Test(:,i),'type','Spearman');
    R1(i) = r1;
    P1(i) = p1;
end
%%因变量自变量spearman相关筛选结束