% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Experimental Bode Plot
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;

disp('Simulation data for experimental Bode plot ...');

freq = (1:100);
amplitude = 2.5;
len_test = 200;

u_mut_sine = zeros(len_test,numel(freq));
y_mut_sine = zeros(len_test,numel(freq));
t_sine = 0:1/len_test:1-1/len_test;

for k = 1:numel(freq)   
   u_mut_sine(:,k) = amplitude*sin(2*pi*freq(k)*t_sine);
   y_mut_sine(:,k) = simulate(u_mut_sine(:,k),50);
end

save('bodedata.mat')