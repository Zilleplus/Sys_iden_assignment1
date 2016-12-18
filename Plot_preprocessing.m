close all;
load('simulation_data_2.mat');
delay = 15;
cutoff = 0.1;

preprocessed_y_sin = preprocessing( y_prbs(1:300), [], delay, cutoff, 15 , 1 );

% figure(5);
% [bf,af] = butter(4, cutoff);
% bode(tf(bf,af));


