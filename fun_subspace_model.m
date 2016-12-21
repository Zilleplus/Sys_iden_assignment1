function [model, fit, aic_value, mag, wout ] = fun_subspace_model(nx,...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot)
% Estimate an ARMAX model of selected order.
model = n4sid( preprocessed_prbs_est, nx );

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
    
    figure(4); clf;
    bode(model);
end

end

