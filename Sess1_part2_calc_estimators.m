function [ LS , EIV ] = Sess1_part2_calc_estimators( set,stdev_ni,stdev_nu )
% dim1= #measurements
% dim2= #experiments
% dim3= [i u] ! vector !

size_set = size(set);
amount_of_experiments = size_set(2);

% Allocation
EIV = zeros(amount_of_experiments,1);
LS = zeros(amount_of_experiments,1);

for index_experiment = 1:amount_of_experiments
    i = set(:,index_experiment,1);
    u = set(:,index_experiment,2);
    
    %% LS Estimator
    LS(index_experiment) = u'*i/(i'*i);
    
    %% EIV Estimator
    num = 0; denom = 0;
    
    num = sum((u.^2))/(stdev_nu^2) - sum((i.^2))/(stdev_ni^2);
    num = num + sqrt( num^2 + 4* sum((u'*i).^2)/(stdev_ni^2 * stdev_nu^2)); 
    demum = 2*sum(u'*i)/stdev_nu;

    % divide previous terms
    EIV(index_experiment) = num/demum;
end

end

