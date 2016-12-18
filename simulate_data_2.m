% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Generation of the data ( input / output )
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;

disp('starting simulations');
nsim = 200;  % number of simulations
Nest = 1000; % estimation set size
Nval = 500;  % validation set size  
N = Nest + Nval;

disp('simulating zeros');
len = 1000 ;
u_zero = zeros(len,1); 
[y_zero] = simulate(u_zero,nsim);

disp('simulating impulse response');
len = 1000;
u_impulse_response = [3; zeros(len,1)];
[y_impulse_response,~] = simulate(u_impulse_response,nsim);

disp('simulating impulse train');
number_of_impulses = 5;
u_impulse_response_train = repmat([3;zeros(20,1)],number_of_impulses,1);
[y_impulse_response_train,~] = simulate(u_impulse_response_train,nsim);

disp('simulating step');
len = 1000;
u_step = ones(len,1);
[y_step,~] = simulate(u_step,nsim);

disp('simulating sinus');
len = 1000;
u_sin = sin(1:len);
[y_sin,~] = simulate(u_sin,nsim);

disp('simulating white noise');
len = N;
u_white_noise = randn(len,1);
[y_white_noise,~] = simulate(u_white_noise,nsim);

disp('simulating Pseudorandom binary sequence (PRBS)');
len = N;
u_prbs= idinput(len,'prbs',[0,1],[-3,3]);
[y_prbs,~] = simulate(u_prbs,nsim);

disp('simulating sine wave at several frequencies')
% TO DO 

save('simulation_data_2.mat');
