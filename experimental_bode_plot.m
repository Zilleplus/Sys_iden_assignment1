% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Experimental Bode Plot
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all; close all;

disp('Simulation data for experimental Bode plot ...');

freq = (1:100);
amplitude = 2.5;
len_test = 200;

u_mut_sine = zeros(len_test,numel(freq));
y_mut_sine = zeros(len_test,numel(freq));
t_sine = 0:1/len_test:1-1/len_test;

for k = 1:numel(freq)   
   u_mut_sine(:,k) = amplitude*sin(2*pi*freq(k)*t_sine);
   y_mut_sine(:,k) = simulate(u_mut_sine(:,k),50);
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
    z(:,k) = fft(preprocessed_data.y)/len_test;
    ampl(k) = max(abs(z(:,k)));
end

%%
figure; clf;
plot(linspace(0,pi,numel(mag)),log10(mag)*20); hold on;
plot( 2*pi*freq/len_test, 20*log10(ampl),'.-' ); grid on;
title('Experimental Bode plot');
xlabel('normalized frequency f/f_s'); 
%xlim([2*pi*freq(1)/len_test, 2*pi*freq(end)/len_test]);






