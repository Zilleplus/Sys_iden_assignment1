function [ LS , IV ] = Sess1_part1_calc_estimators( set,s )
% Computes the LS and IV estimates for data included in 'set'. The shift s
% for the IV estimate is specified as an argument.

size_set = size(set);
amount_of_experiments = size_set(2);

% Pre-allocation
IV = zeros(amount_of_experiments,1);
LS = zeros(amount_of_experiments,1);

for index_experiment = 1:amount_of_experiments
    i = set(:,index_experiment,1);
    u = set(:,index_experiment,2);
    
    %% LS Estimator
    LS(index_experiment) = u'*i/(i'*i);
    
    %% IV Estimator
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

