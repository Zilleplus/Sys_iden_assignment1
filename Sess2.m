%--------------------------------------------------------------------------
% Marie Valenduc and Willem Melis (November 2016) 
% System identification and modeling - Session 2
%--------------------------------------------------------------------------
clear all; close all;

% data
N_est = 1000;                               % size of the estimation set
N_val = 10000;                              % size of the validation set
N = N_est + N_val; 
index_est = 1:N_est;
index_val = N_est+1:N;
% random_indices = randperm(N);
% index_est = random_indices(1:N_est);
% index_val = random_indices(N_est+1:N);

stdev_u0 = 1;
stdev_ny = 0.5;

[b,a] = cheby1(3,0.5,[2*0.15 2*0.3]);      % transfer function G0

for k =1:2:3
    % generation of the data
    % [B,A] = cheby1(N,R,Wp) designs an Nth order lowpass digital Chebyshev
    % filter with R decibels of peak-to-peak ripple in the passband. cheby1
    % returns the filter coefficients in length N+1 vectors B (numerator) and
    % A (denominator). The passband-edge frequency Wp.
    [b,a] = cheby1(3,0.5,[2*0.15 2*0.3]);   % transfer function G0

    u0 = stdev_u0*randn(N,1);               % input
    ny = stdev_ny*randn(N,1);               % noise on the ouput
    y0 = filter(b,a,u0);                    % noiseless on the ouput
    y = y0 + ny;                            % noisy ouput
    
    for order = 1:100
        % building matrix K(u0)
        t = toeplitz(u0(index_est));
        K = tril(t);
        K = K(:,1:order);
        
        % solving the system
        g = K\y(index_est);
        
        % output of the FIR system
        y_hat = filter(g,1,u0);

        % computing the least squares cost functions V_LS
        % based on the estimation set
        V_LS_est(order) = sum((y(index_est) - y_hat(1:N_est)).^2)/N_est; 
        % based on the validation set
        V_LS_val(order) = sum((y(index_val) - y_hat(N_est+1:N_est+N_val)).^2)/N_val;
        
        % computing the Akaike cost function V_AIC (based on the estimation
        % set !)
        V_AIC(order) = V_LS_est(order)*(1+2*(order+1)/N_est);
        
        % computing the error V_0
        V_0(order) = sum((y0(index_val) - y_hat(index_val)).^2)/N_val;       
    end
    
    disp(['- - - Results for sigma_ny = ',num2str(stdev_ny)]);
    [~,indexmin] = min(V_AIC);
    disp(['The optimal order given by the AIC is ',num2str(indexmin)]);
    
    [~,indexmin] = min(V_LS_val);
    disp(['The optimal order given by the validation set is ',num2str(indexmin)]);
    
    figure(1); subplot(2,2,k)
    plot(V_LS_est./stdev_ny^2,'r','LineWidth',2); hold all;
    plot(V_LS_val./stdev_ny^2,'g','LineWidth',2); hold all;
    plot(V_AIC./stdev_ny^2,'LineWidth',2)
    set(gca, 'fontsize', 17);
    xlim([0,100]); ylim([0.7, 1.2]);
    ylabel('Cost'); xlabel('Order');
    legend('V_{est}','V_{val}','V_{AIC}');
    if(k==1) title('Noisy data; \sigma_{ny} = 0.5'); 
    elseif(k==3) title('Noisy data; \sigma_{ny} = 0.05'); 
    end
    
    figure(1); subplot(2,2,k+1)
    plot(sqrt(V_0/stdev_ny^2),'LineWidth',2)
    set(gca, 'fontsize', 17);
    xlim([0,100]); ylim([0, 1]);
    ylabel('Normalized RMS'); xlabel('Order');
    legend('V_0');
    if(k==1) title('Noiseless data; \sigma_{ny} = 0.5'); 
    elseif(k==3) title('Noiseless data; \sigma_{ny} = 0.05'); 
    end
    
    stdev_ny = 0.05;                        % for second experiment
end

figure(2); bode(tf(b,a));






