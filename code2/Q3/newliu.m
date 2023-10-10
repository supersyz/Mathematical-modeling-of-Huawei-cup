clear;clc;
load 'mydata.mat';
load 'X.mat'

final = zeros(num,2);
for i=1:num
    C = -xish(:,1);
    c0 = ch0(i,1);
    A = [0,0,0,-0.1561647,0,0,0,0,0,0,-0.973214,0,0,-39.95294,0,-0.1178512,0,0,0,-3.430622,-0.000461,0];
%     size(A)
%     A = xish(:,2)';
    b = 5-ch0(i,2);
    [max_a,index1] = max(X,[],1);
    [min_a,index2] = min(X,[],1);
    lb = min_a(:,1:22);
    ub = max_a(:,1:22);
    lb(:,1:8) = 0;
    ub(:,1:8) = 0;
    lb(:,1:8) = X(i,1:8);
    ub(:,1:8) = X(i,1:8);
    [x,fval] = linprog(C,A,b,[],[],lb,ub);
    final(i,1) = -fval+c0;
    final(i,2) = 69.73141+x'* A';

end

red = y0 - final
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