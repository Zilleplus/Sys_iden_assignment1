clear all; close all;

freq = logspace(1,9,100);
num_freq = length(freq);
amplitude = 3;
n = 4;
m = 500;
L = n*m;
t1 = (0:L-1)/n/freq(1);
u_mut_sine = zeros(n*m,num_freq);
y_mut_sine = zeros(n*m,num_freq);
t_sine = 0:1/L:1-1/L;
disp('begin sim');
for k = 1:num_freq
    Fs = n*freq(k);               % Sampling frequency
    T = 1/Fs;                     % Sample time

    u_mut_sine(:,k) = amplitude*sin(2*pi*freq(k)*t_sine);
    %y_mut_sine(:,k) = simulate(u_mut_sine(:,k),10);
end

save('bodeData.mat');                  