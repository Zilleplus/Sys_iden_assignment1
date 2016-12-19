%% Applying a zero-sequence to the system (trying to calculate the PSD)
% to be tried ...
clear all;

n_fft = 2000; n_vec = 1;
for k = 1:n_vec
    nt(k,:) = exercise2(zeros(n_fft,1));
end
ntf = 1/sqrt(n_fft)*fft(nt,[],2);
ntf_pwr     = ntf.*conj(ntf);
ntf_pwr_avg = mean(ntf_pwr);

%%
figure(4); clf;
load('psd.mat');
plot([-n_fft/2:n_fft/2-1]/n_fft,10*log10(fftshift(ntf_pwr_avg)));
axis([-0.5 0.5 -5 5]); grid on;
ylabel('power spectral density, dB/Hz');
xlabel('normalized frequency');
title('power spectral density of white noise');