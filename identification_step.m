% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Identification part ;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;
load('simulation_data_3.mat')

% Data
delay = 15;
preprocessed_prbs_est = preprocessing( iddata(y_prbs_est,...
    u_prbs(1:N_est),1),[], delay, 20, 0); % estimation data set
preprocessed_prbs_val = preprocessing( iddata(y_prbs_val,...
    u_prbs(N_est+1:N),1),[], delay, 20, 0); % validation data set

%%
na = 11; nb = 12;
[model, order, fit, aic_value, mag ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,false );
[mag,phase,wout] = bode(model)
mag = squeeze(mag);
%% ARX model
na = 9:2:20; 
nb = 9:2:20;
fit = zeros(numel(na),numel(nb));
aic_value = zeros(numel(na),numel(nb));

for i = 1:numel(na)
    for j = 1:numel(nb)
        [~, ~, fit(i,j), aic_value(i,j) ]= fun_arx_model(na(i),nb(j), ...
            preprocessed_prbs_est, preprocessed_prbs_val,false );
    end
end


%% ARMAX model
na = 9:2:20;
nb = 9:2:20;
nc = 4;
fit = zeros(numel(na),numel(nb),numel(nc));
aic_value = zeros(numel(na),numel(nb),numel(nc));

for i = 1:numel(na)
    for j = 1:numel(nb)
        for k = 1:numel(nc)
            [~, fit(i,j,k) , aic_value(i,j,k) ] = fun_armax_model(na(i), nb(j), nc(k),...
                preprocessed_prbs_est, preprocessed_prbs_val, false);
        end
    end
end

