close all;
ni = [0.004742, -0.001132, -000104];
i0 = [0.008701 0.006488 0.002797];
for k = 1:3
    rep(k) =  1/(1+(ni(k)/i0(k)))
end