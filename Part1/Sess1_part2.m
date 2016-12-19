clear all; close all;

tic

% experiment settings
N = 5000; % #measurements
amount_of_experiments = 1000; % #experiments

% parameter settings
stdev_i0 = 0.01;
stdev_ni = 0.001;
stdev_nu = 1;
R0 = 1000; 

%%
[ set ] = Sess1_part2_generate_data( N, amount_of_experiments, ...
    R0, stdev_nu, stdev_ni, stdev_i0 );
%%
[ LS , EIV IV ] = Sess1_part2_calc_estimators( set,stdev_ni,stdev_nu );

%%

fig=figure(1);clf;
pd_ls = fitdist(LS,'Normal');
pd_eiv = fitdist(EIV,'Normal');

x_values = 950:1:1050;
y_ls = pdf(pd_ls,x_values);
y_eiv = pdf(pd_eiv,x_values);
name = './figures/Sess1_part2';
saveas(fig,name,'epsc');

plot(x_values,y_ls ...
    ,x_values,y_eiv ...
    ,'LineWidth',2);
xlabel('R'); ylabel('PDF(R)')
legend('LS','EIV');

fig=figure(2);clf;
x_values = 0:10:2000;
pd_iv = fitdist(IV','Normal');
y_iv = pdf(pd_iv,x_values);

plot(x_values, y_iv,'LineWidth',2);
xlabel('R'); ylabel('PDF(R)')
title('IV estimator for s = 1')

name = './figures/Sess1_part2_ivest';
saveas(fig,name,'epsc');