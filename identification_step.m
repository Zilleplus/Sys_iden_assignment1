run('identification_init');
%% ARX model
close all;
disp('Testing ARX model ...');
na = 3:3:24; nb = 3:3:24;

fit = zeros(numel(na),numel(nb)); % preallocation
aic_value = zeros(numel(na),numel(nb));

showFigures=false;
for i = 1:numel(na)
    for j = 1:numel(nb)
        [~, ~, fit(i,j), aic_value(i,j) ]= fun_arx_model( na(i),nb(j), ...
            preprocessed_prbs_est, preprocessed_prbs_val,showFigures );
    end
end

%% Balanced model reduction
close all;
na = 24; nb = 24;

[model, order, fit, aic_value, mag, wout ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,false );

sys = ss(model);  
[Ab,Bb,Cb,M,T] = dbalreal(sys.a,sys.b,sys.c); 

% Hankel singular values
figure(1); clf; bar(M); title('Hankel Singular Values');
xlabel('State'); ylabel('State Energy');

% Reduced order
rorder = 10;
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

[mag,phase,wout] = bode(rsys); 
mag = squeeze(mag);


%% ARMAX model
% For a system represented by:
% y(t)=[ B(q)/A(q) ]* u(t) + [ C(q)/A(q) ]*e(t)
% where y(t) is the output, u(t) is the input and e(t) is the disturbance.
% na = order of A polynomial     (Ny-by-Ny matrix)
% order of B polynomial + 1 (Ny-by-Nu matrix)

disp('Testing ARMAX model ...');
na = 7:2:15; nb = 13:2:20; nc = 10;

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
disp('Here is your fit ...');

fit
%%
rowLabels = {'7', '9' , '11', '13', '15'};
columnLabels = {'13', '15' , '17'};

matrix2latex(fit, './armaxnc10.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');

%% OE model
% For a system represented by:
% y(t)=[ B(q)/F(q) ]* u(t?nk)+e(t)
% where y(t) is the output, u(t) is the input and e(t) is the error.
% nb � Order of the B polynomial + 1. nb is an Ny-by-Nu matrix. 
%     Ny is the number of outputs and Nu is the number of inputs.
% nf � Order of the F polynomial. nf is an Ny-by-Nu matrix. 
%     Ny is the number of outputs and Nu is the number of inputs.
% nk � Input delay, expressed as the number of samples. 
%     nk is an Ny-by-Nu matrix. 
%     Ny is the number of outputs and Nu is the number of inputs.
%     The delay appears as leading zeros of the B polynomial.

nb=4;
nf=5;
show_plot=true;
[model, order, fit, aic_value, mag, wout ] = fun_OE_model(nb,nf, ...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot )
