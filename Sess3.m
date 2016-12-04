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

%% Estimating an ARX model

u = iddata([],randn(1000,1),1);
y = sim(syspoly,u);

na = get(syspoly,'na');
nb = get(syspoly,'nb');
nk = get(syspoly,'nk');

model1 = arx([y,u],[na nb nk])

%% Estimating an ARX model corrupted with colored noise

u = iddata([],randn(1000,1),1);

% Butterworth filter
[b_butter, a_butter] = butter(4,0.2,'high');
e = randn(1000,1);
v = filter(b_butter,a_butter,e);

opt = simOptions('AddNoise',true,'NoiseData',v);
set(syspoly,'NoiseVariance',0.01*0.01);
y2 = sim(syspoly,u,opt);

na = get(syspoly,'na');
nb = get(syspoly,'nb');
nk = get(syspoly,'nk');

model2 = arx([y,u],[na nb nk])

figure();
subplot(2,1,1); bode(syspoly,model1)
subplot(2,1,2); bode(syspoly,model2)





