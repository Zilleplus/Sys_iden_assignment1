% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Identification part ;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;
load('simulation_data_3.mat')
addpath('esat_functions');


% Data
delay = 15;
preprocessed_prbs_est = fun_preprocessing( iddata(y_prbs_est,...
    u_prbs(1:N_est),1),[], delay, 20, 0); % estimation data set
preprocessed_prbs_val = fun_preprocessing( iddata(y_prbs_val,...
    u_prbs(N_est+1:N),1),[], delay, 20, 0); % validation data set