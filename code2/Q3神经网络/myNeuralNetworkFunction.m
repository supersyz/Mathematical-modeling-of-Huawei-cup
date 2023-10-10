function [Y,Xf,Af] = myNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 20-Sep-2020 09:29:46.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx22 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx1 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [57;85.3;48.3;16;6.39;715.1;1.01;4.96;0.227725;11.350653;415.82025;2.276681;180.756203;0.639048;112.1496;45.893334;22.924086;31.503612;91.305858;0.67497;0;0];
x1_step1.gain = [0.00671140939597315;0.3125;0.132450331125828;0.196078431372549;0.0311963812197785;0.0847457627118643;0.231749710312862;0.245398773006135;14.784369964074;0.0925180641520257;0.13008185075254;10.3035954396286;0.0302298433941452;94.5358290792207;0.0992749454360081;0.205888895969179;0.119505460114844;0.301416173750751;0.0362738585636912;3.30802692733919;0.000651740112699226;0.000691318669882485];
x1_step1.ymin = -1;

% Layer 1
b1 = -0.1981110508739122;
IW1_1 = [0.0039400644068983927 0.86048287206904739 -0.029081655226408695 0.0056212317861229098 -0.012864850582209939 -0.0063938710411461574 0.0078108554701387823 -0.013600801954810924 -0.033541243619177472 -0.029235148806648219 -0.047757580222491387 -0.010993845145470849 1.4245564784980472e-05 0.0008883969253156189 -0.015262993711786599 0.01147938462668263 -0.00018335226786585657 -0.02544732346386322 0.010963719580069062 -0.00430489890364779 -0.033202978406496893 0.0096343579315716944];

% Layer 2
b2 = 0.074013068661425901;
LW2_1 = 1.4814516930462678;

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.37593984962406;
y1_step1.xoffset = 85.1;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX, X = {X}; end;

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},1); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    X{1,ts} = X{1,ts}';
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
    Y{1,ts} = Y{1,ts}';
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end
