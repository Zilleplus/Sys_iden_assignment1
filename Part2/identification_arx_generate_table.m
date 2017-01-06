run('identification_init');
%% Generate table ARX model, this takes a while
% The table is stored in ./tables/
close all;
disp('Testing ARX model ...');
na = 3:3:24; nb = 15:3:24;

% % Generate model-order combinations for estimation
search_region = struc([na-2:na+2],[nb-2:nb+2],0);

% Estimate ARX models and compute the loss function for each model order
% combination
V = arxstruc(preprocessed_prbs_est, preprocessed_prbs_val, ...
     search_region)
 
selstruc(V)

fit = zeros(numel(na),numel(nb)); % preallocation
aic_value = zeros(numel(na),numel(nb));

showFigures=false;
for i = 1:numel(na)
    for j = 1:numel(nb)
        [~, fit(i,j), aic_value(i,j),~,~ ]= fun_arx_model( na(i),nb(j), ...
            preprocessed_prbs_est, preprocessed_prbs_val,showFigures );
    end
end

columnLabels = {'$n_a = 3$','$n_a = 6$','$n_a = 9$', ...
    '$n_a = 12$','$n_a = 15$','$n_a = 18$','$n_a = 21$', '$n_a = 24$'};
rowLabels = {'$n_b = 15$','$n_b = 18$','$n_b = 21$', '$n_b = 24$'};

matrix2latex(fit', './tables/arx_aic.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');

matrix2latex(aic_value', './tables/arx_fit.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');