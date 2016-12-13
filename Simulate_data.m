clear all; close all;

disp('starting simulation');

disp('simulating zeros');
nsim=1000;len=100;
u_zero = zeros(len,1);
y_zero = exercise2(u_zero);

disp('simulating impulse response');
nsim=1000;len=100;
u_impulse_response = [3; zeros(len,1)];
y_impulse_response = exercise2(u_impulse_response);

% do the same as witht the impulseresponse, but do it 5 times
disp('simulating impulse train');
nsim=1000;len=100;number_of_impulses=5;
u_impulse_response_train = repmat(u_impulse_response,number_of_impulses,1);
y_impulse_response_train = exercise2(u_impulse_response_train);

disp('TODO generate with white noise');

disp('TODO generate sinuses to create the bode plot');

save('simulation_data.mat');
