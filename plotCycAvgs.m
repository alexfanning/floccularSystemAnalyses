function plotCycAvgs(calData,eyeData,stimuliData,parameters)
%
%   Plots single block average and concatenated blocks average
%
%   Alex Fanning, March 2020
% *************************************************************************



data2plot = {struct2cell(calData.cycAvgs(3).deltaF),struct2cell(eyeData.cycAvgs(3).vel),struct2cell(stimuliData.cycAvgs(1).filtRslip)};
dataRec2plot = {struct2cell(calData.cycAvgs(4).deltaF),struct2cell(eyeData.cycAvgs(4).vel),struct2cell(stimuliData.cycAvgs(2).filtRslip)};
stim2plot = {struct2cell(stimuliData.cycAvgs(2).drumVel),struct2cell(stimuliData.cycAvgs(2).ttableVel)};

plotName = {'Calcium block avgs','Eye vel. block avgs','Rslip block avgs','Record avgs'};
names = {'vord', 'visual', 'gap'};

for m = 1:length(data2plot) + 1
    if m ~= length(data2plot) + 1
        figure('Name',plotName{m})
        for t = 1:parameters.test.numConditions-1
            subplot(parameters.test.numConditions-1,1,t); hold on
            for i = 1:size(data2plot{m}(t,:),2)
                plot(data2plot{m}{t,i})
            end
            plot(dataRec2plot{m}{t},'Color','k','LineWidth',2)
            ylabel('Amplitude')
            xlabel('Time (ms)')
            title(names{t})
        end
    else
        figure('Name',plotName{m})
        for t = 1:parameters.test.numConditions-1
            subplot(parameters.test.numConditions-1,1,t); hold on
            plot(dataRec2plot{2}{t})
            plot(dataRec2plot{3}{t})
            plot(stim2plot{1}{t})
            plot(stim2plot{2}{t})
            ylabel('Amplitude')
            title(names{t})
            legend('Eye vel','Rslip','drum vel.','ttable vel.')
            xlabel('Time (ms)')
        end
    end
end
