close all; 

Fs = 1;
nfft = len;
yfft = fft(y_zero);
yfft = fftshift(yfft(1:nfft/2)/nfft);
my = angle(yfft);

f = (0:nfft/2-1)*Fs/nfft;

figure();
plot(f,my); 
%%

figure(1); clf;
subplot(211);
plot(y_zero);
subplot(212);
plot(fft(y_zero,100));