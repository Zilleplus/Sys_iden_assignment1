% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Identification part ;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all; 
load('simulation_data_2.mat')

% Data
N_est = 1000;
N_val = 500;
delay = 15;
preprocessed_prbs_est = preprocessing( iddata(y_prbs(1:N_est), ...
    u_prbs(1:N_est),1),[], delay, 20, 1); % estimation data set
preprocessed_prbs_val = preprocessing( iddata(y_prbs(N_est+1:N_est+N_val), ...
    u_prbs(N_est+1:N_est+N_val),1),[], delay, 20, 1); % validation data set

%% ARX-model
disp('testing ARX model ..');
na = ; % to be choosen
nb = ; % to be choosen
nk = 15; % estimated delay

% Generate model-order combinations for estimation
search_region = struct([na-2:na+2],[nb-2:nb+2],[nk-1:nk+1]);

% Estimate ARX models and compute the loss function for each model order 
% combination
V = arxstruc([preprocessed_prbs_est.y, u_prbs(1:N_est)], ...
    [preprocessed_prbs_val.y, u_prbs(N_est+1:N_est+N_val), search_region];

% Select the model order with the best fit to the validation data
order = selstruc(V,0);

% Estimate an ARX model of selected order.
model = arx([preprocessed_prbs_est.y, u_prbs(1:N_est)], order);

% Compare model output and measured output
[y_model,fit] = compare([preprocessed_prbs_val.y u_prbs(N_est+1: ...
    N_est+N_val)], model);

figure(); clf;
[E,R] = resid([preprocessed_prbs_val.y u_prbs(N_est+1:N_est+N_val)], ...
    model);

% Pole-zero map of system model
figure(); clf;
pzplot(model); grid on;




