run('identification_init');
%% ARMAX model
% For a system represented by:
% y(t)=[ B(q)/A(q) ]* u(t) + [ C(q)/A(q) ]*e(t)
% where y(t) is the output, u(t) is the input and e(t) is the disturbance.
% na = order of A polynomial     (Ny-by-Ny matrix)
% order of B polynomial + 1 (Ny-by-Nu matrix)

% Identification using the na,nb from the generated table
na = 12; nb = 15; nc = 10;

[model, fit_1, aic_value ] = fun_armax_model(na, nb, nc,...
    preprocessed_prbs_est, preprocessed_prbs_val, true)

[mag1,phase1,wout1] = bode(model); 
mag1 = squeeze(mag1);

figureNumber=5;nameModel='ARMAX';
fun_bode_plot( wout1,mag1,nameModel,figureNumber )
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

% plot out the mag with real model
[mag2,phase2,wout2] = bode(rsys); 
mag2 = squeeze(mag2);

figureNumber=5;
fun_bode_plot(wout2,mag2,'ARX model',figureNumber);

%% compare the 2 methods

nameModel1='ARMAX_{table}';
nameModel2='ARMAX_{balred}';
figureNumber=6;
fun_bode_plot_dual( wout1,mag1,wout2,mag2,nameModel1, ...
    nameModel2, figureNumber )


