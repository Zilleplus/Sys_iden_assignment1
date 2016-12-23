run('identification_init');
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
%% OPTIMAL FIT VALUE with table
nb=3;
nf=7;
show_plot=true;
[model, order, fit, aic_value, mag ] = fun_OE_model(nb,nf, ...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot )
sys = ss(model);  

[mag1,phase1,wout1] = bode(sys);
mag1=squeeze(mag1);

figureNumber=5;nameModel='OE';
fun_bode_plot( wout1,mag1,nameModel,figureNumber )

%% Balanced model reduction
close all;
nb = 40; nf = 40; nc=40; nd=40;

show_plot=false;
[model, order, fit, aic_value, mag, wout ]= fun_BJ_model(nb,nf, ...
    nc, nd, preprocessed_prbs_est, preprocessed_prbs_val, show_plot )

sys = ss(model);  
[Ab,Bb,Cb,M,T] = dbalreal(sys.a,sys.b,sys.c); 

% Hankel singular values
figure(1); clf; bar(M); title('Hankel Singular Values');
xlabel('State'); ylabel('State Energy');

% Reduced order
rorder = 14;
Ab = Ab(1:rorder,1:rorder);
Bb = Bb(1:rorder);
Cb = Cb(1:rorder);
rsys = ss(Ab,Bb,Cb,sys.D,1);

[ry,fit] = compare(preprocessed_prbs_val, idpoly(rsys))

figure(2); clf; grid on;
plot(ry.y); hold on;
plot(preprocessed_prbs_val.y);

figure(3);clf;
pzplot(rsys); hold on;
pzplot(sys); legend('reduced order system','original system');

figure(4);clf;
pzplot(rsys); hold on;

[mag2,phase2,wout2] = bode(rsys); 
mag2 = squeeze(mag2);

figureNumber=5;
fun_bode_plot(wout2,mag2,'ARX model',figureNumber);

%%
nameModel1='OE_{table}';
nameModel2='OE_{balred}';
figureNumber=6;
fun_bode_plot_dual( wout1,mag1,wout2,mag2,nameModel1, ...
    nameModel2, figureNumber )