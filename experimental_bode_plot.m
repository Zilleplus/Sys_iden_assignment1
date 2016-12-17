clear all; close all;
% doesn't work :'( :'( 

freq = logspace(1,9,100);
num_freq = length(freq);
amplitude = 3;
n = 4;
m = 1000;
L = n*m;
t1 = (0:L-1)/n/freq(1);
u_mut_sine = zeros(n*m,num_freq);
y_mut_sine = zeros(n*m,num_freq);
t_sine = 0:1/L:1-1/L;
for k = 1:num_freq
    Fs = n*freq(k);               % Sampling frequency
    T = 1/Fs;                     % Sample time
   % t_sine = (0:L-1)*T;           % Time vector
    
    u_mut_sine(:,k) = amplitude*sin(2*pi*freq(k)*t_sine);
    y_mut_sine(:,k) = simulate(u_mut_sine(:,k),10);
end

%save('more_data.mat')

%%
clear all;
load('more_data.mat');

lpFilt = designfilt('highpassfir','PassbandFrequency',0.55, ...
         'StopbandFrequency',0.5,'PassbandRipple',0.7, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
fvtool(lpFilt)


y_mut_sine_filtered = filter(lpFilt,y_mut_sine);



for loic = 1:num_freq

DC = mean(y_mut_sine_filtered(:,1));

z = fft(y_mut_sine_filtered(:,loic)-mean(y_mut_sine_filtered(:,loic)),L)/L;
lolo(loic) = max(abs(z(10:end)));
end
semilogy(freq,lolo)

% 
 faxis = linspace(-L/2,L/2,L);
% figure(1)
% subplot(211); plot(faxis,fftshift(abs(z)))
% subplot(212); plot(faxis,fftshift(angle(z)))
% figure(2)
 plot(t_sine,y_mut_sine_filtered(:,95)-mean(y_mut_sine_filtered(:,95)))
