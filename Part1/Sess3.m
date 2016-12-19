close all;
load oef1.mat;

% impulse(syspoly)
% 
% u = iddata([],randn(1000,1),1);
% y = sim(syspoly,u);
% cra([y,u])

% figure(1)
% variance = 0.001;
% set(syspoly,'NoiseVariance',variance);
% u = iddata([],randn(1000,1),1);
% opt = simOptions('AddNoise',true,'NoiseData',randn(1000,1));
% y = sim(syspoly,u,opt);
% cra([y,u


% bode(tf(syspoly))
% [p,z] = pzmap(syspoly)
% angle_p = angle(p)
% angle_z = angle(z)
% norm(p(1))
% norm(p(2))
% norm(p(3)) 
% norm(p(4))
number_of_samples=1000;
%% Estimating an ARX model

u = iddata([],randn(number_of_samples,1),1);
y = sim(syspoly,u);

na = get(syspoly,'na');
nb = get(syspoly,'nb');
nk = get(syspoly,'nk');

model1 = arx([y,u],[na nb nk])

%% Estimating an ARX model corrupted with colored noise

u2 = iddata([],randn(number_of_samples,1),1);

% Butterworth filter
[b_butter, a_butter] = butter(4,0.2,'high');
e = randn(number_of_samples,1);
v = filter(b_butter,a_butter,e);

opt = simOptions('AddNoise',true,'NoiseData',v);
set(syspoly,'NoiseVariance',0.01*0.01);
y2 = sim(syspoly,u,opt);

na = get(syspoly,'na');
nb = get(syspoly,'nb');
nk = get(syspoly,'nk');

model2 = arx([y2,u],[na nb nk])

figure(1);
% plot the theoretical model and the generated model
subplot(2,1,1); bode(syspoly,model1);
subplot(2,1,2); bode(syspoly,model2);

%% Estimating an ARX model corrupted with colored noise and unknows order
na = get(syspoly,'na');
nb = get(syspoly,'nb');
nk = get(syspoly,'nk');

search_region = struc([na-2:na+2],[nb-2:nb+2],[nk-1:nk+1]);

e_val = randn(500,1);
opt = simOptions('AddNoise',true,'NoiseData',e_val);
set(syspoly,'NoiseVariance',0.01*0.01);
u_val = iddata([],randn(500,1),1);
y_val = sim(syspoly,u_val,opt);

V = arxstruc([y2,u],[y_val,u_val],search_region);
NN0 = selstruc(V,0); 
NN1 = selstruc(V,1); 
NN2 = selstruc(V,2); 

%%
model3 = arx([y_val,u_val],NN0);
model4 = arx([y_val,u_val],NN1);
model5 = arx([y_val,u_val],NN2);

figure(2);clf;
bode(syspoly,model2,model3,model4,model5);
legend('syspoly','model2','model3','model4','model5')

figure(3);clf;
pzmap(syspoly,model2,model3,model4,model5);
legend('syspoly','model2','model3','model4','model5')

%%
close all;
highOrderModel = arx([y2,u2],[10,10,nk]);
figure;
hsvd(ss(highOrderModel))
figure;

%model6 = balred(ss(highOrderModel),5)
model6 = balred(ss(highOrderModel),5);

idpoly(model6)

bode(syspoly,highOrderModel,model6);
legend('syspoly','highOrderModel','model6');

