%% OE model
% For a system represented by:
% y(t)=[ B(q)/F(q) ]* u(t?nk)+e(t)
% where y(t) is the output, u(t) is the input and e(t) is the error.
% nb — Order of the B polynomial + 1. nb is an Ny-by-Nu matrix. 
%     Ny is the number of outputs and Nu is the number of inputs.
% nf — Order of the F polynomial. nf is an Ny-by-Nu matrix. 
%     Ny is the number of outputs and Nu is the number of inputs.
% nk — Input delay, expressed as the number of samples. 
%     nk is an Ny-by-Nu matrix. 
%     Ny is the number of outputs and Nu is the number of inputs.
%     The delay appears as leading zeros of the B polynomial.
%%
nb=4;
nf=5;
show_plot=true;
[model, order, fit, aic_value, mag ] = fun_OE_model(nb,nf, ...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot )
%% Generate table with different fit values

nb = 1:2:6;
nf = 1:2:6;
nk=0; % delay allready removed from the data

show_plot=false;

% prealloc:
fit = zeros(numel(nb),numel(nf));
aic_value = zeros(numel(nb),numel(nf));

for index_nb = 1:numel(nb)
    disp(nb(index_nb));
    for index_nf = 1:numel(nf)
        [~, ~ ,fit(index_nb,index_nf) , aic_value(index_nb,index_nf) , ~] ...
            = fun_OE_model(nb(index_nb), ...
              nf(index_nf) , ...
              preprocessed_prbs_est, ...
              preprocessed_prbs_val, show_plot );
    end
end

%%
rowLabels = {'1', '3' , '5'};
columnLabels = {'1', '3' , '5'};

matrix2latex(fit, './tables/fit_OE_table.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
        
        