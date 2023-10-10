%%优化辛烷值
clear;clc;
load 'mydata.mat';
load 'X.mat'

final = zeros(num,2);
X2 = zeros(325,22);
for i=1:num
    C = -xish(:,1);
    c0 = ch0(i,1);
    A = [xish(:,2)';xish(:,1)'];
    b = [5-ch0(i,2);X(i,2)-0.3-ch0(i,1)];
    [max_a,index1] = max(X,[],1);
    [min_a,index2] = min(X,[],1);
    lb = min_a(:,1:22);
    ub = max_a(:,1:22);
    lb(:,1:8) = 0;
    ub(:,1:8) = 0;
    lb(:,1:8) = X(i,1:8);
    ub(:,1:8) = X(i,1:8);
    [x,fval] = linprog(C,A,b,[],[],lb,ub);
    X2(i,:) = x';
    final(i,2) = -fval+c0;
    final(i,1) = ch0(i,2)+x'*xish(:,2);

end

reuse= X(:,1:2) - final;
m1 = reuse(:,2);
sum(m1<0)
m2 = X(:,2) - y0(:,1);
m = (m2-m1) ./ m2;
min(m)
%%优化辛烷值end
% min(reuse(:,2))
% max(reuse(:,2))
% C = -xish(:,1);
% c0 = ch0(133,1);
% A = xish(:,2)';
% b = 5-ch0(133,2);
% 
% 
% [max_a,index1] = max(X,[],1);
% [min_a,index2] = min(X,[],1);
% 
% lb = min_a(:,1:22);
% ub = max_a(:,1:22);
% lb(:,1:8) = 0;
% ub(:,1:8) = 0;
% 
% 
% lb(:,1:8) = X(133,1:8);
% ub(:,1:8) = X(133,1:8);
% 
% 
% [x,fval] = linprog(C,A,b,[],[],lb,ub)
% final = -fval+c0
% 
% yhat=ch0(:,1)+x'*xish(:,1);
% liuhat = ch0(133,2)+x'*xish(:,2);