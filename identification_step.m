% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Identification part ;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all; 
load('simulation_data_3.mat')

% Data
N_est = 1000;
N_val = 500;
delay = 15;
preprocessed_prbs_est = preprocessing( iddata(y_prbs_est,...
    u_prbs(1:N_est),1),[], delay, 20, 0); % estimation data set
preprocessed_prbs_val = preprocessing( iddata(y_prbs_val,...
    u_prbs(N_est+1:N),1),[], delay, 20, 0); % validation data set

%%
na = 20; nb = 20;
[model, order, fit, aic_value ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,true )

%% 
na = 3:10:200;
nb = 3:10:200;
fit = zeros(numel(na),numel(nb));
aic_value = zeros(numel(na),numel(nb));
for i = 1:numel(na)
    for j = 1:numel(nb)
[~, ~, fit(i,j), aic_value(i,j) ]= fun_arx_model(na(i),nb(j), ...
    preprocessed_prbs_est, preprocessed_prbs_val,false );
    end
end


