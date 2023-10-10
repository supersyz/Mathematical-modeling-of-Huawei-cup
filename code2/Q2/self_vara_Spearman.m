%% 三级筛选自变量间spearman相关性筛选
clear;clc;
load 'X.mat';
yq = Test(:,1:7);
xq = Test(:,8:11);
cq = Test(:,12:end);
yn = size(yq,2);
xn = size(xq,2);
cn = size(cq,2);
[yR,yP]=corr(yq,'type','Spearman');

[xR,xP]=corr(xq,'type','Spearman');
[cR,cP]=corr(cq,'type','Spearman');
%%三级筛选自变量间spearman相关性筛选结束
