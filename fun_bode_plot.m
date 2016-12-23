function  fun_bode_plot( wout,mag,nameModel,figureNumber )
    load('simulation_data_3.mat');
    load('bodedata.mat');
    delay = 15;
    
    for k = 1:numel(freq)
        preprocessed_data = preprocessing(iddata( y_mut_sine(:,k), ...
            u_mut_sine(:,k), 1 ),[], delay, 20, 0 );

        z(:,k) = fft(preprocessed_data.y)/len_test;
        ampl(k) = max(abs(z(:,k)));
    end
    
    figure(figureNumber);clf;
    plot(wout,log10(mag)*20,'LineWidth',1.5); hold on;
    plot( 2*pi*freq/len_test, 20*log10(smooth(ampl)),'.-' ,'LineWidth',1.5 ...
    , 'MarkerSize',12); grid on;
    title('Experimental Bode estimate');
    xlabel('normalized frequency f/fs'); ylabel('Magnitude (dB)'); 
    xlim([2*pi*freq(1)/len_test, 2*pi*freq(end)/len_test]);
    legend(nameModel,'real system')

end

