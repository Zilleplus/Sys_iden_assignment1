clear all; close all;
tic
N = 5000; % #measurements
amount_of_experiments = 1000; % #experiments

fgen = 0.1;
fnoise = [0.999, 0.95, 0.6];
stdev_i0 = 0.1;
stdev_ni = 0.1;
stdev_nu = 1;
R0 = 1000;

%%
 % format of set1,set2,set3
 % dim1= #measurements
 % dim2= #experiments
 % dim3= [i u]
[set1,correlation_ni_set1, correlation_i0_set1] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni, stdev_i0,fnoise(1));
[set2,correlation_ni_set2, correlation_i0_set2] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni,stdev_i0,fnoise(2));
[set3,correlation_ni_set3, correlation_i0_set3] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni,stdev_i0,fnoise(3));
%%
figure(1);clf;


%%
s=1;
[LS_set1, IV_set1] = Sess1_part1_calc_estimators(set1,s );
[LS_set2, IV_set2] = Sess1_part1_calc_estimators(set2,s );
[LS_set3, IV_set3] = Sess1_part1_calc_estimators(set3,s );

%%
fig=figure(2);clf;
subplot(3,1,1);
pd1 = fitdist(IV_set1,'Normal')
pd2 = fitdist(IV_set2,'Normal')
pd3 = fitdist(IV_set3,'Normal')
pd4 = fitdist(LS_set1,'Normal')

x_values = 0:1:1500;
y1 = pdf(pd1,x_values);
y2 = pdf(pd2,x_values);
y3 = pdf(pd3,x_values);
y4 = pdf(pd4,x_values);
plot(x_values,y1, ...
    x_values,y2, ...
    x_values,y3, ...
    x_values,y4, 'LineWidth',2)

legend('IV(1)','IV(2)','IV(3)','LS(1');
ylabel('PDF(R)')
toc

subplot(3,3,4);
plot(correlation_ni_set1(12:end),'b-x'); hold all;
plot(correlation_i0_set1(12:end),'r-o'); hold all;
legend('R_{i_0}','R_{n_i}');
subplot(3,3,5);
plot(correlation_ni_set2(12:end),'b-x'); hold all;
plot(correlation_i0_set2(12:end),'r-o'); hold all;
legend('R_{i_0}','R_{n_i}');
subplot(3,3,6);
plot(correlation_ni_set3(12:end),'b-x'); hold all;
plot(correlation_i0_set3(12:end),'r-o'); hold all;
legend('R_{i_0}','R_{n_i}');