close all; clear all;
load('simulation_data_3.mat');

DC = mean(y_zero);
% Sampling frequency = 10
t_500 = 0:0.1:49.9;
t_1000 = 0:0.1:99.9;
t_2000 = 0:0.1:199.9;

%% Applying a zero-sequence to the system - time domain
figure(1); clf;
subplot(211); plot(u_zero,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Input u : zero sequence');
subplot(212); plot(y_zero,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Output y');

%% Applying a zero-sequence to the system - frequency domain
nfft = size(y_zero,1);
Fs = 1;                         % sampling frenquency
yfft = fft(y_zero-DC);          % discrete Fourier transform
yfft = yfft(1:nfft/2)/nfft;     % single-sided spectrum

f = (0:nfft/2-1)*Fs/nfft;

figure(2); clf;
subplot(2,1,1); plot(2*pi*f,abs(yfft),'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('normalized frequency [rad/s]'); ylabel('|Y(jw)|'); 
xlim([2*pi*f(1),2*pi*f(end)]);
subplot(2,1,2); plot(2*pi*f,angle(yfft),'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('normalized frequency [rad/s]'); ylabel('arg{Y(jw)}'); 
xlim([2*pi*f(1),2*pi*f(end)]);

%%  Applying an impulse - time domain
figure(3); clf;
subplot(211); stem(0:24, u_impulse_response(1:25),'LineWidth',2); grid on;
xlabel('Time'); title('Input u : impulse in k = 0');
subplot(212); stem(0:24, y_impulse_response(1:25) - DC,'LineWidth',2); 
grid on;
xlabel('Time'); title('Output y');

%%  Applying a step - time domain
figure(4); clf;
subplot(211); stem(0:24, u_step(1:25),'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Input u : step');
subplot(212); stem(0:24,y_step(1:25) - DC,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Output y');


%%  Applying a white noise - time domain
figure(5); clf;
subplot(211); plot(u_white_noise,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Input u : white noise');
subplot(212); plot(y_white_noise - DC,'LineWidth',2);
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Output y');

%%  Applying a PRBS - time domain
figure(6); clf;
subplot(211); plot(u_prbs,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Input u : PRBS');
subplot(212); plot(y_prbs - DC,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Output y');

%%  Applying a sine wave - time domain
figure(6); clf;
subplot(211); plot(u_sin,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Input u : sine wave');
subplot(212); plot(y_sin - DC,'LineWidth',2);
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Output y');





