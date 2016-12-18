function y = simulate(input,nsim)
% SIMULATE This MATLAB function simulates 'nsim' times the system 
% 'exercise2' with as input signal 'input' and returns then the average of 
% the output, y.
% Intput :  * input : vector, input signal ;
%           * nsim  : scalar, the number of simulations that is performed ;
% Output :  * y     : vector, average output signal ;
%
% System identification and modelling
% December 2016
m = numel(input);  % length of the input signal
y = zeros(m,1);    % preallocation
for k = 1:nsim
    output = exercise2(input);
    y = y + output/nsim;
end
end

