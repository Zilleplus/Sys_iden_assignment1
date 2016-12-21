%% BJ model
% For a system represented by:
% y(t)=[ B(q)/F(q) ]* u(t-nk)+[ C(z)/D(z) ]e(t)
% where y(t) is the output, u(t) is the input and e(t) is the error.

%% OPTIMAL VAL VALUE
nb=17;
nf=7;

nc=11;
nd=1;
show_plot=false;
[model, order, fit, aic_value, mag ] = fun_BJ_model(nb,nf,nc,nd, ...
    preprocessed_prbs_est, preprocessed_prbs_val, show_plot );
disp(fit)

%% find nc and nd
nb=17;nf=7;

nc = 1:2:16;
nd = 1:2:12;
% prealloc:
fit = zeros(numel(nc),numel(nd));
aic_value = zeros(numel(nc),numel(nd));

showplot=false;
for index_nc = 1:numel(nc)
    disp(nc(index_nc));
    for index_nd = 1:numel(nd)
        [~, ~ ,fit(index_nc,index_nd) , aic_value(index_nc,index_nd) , ~] ...
            = fun_BJ_model(nb,nf, ...
              nc(index_nc), nd(index_nd), ...
              preprocessed_prbs_est, ...
              preprocessed_prbs_val, show_plot );
    end
end

%% Generate table with different fit values

nb = 1:2:21;
nf = 1:2:17;
nc=1;
nd=3;
nk=0; % delay allready removed from the data

show_plot=false;

% prealloc:
fit = zeros(numel(nb),numel(nf));
aic_value = zeros(numel(nb),numel(nf));

for index_nb = 1:numel(nb)
    disp(nb(index_nb));
    for index_nf = 1:numel(nf)
        [~, ~ ,fit(index_nb,index_nf) , aic_value(index_nb,index_nf) , ~] ...
            = fun_BJ_model(nb(index_nb), ...
              nf(index_nf) , ...
              nc, nd, ...
              preprocessed_prbs_est, ...
              preprocessed_prbs_val, show_plot );
    end
end
%%
rowLabels = {'nb=1', 'nb=3' , 'nb=5' , 'nb=7' , 'nb=9'};
columnLabels = {'nf=1', 'nf=3' , 'nf=5', 'nf=7' , 'nf=9'};

matrix2latex(fit, './tables/fit_BJ_table.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
matrix2latex(aic_value, './tables/AIC_BJ_table.tex', ...
            'rowLabels', rowLabels, ...
            'columnLabels', columnLabels, ...
            'alignment', 'c', ...
            'format', '%-6.2f');
        
        %% Generate table with different fit values
max_range=10;
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



%% Balanced model reduction
close all;
nb = 40; nf = 40; nc=40; nd=40;

show_plot=false;
[model, order, fit, aic_value, mag, wout ]= fun_BJ_model(nb,nf, ...
    nc, nd, preprocessed_prbs_est, preprocessed_prbs_val, show_plot )

sys = ss(model);  
[Ab,Bb,Cb,M,T] = dbalreal(sys.a,sys.b,sys.c); 

% Hankel singular values
figure(1); clf; bar(M); title('Hankel Singular Values');
xlabel('State'); ylabel('State Energy');

% Reduced order
rorder = 15;
Ab = Ab(1:rorder,1:rorder);
Bb = Bb(1:rorder);
Cb = Cb(1:rorder);
rsys = ss(Ab,Bb,Cb,sys.D,1);

[ry,fit] = compare(preprocessed_prbs_val, idpoly(rsys))

figure(2); clf; grid on;
plot(ry.y); hold on;
plot(preprocessed_prbs_val.y);

figure(3);clf;
pzplot(rsys); hold on;
pzplot(sys); legend('reduced order system','original system');

figure(4);clf;
pzplot(rsys); hold on;

[mag,phase,wout] = bode(rsys); 
mag = squeeze(mag);

