clear all; close all;

tic
N = 5000; % #measurements
amount_of_experiments = 1000; % #experiments

%% Data
stdev_i0 = 0.01;
stdev_ni = 0.001;
stdev_nu = 1;
R0 = 1000; % searched value

[ set ] = Sess1_part2_generate_data( N, amount_of_experiments, ...
    R0, stdev_nu, stdev_ni, stdev_i0 );