clear all; close all;

disp('starting simulations');
nsim=200;

disp('simulating zeros');
len=1000;
u_zero = zeros(len,1); 
[y_zero] = simulate(u_zero,nsim);

disp('simulating impulse response');
len=1000;
u_impulse_response = [3; zeros(len,1)];
[y_impulse_response,~] = simulate(u_impulse_response,nsim);

disp('simulating impulse train');
len=100;number_of_impulses=5;
u_impulse_response_train = repmat(u_impulse_response,number_of_impulses,1);
[y_impulse_response_train,~] = simulate(u_impulse_response_train,nsim);

disp('simulating white noise');
len=1000;
u_white_noise = randn(len,1);
[y_white_noise,~] = simulate(u_white_noise,nsim);

disp('simulating step');
len=500;
u_step = ones(len,1);
[y_step,~] = simulate(u_step,nsim);

disp('simulating sinus');
len=1000;
u_sin = sin(1:len);
[y_sin,~] = simulate(u_sin,nsim);

disp('simulating Pseudorandom binary sequence (PRBS)');
len = 2000;
u_prbs= idinput(len,'prbs',[0,1],[-3,3]);
[y_prbs,~] = simulate(u_prbs,nsim);

save('simulation_data_2.mat');
