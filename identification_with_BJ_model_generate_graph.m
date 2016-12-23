        %% Generate table with different fit values
max_range=9;
nb = 1:2:max_range;%21
nf = 1:2:max_range;%17
nc = 1:2:max_range;%12
nd = 1:2:max_range;%12
nk=0; % delay allready removed from the data

show_plot=false;

% prealloc:
fit = zeros(numel(nb),numel(nf),numel(nc),numel(nd));
aic_value = zeros(numel(nb),numel(nf));

for index_nb = 1:numel(nb)
    disp(nb(index_nb));
    for index_nf = 1:numel(nf)
        for index_nc = 1:numel(nc)
            for index_nd = 1:numel(nd)
                [~, ~ ,fit(index_nb,index_nf,index_nc,index_nd) , ...
                    aic_value(index_nb,index_nf,index_nc,index_nd) , ~] ...
                    = fun_BJ_model(nb(index_nb), ...
                      nf(index_nf) , ...
                      nc(index_nc), nd(index_nd), ...
                      preprocessed_prbs_est, ...
                      preprocessed_prbs_val, show_plot );
            end
        end
    end
end
%%
% calculating graph
r_aic_value=zeros(size(aic_value,1),1);
r_fit=zeros(size(aic_value,1),1);
for radius=1:size(aic_value,1)
    r_aic_value(radius) = max(max(max(max(aic_value(1:radius,1:radius,1:radius,1:radius)))));
    r_fit(radius) = max(max(max(max(fit(1:radius,1:radius,1:radius,1:radius)))));
end
%%
figure(1);clf;
subplot(1,2,1);
plot(nb,r_fit);
title('fit');
subplot(1,2,2);
plot(nb,r_aic_value);
title('AIC');