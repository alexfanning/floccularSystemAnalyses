function newDatout = removeTransients(datin)
%
%   removeTransients = removes high-frequency artifact from eye position data
%
%   Looks at each datapoint of the eye position vector (i) and compares it
%   with the prior datapoint and subsequent datapoint. If both comparisons
%   exceed the threshold value and the difference between the prior and
%   subsequent datapoint are less than the threshold, datapoint (i) becomes
%   the average of the surrounding two points.
%
%   newThresh = mean of differentiated vector. Used as threshold.
%
% *************************************************************************

    thresh = 0.5;                        %threshold arbitrarily set to 0.5 (will be changed to mean of differentiated vector)
    datout = datin;
    datDiff = NaN(1,length(datin))-1;
    for i = 2 : length(datin) - 1
        if abs(datin(i) - datin(i - 1)) > thresh && abs(datin(i) - datin(i + 1)) > thresh && abs(datin(i - 1) - datin(i + 1)) < thresh
            datout(i) = (datin(i - 1) + datin(i + 1)) / 2;
        end
        datDiff(i) = abs(datin(i) - datin(i - 1));
    end

    newThresh = nanmean(datDiff);
    datDiffMedian = nanmedian(datDiff);
    
    %run the same operations except with the new threshold
    newDatout = datin;
    for i = 2 : length(datin) - 1
        if abs(datin(i) - datin(i - 1)) > newThresh && abs(datin(i) - datin(i + 1)) > newThresh && abs(datin(i - 1) - datin(i + 1)) < newThresh
            newDatout(i) = (datin(i - 1) + datin(i + 1)) / 2;
        end
    end
    newDatout = smooth(newDatout,5);
    
    % Plot mean and median of differentiated data
    figure('Name','Transient removal')
    subplot(2,1,1); hold on
    histogram(datDiff,100)
    xline(newThresh)
    ylabel('Number of events')
    xlabel('Difference (i - (i-1))')
    title('Transient threshold')

    % Plot filtered versus raw eye position
    subplot(2,1,2); hold on
    plot(datin);
    plot(newDatout);
    xlabel('Time (ms)')
    title('Filtered eye position (orange)')

    disp(['Transient thresh (mean): ',num2str(newThresh)])
    disp(['Transient thresh (median): ',num2str(datDiffMedian)])
