function [model, order, fit, aic_value, mag, wout ] = fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% % Generate model-order combinations for estimation
search_region = struc([na-2:na+2],[nb-2:nb+2],0);

% Estimate ARX models and compute the loss function for each model order
% combination
V = arxstruc(preprocessed_prbs_est, preprocessed_prbs_val, ...
     search_region);

% Select the model order with the best fit to the validation data
order = selstruc(V,0);

nk = 0;
order = [na nb nk];

% Estimate an ARX model of selected order.
model = arx(preprocessed_prbs_est, order);

% Compare model output and measured output.
[y_model,fit] = compare(preprocessed_prbs_val, model);

% Computes Akaike's Information Criterion.
aic_value = aic(model);

[mag,phase,wout] = bode(model); 
mag = squeeze(mag);

if show_plot
    figure(1); clf;
    plot(y_model.y); hold on;
    plot(preprocessed_prbs_val.y);
    
    % Compute and test the residuals
    figure(2); clf;
    resid(preprocessed_prbs_val, model);
    
    % Pole-zero map of system model
    figure(3); clf;
    pzplot(model);
    
    figure(4);clf;
    bode(model)
end

end

