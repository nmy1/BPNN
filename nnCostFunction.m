function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   labels, ...
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
                 labels, (hidden_layer_size + 1));

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

% For cost function
X=[ones(size(X,1),1),X];
a1=Theta1*X';
a1=sigmoid(a1);
a1=[ones(1,size(a1,2));a1];
output=sigmoid(Theta2*a1);

ytemp=zeros(labels,size(y,1));

for i=1:size(y,1)
    ytemp(y(i),i)=1;
end

regsum=sum(sum(Theta1(:,2:end).*Theta1(:,2:end)))+sum(sum(Theta2(:,2:end)...
    .*Theta2(:,2:end)));

cost=-(log(output)).*ytemp-(log(1-output)).*(1-ytemp);

J=sum(sum(cost))+lambda/2*regsum;
J=J/m;

%For backpropagation

%derta3=output-ytemp;

%derta2=Theta2'*derta3.*sigmoidGradient(sigmoid(Theta1*X'));

z2=Theta1*X';
z2=[ones(1,size(z2,2));z2];
for i=1:m
    derta3=output(:,i)-ytemp(:,i);
    derta2=Theta2'*derta3.*sigmoidGradient(z2(:,i));
    derta2=derta2(2:end);
    Theta2_grad=Theta2_grad+derta3*(a1(:,i))';
    Theta1_grad=Theta1_grad+derta2*X(i,:);
end

reg1=Theta1(:,2:end);
reg2=Theta2(:,2:end);
reg1=[zeros(size(reg1,1),1),reg1];
reg2=[zeros(size(reg2,1),1),reg2];
Theta1_grad=(Theta1_grad+lambda*reg1)/m;
Theta2_grad=(Theta2_grad+lambda*reg2)/m;











% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
