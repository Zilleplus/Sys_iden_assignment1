close all;
% Test for s = 1
s = 2;
stdev_i0 = 0.1;
stdev_ni = 0.1;
stdev_nu = 1;
stdev_u0 = stdev_i0*R0;
Rnini = correlation_ni_set3(12+s);
Ri0i0 = correlation_i0_set3(12+s);

pd2
stdev_RI = sqrt(stdev_i0^2*(stdev_nu^2 + stdev_ni^2*R0^2)/Ri0i0^2/N)


stdev_RI = stdev_i0^2*(stdev_nu^2 + stdev_ni^2*R0^2)/Ri0i0^2/N + ...
    (2*(stdev_u0^2*stdev_ni^2)^2+stdev_nu^2*stdev_i0^2*stdev_u0^2*stdev_ni^2+...
    stdev_ni^4*stdev_nu^2*stdev_i0^2)/Ri0i0^4/N;
sqrt(stdev_RI)