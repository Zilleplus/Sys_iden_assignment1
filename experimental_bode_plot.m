% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% E x p e r i m e n t a l   B o d e   P l o t  . . .
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;

freq = 1:500;
amplitude = 2.5;

n = 4;
m = 50; % more?
L = n*m;
%t1 = (0:L-1)/n/freq(1);

u_mut_sine = zeros(L,numel(freq));
y_mut_sine = zeros(L,numel(freq));
t_sine = 0:1/L:1-1/L;

for k = 1:numel(freq)
    Fs = n*freq(k);               % Sampling frequency
    T = 1/Fs;                     % Sample time
   % t_sine = (0:L-1)*T;          % Time vector
    
   u_mut_sine(:,k) = amplitude*sin(2*pi*freq(k)*t_sine);
   y_mut_sine(:,k) = simulate(u_mut_sine(:,k),10);
end

save('bodedata.mat')
%%
load('simulation_data_3.mat');
load('bodedata.mat');
delay = 15;

for k = 1:numel(freq)
    preprocessed_data = preprocessing(iddata( y_mut_sine(:,k), ...
        u_mut_sine(:,k), 1 ),[], delay, 20, 0 );
    %plot(y_mut_sine(:,k)-DC); hold on;
    %plot(preprocessed_data.y,'r')
    z(:,k) = fft(preprocessed_data.y)/L;
    ampl(k) = max(abs(z(:,k)));
end

figure(1); clf;
semilogy(freq,ampl,'.-')




% for m = 1:numel(freq)
%     % DC = mean(y_mut_sine_filtered(:,1));
%     %z = fft(y_mut_sine_filtered(:,m)-mean(y_mut_sine_filtered(:,m)),L)/L;
%     z = fft(y_mut_sine_filtered(:,m))/L;
%     
%     ampl(m) = max(abs(z));
% end
% figure(1); clf;
% semilogy(freq,ampl,'.-')

% 
% faxis = linspace(-L/2,L/2,L);
% figure(1)
% subplot(211); plot(faxis,fftshift(abs(z)))
% subplot(212); plot(faxis,fftshift(angle(z)))
% figure(2)
% plot(t_sine,y_mut_sine_filtered(:,95)-mean(y_mut_sine_filtered(:,95)))
