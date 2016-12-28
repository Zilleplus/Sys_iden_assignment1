run('identification_init');

% Subspace model
close all; disp('Testing SUBSPACE model ...');
nx = 3:20;
[model, fit, aic_value ] = fun_subspace_model(nx,...
    preprocessed_prbs_est, preprocessed_prbs_val, true)

