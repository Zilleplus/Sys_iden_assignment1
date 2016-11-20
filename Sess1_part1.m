clear all; close all;

tic
N = 5000; % #measurements
amount_of_experiments = 1000; % #experiments

%% Data for experiment 1
fgen = 0.1;
fnoise = [0.999, 0.95, 0.6];
stdev_i0 = 0.1;
stdev_ni = 0.1;
stdev_nu = 1;
R0 = 1000; % searched value

%% Generating the measurements for each experiments and each set
% format of set1,set2,set3
% dim1= #measurements
% dim2= #experiments
% dim3= [i u]
[set1,correlation_ni_set1, correlation_i0_set1] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni, stdev_i0,fnoise(1));
[set2,correlation_ni_set2, correlation_i0_set2] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni,stdev_i0,fnoise(2));
[set3,correlation_ni_set3, correlation_i0_set3] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni,stdev_i0,fnoise(3));

%% Estimators

s=1;
[LS_set1, IV_set1] = Sess1_part1_calc_estimators( set1, s );
[LS_set2, IV_set2] = Sess1_part1_calc_estimators( set2, s );
[LS_set3, IV_set3] = Sess1_part1_calc_estimators( set3, s );

%% Figures
fig=figure(2);clf;
subplot(3,1,1);
pd1 = fitdist(IV_set1,'Normal');
pd2 = fitdist(IV_set2,'Normal');
pd3 = fitdist(IV_set3,'Normal');
pd4 = fitdist(LS_set1,'Normal');

x_values = 0:1:1500;
y1 = pdf(pd1,x_values);
y2 = pdf(pd2,x_values);
y3 = pdf(pd3,x_values);
y4 = pdf(pd4,x_values);
plot(x_values,y1, ...
    x_values,y2, ...
    x_values,y3, ...
    x_values,y4, 'LineWidth',2)
set(gca, 'fontsize', 17);
legend('IV(1)','IV(2)','IV(3)','LS(1)');
ylim([0,0.1]); ylabel('PDF(R)');

% Autocorrelation function of i0 and ni
subplot(3,3,4);
plot(0:10, correlation_ni_set1(12:end-1),'b-x'); hold all;
plot(0:10, correlation_i0_set1(12:end-1),'r-o'); hold all;
set(gca, 'fontsize', 17);
xlabel('Lag'); ylabel('Auto-correlation')
legend('R_{i0,i0}','R_{ni,ni}');
subplot(3,3,5);
plot(0:10, correlation_ni_set2(12:end-1),'b-x'); hold all;
plot(0:10, correlation_i0_set2(12:end-1),'r-o'); hold all;
set(gca, 'fontsize', 17);
xlabel('Lag'); ylabel('Auto-correlation')
subplot(3,3,6);
plot(0:10, correlation_ni_set3(12:end-1),'b-x'); hold all;
plot(0:10, correlation_i0_set3(12:end-1),'r-o'); hold all;
set(gca, 'fontsize', 17);
xlabel('Lag'); ylabel('Auto-correlation')

% Frequency response functions (FRF)
num = 20; % number of points at which we calculate the frequency response 
[bgen,agen] = butter(1,fgen);
[h1,w1]=freqz(bgen,agen,num);

for k=1:3
    [bnoise,anoise] = butter(2,fnoise(k));
    [h,w]=freqz(bnoise,anoise,num); % h (complex frequency response)
                                    % w (frequency points [rad/s])
                                    
    subplot(3,3,6+k)
    plot(w/(2*pi),10*log(abs(h)),'r', 'LineWidth',2); hold on; 
    plot(w1/(2*pi),10*log(abs(h1)),'b', 'LineWidth',2);
    set(gca, 'fontsize', 17);
    xlim([0,0.5]); xlabel('f/fs'); % fs = sampling frequency
    ylim([-30,10]); ylabel('Filter [dB]'); 
    legend('n_i filter', 'i_0 filter')
    hold off;
end


toc