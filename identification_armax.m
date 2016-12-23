run('identification_init');
%% ARMAX model
% For a system represented by:
% y(t)=[ B(q)/A(q) ]* u(t) + [ C(q)/A(q) ]*e(t)
% where y(t) is the output, u(t) is the input and e(t) is the disturbance.
% na = order of A polynomial     (Ny-by-Ny matrix)
% order of B polynomial + 1 (Ny-by-Nu matrix)

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

matrix2latex(aic_value', './armaxnc10.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
 
%% Balanced model reduction
close all;
na = 20; nb = 20; nc = 20;

[model, fit_1, aic_value ] = fun_armax_model(na, nb, nc,...
    preprocessed_prbs_est, preprocessed_prbs_val, false)

sys = ss(model);  
[Ab,Bb,Cb,M,T] = dbalreal(sys.a,sys.b,sys.c); 

% Hankel singular values
figure(1); clf; bar(M); title('Hankel Singular Values');
xlabel('State'); ylabel('State Energy');

% Reduced order
rorder = 12;
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

figure(4); clf;
resid(preprocessed_prbs_val, rsys);

%%
na = 12; nb = 15; nc = 10;

[model, fit_1, aic_value ] = fun_armax_model(na, nb, nc,...
    preprocessed_prbs_est, preprocessed_prbs_val, false)

[mag,phase,wout] = bode(model); 
mag = squeeze(mag);