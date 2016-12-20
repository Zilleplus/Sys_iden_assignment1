% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Identification part ;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;
load('simulation_data_3.mat')

% Data
delay = 15;
preprocessed_prbs_est = preprocessing( iddata(y_prbs_est,...
    u_prbs(1:N_est),1),[], delay, 20, 0); % estimation data set
preprocessed_prbs_val = preprocessing( iddata(y_prbs_val,...
    u_prbs(N_est+1:N),1),[], delay, 20, 0); % validation data set

%% Balanced model reduction
na = 20; nb = 20;
[model, order, fit1, aic_value, mag, wout ]= fun_arx_model(na,nb, ...
    preprocessed_prbs_est, preprocessed_prbs_val,false );

sys = ss(model);  
[Ab,Bb,Cb,M,T] = dbalreal(sys.a,sys.b,sys.c); 

% Hankel singular values
figure(1); bar(M);

%% reduced order
rorder = length(Bb);
Ab = Ab(1:rorder,1:rorder);
Bb = Bb(1:rorder);
Cb = Cb(1:rorder);
rsys2 = ss(Ab,Bb,Cb,sys.D,1);

[y_model,fit] = compare(preprocessed_prbs_val, rsys2)

figure(4); clf; plot(y_model.y); hold on;
plot(preprocessed_prbs_val.y);

figure(2);
bode(sys,'b',rsys2,'r--')

figure(3);
pzplot(rsys2)

%%

[mag,phase,wout] = bode(model)
mag = squeeze(mag);



%% ARX model
na = 9:2:20; 
nb = 9:2:20;
fit = zeros(numel(na),numel(nb));
aic_value = zeros(numel(na),numel(nb));

for i = 1:numel(na)
    for j = 1:numel(nb)
        [~, ~, fit(i,j), aic_value(i,j) ]= fun_arx_model(na(i),nb(j), ...
            preprocessed_prbs_est, preprocessed_prbs_val,false );
    end
end


%% ARMAX model
na = 9:2:20;
nb = 9:2:20;
nc = 4;
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
