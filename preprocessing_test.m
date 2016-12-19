% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Preprocessing
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
close all;
delay = 15;
preprocessed_data = preprocessing(iddata( y_prbs_est, u_prbs(1:1000), 1 )...
    ,[], delay, 10, 2 )
