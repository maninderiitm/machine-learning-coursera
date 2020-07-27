function [J, grad] = nnCostFunction(nn_params, ...
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

y1= zeros(m , num_labels);

for i= 1:m
    k= y(i);
    y1(i,k)= true;
    
end
y= y1 ;
yn=y;

%y = repmat([1:num_labels], m, 1) == repmat(y, 1, num_labels);
X= [ones(m,1),X]; %5000*401

a2=(sigmoid( X* Theta1'));  % 5000*25
a2n=[ ones(m,1),a2];  %5000*26
h= sigmoid(a2n*Theta2'); %5000*10
h1=h;


cost = -y.* log(h) - (1 - y) .* log(1 - h);

J = (1 / m).* sum(sum(cost));


 % for regulariged cost function
 theta1ExcludingBias = Theta1(:, 2:end);
theta2ExcludingBias = Theta2(:, 2:end);

reg1 = sum(sum(theta1ExcludingBias .^ 2));
reg2 = sum(sum(theta2ExcludingBias .^ 2));

J = (1 / m) * sum(sum(cost)) + (lambda / (2 * m)) * (reg1 + reg2);


  %for sigmoid backpropagation

delta1= zeros(size(Theta1));
delta2= zeros(size(Theta2));

for t= 1:m
    ht= h1(t,:);  %5000*10
    yt= yn(t,:);  %5000*10
    a1t= X(t,:);  %5000*401
    a2t= a2n(t,:); %5000*26
    d3t= ht-yt; %5000*10
    d2= d3t*Theta2 .* (a2t .*(1-a2t)); %5000*26
    d2t= d2';
    d2t= d2t(2:end,:);
delta1= delta1 + (d2t *(a1t)); % 25*401
delta2= delta2 +(d3t' * (a2t)); %10*26


Theta1exclu_bias= [zeros(size(Theta1,1),1) , Theta1(:, 2:end) ];
Theta2exclu_bias= [zeros(size(Theta2,1),1) , Theta2(:, 2:end) ];
Theta1_grad = (1 / m) * delta1 + ((lambda/m).* Theta1exclu_bias);  %25*401
Theta2_grad = (1 / m) * delta2 +((lambda/m) .* Theta2exclu_bias);  %10*26

end



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
