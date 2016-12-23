run('identification_init');
%%
disp('Testing ARMAX model ...');
na = 8:1:15; nb = 13:1:16; nc = 10;

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

columnLabels = {'$n_a = 8$','$n_a = 9$','$n_a = 10$', '$n_a = 11$', ...
    '$n_a = 12$','$n_a = 13$','$n_a = 14$','$n_a = 15$'};
rowLabels = {'$n_b = 13$','$n_b = 14$','$n_b = 15$','$n_b = 16$'};

matrix2latex(aic_value', './tables/armaxnc10.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
 