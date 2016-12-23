run('identification_init');
%% ARX model
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
        [~, ~, fit(i,j), aic_value(i,j) ]= fun_arx_model( na(i),nb(j), ...
            preprocessed_prbs_est, preprocessed_prbs_val,showFigures );
    end
end

columnLabels = {'$n_a = 3$','$n_a = 6$','$n_a = 9$', ...
    '$n_a = 12$','$n_a = 15$','$n_a = 18$','$n_a = 21$', '$n_a = 24$'};
rowLabels = {'$n_b = 15$','$n_b = 18$','$n_b = 21$', '$n_b = 24$'};

matrix2latex(aic_value', './arx.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');

%% Balanced model reduction
close all;
na = 20; nb = 20;

[model, order, fit, aic_value, mag, wout ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,false );

sys = ss(model);  
[Ab,Bb,Cb,M,T] = dbalreal(sys.a,sys.b,sys.c); 

% Hankel singular values
figure(1); clf; bar(M); title('Hankel Singular Values');
xlabel('State'); ylabel('State Energy');

% Reduced order
rorder = 13;
Ab = Ab(1:rorder,1:rorder);
Bb = Bb(1:rorder);
Cb = Cb(1:rorder);
rsys = ss(Ab,Bb,Cb,sys.D,1);

[ry,fit] = compare(preprocessed_prbs_val, idpoly(rsys))

figure(2); clf; grid on;
plot(ry.y); hold on;
plot(preprocessed_prbs_val.y);

figure(3);
pzplot(rsys); hold on;
pzplot(sys); legend('reduced order system','original system');

[mag1,phase,wout1] = bode(rsys); 
mag1 = squeeze(mag1);