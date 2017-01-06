function [model, fit, aic_value ] = fun_armax_model(na, nb, nc,...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot)
% For a system represented by:
% y(t)=[ B(q)/A(q) ]* u(t) + [ C(q)/A(q) ]*e(t)
% where y(t) is the output, u(t) is the input and e(t) is the disturbance.
% na = order of A polynomial     (Ny-by-Ny matrix)
% order of B polynomial + 1      (Ny-by-Nu matrix)
% nc = order of C polynomial     (Ny-by-1 matrix)

% Estimate an ARMAX model of selected order.
nk = 0;
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
end

end

