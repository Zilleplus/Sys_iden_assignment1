clear all; close all;
nsim = 500;

imp = [1; zeros(500,1)];
[output,DC] = simulate(imp,nsim);
%%
figure(1);
fft_out=abs(fft(output-DC));
stem(fft_out(1:nsim/2));% xlim([-10,10])
figure(2);
stem(output-DC);
cra([output,imp])
