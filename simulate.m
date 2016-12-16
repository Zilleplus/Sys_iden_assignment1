function [ y, DC ] = simulate( input, nsim )
m = numel(input); % length of the input signal
y = zeros(m,1);
DC = 0;
for i = 1:nsim
    output = exercise2(input);
    y = y + output./nsim;
    DC = DC + mean(output)/nsim;
end
end

