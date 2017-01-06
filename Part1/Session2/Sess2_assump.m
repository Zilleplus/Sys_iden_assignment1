%--------------------------------------------------------------------------
% Marie Valenduc and Willem Melis (November 2016)
% System identification and modeling - Session 2
%--------------------------------------------------------------------------
clear all; close all;

% data
N_est = 1000;                            % size of the estimation set
N_val = 10000;                           % size of the validation set
N = N_est + N_val;
index_est = 1:N_est;
index_val = N_est+1:N;
stdev_u0 = 1;
stdev_ny = 0.5;
[b,a] = cheby1(3,0.5,[2*0.15 2*0.3]);   % transfer function G0

% generation of the data
u0 = stdev_u0*randn(N,1);               % input
ny = stdev_ny*randn(N,1);               % noise on the ouput
y0 = filter(b,a,u0);                    % noiseless on the ouput
y = y0 + ny;                            % noisy ouput

for k = 1:2
    for order = 1:800
        % building matrix K(u0)
        if (k == 1)                     % assumption: u(k)=0 for k < 0
            t = toeplitz(u0(index_est));
            K = tril(t);
        elseif (k == 2)                 % no assumption
            K = toeplitz(u0(index_est));
        end
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
        
        % computing the Akaike cost function V_AIC
        V_AIC(order) = V_LS_val(order)*(1+2*(order)/N_val);
        
        % computing the error V_0
        V_0(order) = sum((y0(index_val) - y_hat(index_val)).^2)/N_val;
    end
    
    disp(['- - - Results for sigma_ny = ',num2str(stdev_ny)]);
    [~,indexmin] = min(V_LS_est);
    disp(['The optimal order is ',num2str(indexmin)]);
    
    fig = figure(2); subplot(1,2,k)
    plot(V_LS_est./stdev_ny^2,'r','LineWidth',2); hold all;
    plot(V_LS_val./stdev_ny^2,'g','LineWidth',2); hold all;
    plot(V_AIC./stdev_ny^2,'LineWidth',2)
    set(gca, 'fontsize', 17);
    xlim([0,order]);
    ylabel('Cost'); xlabel('Order');
    legend('V_{est}','V_{val}','V_{AIC}');
end

name = './figures/Sess2_assump';
saveas(fig,name,'epsc');
