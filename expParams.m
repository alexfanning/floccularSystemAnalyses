function [parameters] = expParams(parameters,startStopTimes)
%parameters.test.fr,parameters.test.frequency,expSubType,parameters.test.protocol,parameters.test.condition,startStopTimes(2).visual,startStopTimes(2).vord,startStopTimes(2).gap,startVisual,startDark,startGap
%   expParams = extracts the number of blocks per test parameters.test.condition and length
%   of each block.
%
%   Alex Fanning, October 2019
% *************************************************************************

% Extracts number of blocks per test parameters.test.condition

if parameters.test.expSubType ~= 3 && parameters.test.expSubType ~= 5
    parameters.test.numBlocks.visual = numel(startStopTimes(2).visual);             % Total number of visual test blocks
else
    parameters.test.numBlocks.visual = 0;
end
parameters.test.numBlocks.vord = numel(startStopTimes(2).vord);                     % Total number of VORD test blocks
parameters.test.numBlocks.gap = numel(startStopTimes(2).gap);                       % Total number of gaps

% Determine parameters.test.condition with largest number of blocks

if parameters.test.numBlocks.visual >= parameters.test.numBlocks.vord && parameters.test.numBlocks.visual >= parameters.test.numBlocks.gap
    parameters.test.numBlocks.max = parameters.test.numBlocks.visual;
elseif parameters.test.numBlocks.vord >= parameters.test.numBlocks.visual && parameters.test.numBlocks.vord >= parameters.test.numBlocks.gap
    parameters.test.numBlocks.max = parameters.test.numBlocks.vord;
else
    parameters.test.numBlocks.max = parameters.test.numBlocks.gap;
end

%% Extract amount of time per test block 

parameters.test.numTime = {};
if parameters.test.protocol == 0 && parameters.test.condition == 3
    parameters.test.numTime.visual = 0;
else
    parameters.test.numTime.visual = round((startStopTimes(2).visual(1)/parameters.test.fr)-(startStopTimes(1).visual(1)/parameters.test.fr));
end

if parameters.test.protocol == 3 || parameters.test.expSubType == 4
    parameters.test.numTime.vord = [];
elseif parameters.test.frequency == 0.5
    parameters.test.numTime.vord = round((startStopTimes(2).vord(1)/parameters.test.fr)-(startStopTimes(1).vord(1)/parameters.test.fr))-1;
else
    parameters.test.numTime.vord = round((startStopTimes(2).vord(1)/parameters.test.fr)-(startStopTimes(1).vord(1)/parameters.test.fr));
end

if parameters.test.protocol == 3 || parameters.test.expSubType == 4 || (parameters.test.protocol == 0 && parameters.test.condition == 3)
    parameters.test.numTime.gap = round((startStopTimes(2).gap(1)/parameters.test.fr)-(startStopTimes(1).gap(1)/parameters.test.fr));
else
    parameters.test.numTime.gap = round((startStopTimes(2).gap(2)/parameters.test.fr)-(startStopTimes(1).gap(2)/parameters.test.fr));
end

%% Define segment lengths used to truncate excess datapoints

parameters.test.keep = {};
parameters.test.keep.vord = parameters.test.numTime.vord * parameters.test.fr;                   % Actual length of VORD test blocks (ms)
parameters.test.keep.visual = parameters.test.numTime.visual * parameters.test.fr;               % Actual length of visual test blocks
parameters.test.keep.gap = parameters.test.numTime.gap * parameters.test.fr;                     % Actual length of gaps
