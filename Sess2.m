clear all; close all;

for k =1:2
% data
N_est = 1000;
N_val = 10000;
index_est = 1:N_est;
index_val = N_est+1:N_est+N_val;

N = N_est + N_val;
sigma_u0 = 1;
sigma_ny = 0.5;


[b,a] = cheby1(3,0.5,[2*0.15 2*0.3]);

u0=sigma_u0*randn(N,1);
ny = sigma_ny*randn(N,1);
y0=filter(b,a,u0);
y=y0+ny;

% Building matrix K
for order = 0:100
    t = toeplitz(u0(index_est));
    K = tril(t);
    K = K(:,1:order+1);
    g = K\y(index_est);
    
    y_hat = filter(g,1,u0([index_est,index_val]));
    
    V_LS_est(order+1) = sum((y(index_est) - y_hat(1:N_est)).^2)/N_est;   
    V_LS_val(order+1) = sum((y(index_val) - y_hat(N_est+1:N_est+N_val)).^2)/N_val;
    V_AIC(order+1) = V_LS_val(order+1)*(1+2*(order+1)/N_val);
    
    V_0(order+1) = sum((y0(index_est) - y_hat(1:N_est)).^2)/N_est;   

    
end 

figure(1); subplot(2,2,k)
plot(V_LS_est./sigma_ny^2,'r','LineWidth',2); hold all;
plot(V_LS_val./sigma_ny^2,'g','LineWidth',2); hold all;
plot(V_AIC./sigma_ny^2,'LineWidth',2)
set(gca, 'fontsize', 17);
xlim([0,100]); ylim([0.7, 1.2]);
ylabel('Cost'); xlabel('Order');
legend('V_{est}','V_{val}','V_{AIC}');

figure(1); subplot(2,2,k+2)
plot(sqrt(V_0/sigma_ny^2),'LineWidth',2)
set(gca, 'fontsize', 17);
xlim([0,100]); ylim([0, 1]);
ylabel('Normalized RMS'); xlabel('Order');
legend('V_0');

end





