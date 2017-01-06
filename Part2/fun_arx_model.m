function [model, fit, aic_value, mag, wout ] = fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot )
nk = 0;

% Estimate an ARX model of selected order.
model = arx(preprocessed_prbs_est, [na nb nk]);

% Compare model output and measured output.
[y_model,fit] = compare(preprocessed_prbs_val, model);

% Computes Akaike's Information Criterion.
aic_value = aic(model);

% Computes the Bode plot.
[mag,phase,wout] = bode(model); 
mag = squeeze(mag);

if show_plot
    % Plot the output of the modeled system VS the real system.
    figure(1); clf;
    plot(y_model.y); hold on;
    plot(preprocessed_prbs_val.y);
    
    % Compute and test the residuals.
    figure(2); clf;
    resid(preprocessed_prbs_val, model);
    
    % Pole-zero map of system model.
    figure(3); clf;
    pzplot(model);
end

end

