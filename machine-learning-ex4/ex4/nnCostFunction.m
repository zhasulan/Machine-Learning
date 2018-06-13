function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

delta1 = 0;
delta2 = 0;

a1 = X; % 5000 x 400
a1 = [ones(size(a1, 1), 1) a1]; % 5000 x 401 OK
a2 = sigmoid(a1 * Theta1'); % 5000 x 401 *** 401 * 25 = 5000 x 25
a2 = [ones(size(a2, 1), 1) a2]; % 5000 x 26  OK
a3 = sigmoid(a2 * Theta2'); % 5000 x  26 ***  26 * 10 = 5000 x 10


Y = [y==1];
for i= 2:num_labels
  Y = [Y y==i];
end

% Y = [5000 x 10]

%for i = 1:m
%  for k = 1:num_labels
%    J = J + (-Y(i, k)*log(a3(k, i)) - (1-Y(i, k))*log(1-a3(k, i)));
%  end
%end

%J = (1/m) * J;

%(-Y(1, 1)*log(a3(1, 1)) - (1-Y(1, 1))*log(1-a3(1, 1)))

J = (1/m) * sum(diag(-Y*log(a3)' - (1 - Y)*log(1 - a3)'));

% Regularization
J = J + (lambda / (2*m)) * ( sum(sum(Theta1(:, 2:size(Theta1, 2)) .^ 2)) + sum(sum(Theta2(:, 2:size(Theta2, 2)) .^ 2 )) );


de3 = a3 - Y; % 5000 x 10 - 5000 x 10 = 5000 x 10
de2 = ( de3 * Theta2 ) .* a2 .* (1 - a2); % 5000 x 10 *** 10 x 26  .* 5000 x 26 = 5000 x 26

delta1 = delta1 + (a1' * de2)'; % 401 x 5000 *** 5000 x 26 ??? 401 x 26 ~ 26 x 401
delta2 = delta2 + (a2' * de3)'; %  26 x 5000 *** 5000 x 10 ???  26 x 10 ~ 10 x 26

delta1 = delta1(2:size(delta1, 1), :);
%delta2 = delta2(2:size(delta2, 1), :);

%Regularuzation
Theta1_reg = (lambda/m)*Theta1;
Theta2_reg = (lambda/m)*Theta2;

Theta1_reg = [zeros(size(Theta1_reg, 1), 1 ) Theta1_reg(:, 2:size(Theta1_reg, 2))];
Theta2_reg = [zeros(size(Theta2_reg, 1), 1 ) Theta2_reg(:, 2:size(Theta2_reg, 2))];

Theta1_grad = (1/m) * ( delta1 ) + Theta1_reg; % 25 * 401
Theta2_grad = (1/m) * ( delta2 ) + Theta2_reg; % 10 * 26

%for i=1:m
%
%end





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
