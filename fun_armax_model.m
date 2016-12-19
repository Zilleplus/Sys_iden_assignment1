function [model, fit, aic_value ] = fun_armax_model(na, nb, nc,...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

nk = 15; % estimated delay

% Estimate an ARX model of selected order.
model = armax(preprocessed_prbs_est,[na nb nc nk]);

% Compare model output and measured output.
[y_model,fit] = compare(preprocessed_prbs_val, model);

% Computes Akaike's Information Criterion.
aic_value = aic(model);

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
    
    figure(4); clf;
    bode(model);
end

end

