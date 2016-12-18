function preprocessed_data = preprocessing( data, level, delay, cutoff, sigma, option )
% PREPROCESSING This MATLAB function returns the signal y which is
% preprocessed by means of the following steps:
%           - Removing the peaks + DC offset ;
%           - Removing the trend with a Butterworth filter ;
%           - Removing the delay ;
% Input :   * data: iddata object ;
%           * level: 2 elements vector, for the function pkshave ;
%           * delay: scalar, delay introduced by the system ;
%           * cutoff: scalar, cut-off frequency for the Butterworth
%           filter ;
%           * sigma: used for the plot ;
%           * option: = 1, to display the steps of preprocessing ;
%                     = 0, otherwise ;
% Output :  * preprocessed_y: iddata object, treated data;
y = data.y
% STEP 1 : Remove DC offset
DC = mean(y);
y_step1 = y - DC;

% STEP 2 : Remove the peaks with 'pkshave'
if ~isempty(level)
    y_step2 = pkshave(y_step1, level);
else
    level = std(y_step1);
    y_step2 = pkshave(y_step1, [-level,level]);
end

% STEP 3 : Remove the trend
[bf,af] = butter(4, cutoff); % low pass Butterworth filter
yTrend = filtfilt(bf, af, y_step2);
y_step3 = y_step2 - yTrend;

% STEP 4 : Remove the delay
preprocessed_y = y_step3(delay:end);

% Plot
if option == 1
    figure(1); clf;
    subplot(2,2,1); plot(y_step1,'LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Output y - without DC offset', 'FontWeight','bold');
    ylim([-sigma,sigma]);
    
    subplot(2,2,2); plot(y_step2,'LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Peak shaving', 'FontWeight','bold');
    ylim([-sigma,sigma]);
 
    subplot(2,2,3); plot(y_step3,'LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Detrended y', 'FontWeight','bold');
    ylim([-sigma,sigma]);
    
    subplot(2,2,4); plot(y_step1(delay:end),'LineWidth',2); hold on;
    plot(preprocessed_y,'r','LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Delay removed - Preprocessed output', ...
        'FontWeight','bold');
    legend('Raw y','Preprocessed y');
    ylim([-sigma,sigma]);
elseif option == 2
    figure(1); clf; plot(y_step1,'LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Output y - without DC offset', 'FontWeight','bold');
    ylim([-sigma,sigma]);
    
    figure(2); clf; plot(y_step2,'LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Peak shaving', 'FontWeight','bold');
    ylim([-sigma,sigma]);
 
    figure(3); clf; plot(y_step3,'LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Detrended y', 'FontWeight','bold');
    ylim([-sigma,sigma]);
    
    figure(4); clf; plot(y_step1(delay:end),'LineWidth',2); hold on;
    plot(preprocessed_y,'r','LineWidth',2);
    set(gca, 'fontsize', 15); grid on;
    xlabel('Time'); title('Delay removed - Preprocessed output', ...
        'FontWeight','bold');
    legend('Raw y','Preprocessed y');
    ylim([-sigma,sigma]);
end    

preprocessed_data = iddata(preprocessed_y, data.u, 1);


%     figure(2); clf;
%     plot(abs(fft(y_step1))); hold on;
%     plot(abs(fft(preprocessed_y)),'r');
end

