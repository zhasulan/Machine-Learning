clear
clc
load ('ex5data1.mat');
m = size(X, 1);
theta = [1 ; 1];
X = [ones(m, 1) X];
lambda = 1;

theta = [1 ; 1];
[J, grad] = linearRegCostFunction(X, y, theta, lambda);


lambda = 0;

clc