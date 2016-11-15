function [ set, correlation_ni, correlation_i0 ] = Sess1_part1_generate_data( N,amount_of_experiments,fgen,R0,stdev_nu,stdev_ni,stdev_i0,fnoise )
    % dim1= #measurements
    % dim2= #experiments
    % dim3= [i u]
    set = ones(N,amount_of_experiments,2);
    for index_experiment = 1:amount_of_experiments
        % Generating the current i0
        e1=randn(N,1);
        [bgen,agen] = butter(1,fgen);
        i0 = filter(bgen,agen,e1);
        i0 = i0*stdev_i0/std(i0); % is it ok ?

        % Generating the voltage u0
        u0 = R0*i0;

        % Generating the noise nu
        mean_nu = 0;
        nu = mean_nu + stdev_nu*randn(N,1); % zero mean Gaussian white noise

        % Generating the noise ni
        e2 = randn(N,1);
        [bnoise,anoise] = butter(2,fnoise);
        ni = filter(bnoise,anoise,e2);
        ni = ni*stdev_ni/std(ni);

        % Model
        i = i0 + ni;
        u = u0 + nu;

        set(:,index_experiment,:) = [i,u];
    end
    correlation_ni = xcorr(ni,11,'unbiased');
    correlation_i0 = xcorr(i0,11,'unbiased');
end