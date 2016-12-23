function preprocessed_data = preprocessing( data, level, delay, sigma, show_plot )
% PREPROCESSING This MATLAB function returns the signal y which is
% preprocessed by means of the following steps:
%           - Removing DC offset ;
%           - Removing the peaks ;
%           - Removing the trend ;
%           - Removing the delay ;
% Input :   * data: iddata object ;
%           * level: 2 elements vector, for the function pkshave ;
%           * delay: scalar, delay introduced by the system ;
%           * sigma: used for the plot ;
%           * show_plot: = 1, to display the steps of preprocessing ;
%                        = 0, otherwise ;
%                        = 2, other plot
% Output :  * preprocessed_y: iddata object, treated data;
%
% System identification and modelling
% December 2016
y = data.y ;
% STEP 1 : Remove DC offset
DC = mean(y) ;
y_step1 = y - DC ;

% STEP 2 : Remove the peaks with 'pkshave'
if ~isempty(level)
    y_step2 = pkshave(y_step1, level);
else
    level = std(y_step1);
    y_step2 = pkshave(y_step1, [-level,level]);
end

% STEP 3 : Remove the trend
% [bf,af] = butter(4, 0.05); % low pass Butterworth filter
% yTrend = filtfilt(bf, af, y_step2);
% y_step3 = y_step2 - yTrend;

[b, a] = butter(4, 0.01, 'high');
y_step3 = filter(b,a,y_step2);

% STEP 4 : Remove the delay
preprocessed_y = y_step3(delay:end);

% Plot
if show_plot == 1
    figure(1); clf;
    subplot(2,2,1); plot(y_step1,'LineWidth',2); grid on;
    xlabel('Time'); title('Output y - without DC offset');
    ylim([-sigma,sigma]);
    
    subplot(2,2,2); plot(y_step2,'LineWidth',2); grid on;
    xlabel('Time'); title('Peak shaving');
    ylim([-sigma,sigma]);
 
    subplot(2,2,3); plot(y_step3,'LineWidth',2); grid on;
    xlabel('Time'); title('Detrended y');
    ylim([-sigma,sigma]);
    
    subplot(2,2,4); plot(y_step1(delay:end),'LineWidth',2); hold on;
    plot(preprocessed_y,'r','LineWidth',2); grid on;
    xlabel('Time'); title('Delay removed - Preprocessed output', ...
        'FontWeight','bold');
    legend('Raw y','Preprocessed y');
    ylim([-sigma,sigma]);
elseif show_plot == 2
    figure(1); clf; plot(y_step1);
    set(gca, 'fontsize', 11); grid on;
    xlabel('Time'); title('Output y - without DC offset', 'FontWeight','bold');
    ylim([-sigma,sigma]);
    
    figure(2); clf; plot(y_step2);
    set(gca, 'fontsize', 11); grid on;
    xlabel('Time'); title('Peak shaving', 'FontWeight','bold');
    ylim([-sigma,sigma]);
 
    figure(3); clf; plot(y_step3);
    set(gca, 'fontsize', 11); grid on;
    xlabel('Time'); title('Detrended y', 'FontWeight','bold');
    ylim([-sigma,sigma]);
    
    figure(4); clf; plot(y_step1(delay:end)); hold on;
    plot(preprocessed_y,'r');
    set(gca, 'fontsize', 11); grid on;
    xlabel('Time'); title('Delay removed - Preprocessed output', ...
        'FontWeight','bold');
    legend('Raw y','Preprocessed y');
    ylim([-sigma,sigma]);
end    

input = data.u;
preprocessed_data = iddata(preprocessed_y, input(delay:end), 1);


%     figure(2); clf;
%     plot(abs(fft(y_step1))); hold on;
%     plot(abs(fft(preprocessed_y)),'r');
end

