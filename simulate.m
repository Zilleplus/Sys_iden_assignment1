function [ y,DC ] = simulate( input,nsim )
%SIMULATE Summary of this function goes here
%   Detailed explanation goes here

m = numel(input);
y = zeros(m,1);
DC = 0;
for i = 1:nsim
    output = exercise2(input);
    y = y + output./nsim;
    DC = DC + mean(output)/nsim;
end

end

