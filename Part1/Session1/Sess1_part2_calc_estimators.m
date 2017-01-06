function [ LS , EIV, IV ] = Sess1_part2_calc_estimators( set,stdev_ni,stdev_nu )
% Computes the LS, EIV  and IV estimates for data included in 'set'. The 
% shift s for the IV estimate is specified set to 1. The standard deviation
% of the noise on the input and on the output (n_i and n_u) are specified
% as an argument.

size_set = size(set);
amount_of_experiments = size_set(2);

% Preallocation
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
    
    %% IV Estimator
    s = 1;
    
    num = 0; denom = 0;
    % add all terms
    size_num_denom = size(u);
    amount_of_terms=size_num_denom(1);
    
    for j = 1:amount_of_terms-s
        num = num + u(j)*i(j+s);
        denom = denom + i(j)*i(j+s);
    end
    
    % divide previous terms
    IV(index_experiment) = num./denom;
end

end

