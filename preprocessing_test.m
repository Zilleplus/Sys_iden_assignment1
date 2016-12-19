% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Preprocessing
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
delay = 15;
preprocessed_data = preprocessing(iddata( y_prbs(1:500), u_prbs(1:500), 1 )...
    ,[], delay, 10, 1 )
