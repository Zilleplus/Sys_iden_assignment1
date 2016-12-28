run('identification_init');
%% optimal value selected from table
close all;
na = 15; nb = 24;

[model, fit, aic_value, mag1, wout1 ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,true );

figureNumber=5;
fun_bode_plot(wout1,mag1,'ARX model',figureNumber);
%% Balanced model reduction
close all;
na = 20; nb = 20;

[model, fit, aic_value, mag, wout ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,true );


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

[ry,fitreduced] = compare(preprocessed_prbs_val, idpoly(rsys))

figure(2); clf; grid on;
plot(ry.y); hold on;
plot(preprocessed_prbs_val.y);

figure(3);
pzplot(rsys); hold on;
pzplot(sys); legend('reduced order system','original system');

[mag2,phase2,wout2] = bode(rsys); 
mag2 = squeeze(mag2);

figureNumber=5;
fun_bode_plot(wout2,mag2,'ARX model',figureNumber);

%%
nameModel1='ARX_{table}';
nameModel2='ARX_{balred}';
fun_bode_plot_dual( wout1,mag1,wout2,mag2,nameModel1, ...
    nameModel2, figureNumber )