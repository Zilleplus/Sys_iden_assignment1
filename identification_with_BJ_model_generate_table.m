run('identification_init');
%% Generate table with different fit values

nb = 1:2:9;
nf = 1:2:9;
nc=1;
nd=3;
nk=0; % delay allready removed from the data

show_plot=false;

% prealloc:
fit = zeros(numel(nb),numel(nf));
aic_value = zeros(numel(nb),numel(nf));

for index_nb = 1:numel(nb)
    disp(nb(index_nb));
    for index_nf = 1:numel(nf)
        [~, ~ ,fit(index_nb,index_nf) , aic_value(index_nb,index_nf) , ~] ...
            = fun_BJ_model(nb(index_nb), ...
              nf(index_nf) , ...
              nc, nd, ...
              preprocessed_prbs_est, ...
              preprocessed_prbs_val, show_plot );
    end
end

rowLabels = {'nb=1', 'nb=3' , 'nb=5' , 'nb=7' , 'nb=9'};
columnLabels = {'nf=1', 'nf=3' , 'nf=5', 'nf=7' , 'nf=9'};

matrix2latex(fit, './tables/fit_BJ_table.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
        
matrix2latex(aic_value, './tables/AIC_BJ_table.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
        
%% find nc and nd
nb=17;nf=7;

nc = 1:2:16;
nd = 1:2:12;
% prealloc:
fit = zeros(numel(nc),numel(nd));
aic_value = zeros(numel(nc),numel(nd));

showplot=false;
for index_nc = 1:numel(nc)
    disp(nc(index_nc));
    for index_nd = 1:numel(nd)
        [~, ~ ,fit(index_nc,index_nd) , aic_value(index_nc,index_nd) , ~] ...
            = fun_BJ_model(nb,nf, ...
              nc(index_nc), nd(index_nd), ...
              preprocessed_prbs_est, ...
              preprocessed_prbs_val, show_plot );
    end
end

