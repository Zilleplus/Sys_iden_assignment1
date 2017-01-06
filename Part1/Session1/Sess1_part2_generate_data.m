function [ set ] = Sess1_part2_generate_data( size_experiment,amount_of_experiments, ... 
    R0,stdev_nu,stdev_ni,stdev_i0 )
    % dim1= #measurements
    % dim2= #experiments
    % dim3= [i u] ! vector !
    set = ones(size_experiment,amount_of_experiments,2);
    for index_experiment = 1:amount_of_experiments
        
        % Generating the current i0
        mean_i0 = 0;
        i0 = mean_i0 + stdev_i0*randn(size_experiment,1);

        % Generating the voltage u0
        u0 = R0*i0;

        % Generating the noise nu
        mean_nu = 0;
        nu = mean_nu + stdev_nu*randn(size_experiment,1); % zero mean white Gaussian noise

        % Generating the noise ni
        mean_ni = 0;
        ni = mean_ni + stdev_ni*randn(size_experiment,1); % zero mean white Gaussian noise

        % put the noise on both parameters
        i = i0 + ni;
        u = u0 + nu;

        set(:,index_experiment,:) = [i,u];
    end
end