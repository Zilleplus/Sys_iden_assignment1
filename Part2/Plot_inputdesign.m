close all; clear all;
load('simulation_data_3.mat');

DC = mean(y_zero);

%% Applying a zero-sequence to the system - time domain
figure(1); clf;
subplot(211); plot(u_zero(1:1000),'LineWidth',2); 
set(gca, 'fontsize', 12); grid on;
xlabel('Time'); title('Input u : zero sequence');
subplot(212); plot(y_zero(1:1000)); 
set(gca, 'fontsize', 12); grid on;
xlabel('Time'); title('Output y');

%% Applying a zero-sequence to the system - frequency domain
delay = 15;
y_zero_filtered = y_zero(1:1000) - DC;

nfft = size(y_zero_filtered,1);
Fs = 1;                         % sampling frenquency
yfft = fft(y_zero_filtered);    % discrete Fourier transform
yfft = yfft(1:nfft/2)/nfft;     % single-sided spectrum

f = (0:nfft/2-1)*Fs/nfft;

figure(2); clf;
subplot(2,1,1); plot(2*pi*f,abs(yfft)); 
set(gca, 'fontsize', 12); grid on;
xlabel('normalized frequency [rad/s]'); ylabel('|Y(jw)|'); 
xlim([2*pi*f(1),2*pi*f(end)]);
subplot(2,1,2); plot(2*pi*f,angle(yfft)); 
set(gca, 'fontsize', 12); grid on;
xlabel('normalized frequency [rad/s]'); ylabel('arg{Y(jw)} '); 
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
figure(5); clf; Nu = 100;
subplot(211); stem(u_white_noise(1:Nu)); 
set(gca, 'fontsize', 11); grid on;
xlabel('Time'); title('Input u : white noise');
subplot(212); stem(y_white_noise(1:Nu) - DC);
set(gca, 'fontsize', 11); grid on;
xlabel('Time'); title('Output y');

%%  Applying a PRBS - time domain
figure(6); clf; Nu = 100;
subplot(211); stem(u_prbs(1:Nu)); 
set(gca, 'fontsize', 11); grid on;
xlabel('Time'); title('Input u : PRBS');
subplot(212); stem(y_prbs_est(1:Nu) - DC); 
set(gca, 'fontsize', 11); grid on;
xlabel('Time'); title('Output y');

%%  Applying a sine wave - time domain
figure(7); clf;
subplot(211); stem(u_sin,'LineWidth',2); 
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Input u : sine wave');
subplot(212); stem(y_sin - DC,'LineWidth',2);
set(gca, 'fontsize', 15); grid on;
xlabel('Time'); title('Output y');





