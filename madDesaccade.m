function [vecData,matData,parameters] = madDesaccade(vecData,matData,parameters,figName)
%
%   Desaccades eye data using Median Absolute Deviation (MAD).
%
%   madMultiplier = scaling factor that can be changed to achieve
%   stricter or looser desaccading thresholds.
%
%   Alex Fanning, April 2021
% *************************************************************************

% Create cell arrays holding raw data for each test condition
rawMatData = struct2cell(matData(2).vel);
madMultiplier = struct2cell(parameters.eye.madMultipliers);

% Create empty cells to hold parameter data
rawVecData = cell(1,parameters.test.numConditions);
madVec = cell(1,parameters.test.numConditions);
medianVec = cell(1,parameters.test.numConditions);
upperBound = cell(1,parameters.test.numConditions);
lowerBound = cell(1,parameters.test.numConditions);

% Calculate MAD, median, and upper and lower bounds for each matrix
for i = 1:parameters.test.numConditions
    rawVecData{i} = rawMatData{i}(:);
    madVec{i} = mad(rawMatData{i},1,2);
    medianVec{i} = nanmedian(rawMatData{i},2);
    upperBound{i} = medianVec{i} + madMultiplier{i} * madVec{i};
    lowerBound{i} = medianVec{i} - madMultiplier{i} * madVec{i};
end

%% Plot median and thresholds on top of overlaid raw data

subNames = {'vord', 'visual', 'gap'};

figure('Name',figName)
for m = 1:parameters.test.numConditions
    tf = isempty(rawMatData{m});

    if tf == 0
        subplot(parameters.test.numConditions,1,m); hold on
        plot(rawMatData{m})
        plot(medianVec{m},'k','LineWidth',2)
        plot(upperBound{m},'k','LineWidth',2)
        plot(lowerBound{m},'k','LineWidth',2)
        title(subNames{m});
        xlabel('Time (ms)');
        ylabel('Velocity');
    end
end

%% Mark saccades that exceed MAD thresholds

desacVecTemp = cell(1,parameters.test.numConditions);
madDesacMatTemp = cell(1,parameters.test.numConditions);
sacCtrs = cell(1,parameters.test.numConditions);
numTrace = cell(1,parameters.test.numConditions);
madDesacVec = cell(1,parameters.test.numConditions);
madDesacMat = cell(1,parameters.test.numConditions);
madSacsMat = cell(1,parameters.test.numConditions);
madSacVec = cell(1,parameters.test.numConditions);
saccadeTimePts = cell(1,parameters.test.numConditions);
nonSaccadeTimePts = cell(1,parameters.test.numConditions);

numTime = [parameters.test.numTime.vord, parameters.test.numTime.visual, parameters.test.numTime.gap];
numBlocks = [parameters.test.numBlocks.vord, parameters.test.numBlocks.visual, parameters.test.numBlocks.gap];

% Loop through all cycles of each period to set datapoints that exceed MAD
% thresholds to 0

for m = 1:parameters.test.numConditions
    [cycTime,numTrials] = size(rawMatData{m});
    for j = 1:numTrials
        for k = 1:cycTime
            if rawMatData{m}(k,j) < lowerBound{m}(k) || rawMatData{m}(k,j) > upperBound{m}(k)
                madDesacMatTemp{m}(k,j) = 1;
            else
                madDesacMatTemp{m}(k,j) = 0;
            end
        end
    end

    % Convert to logical vectors with saccade timepoints
    desacVecTemp{m} = madDesacMatTemp{m}(:);
    sacCtrs{m} = logical(diff(desacVecTemp{m}'));

    % Iterate through each data point and set neighboring timepoints of
    % saccades to be saccades using presac and postsac variables

    numTrace{m} = parameters.eye.presac + 1:length(sacCtrs{m}) - parameters.eye.postsac;
    
    for i = numTrace{m}
        if sacCtrs{m}(i) == 1
            desacVecTemp{m}(i - parameters.eye.presac:i + parameters.eye.postsac) = 1;
        end
    end
    
    % Create copies of raw data
    madDesacVec{m} = rawVecData{m}(:);
    madSacVec{m} = madDesacVec{m};
    madSacsMat{m} = rawMatData{m};

    % Find saccade and non-saccade timepoints
    saccadeTimePts{m} = find(desacVecTemp{m}==1);
    nonSaccadeTimePts{m} = find(desacVecTemp{m}==0);

    % Desaccade raw data copies
    madDesacVec{m}(saccadeTimePts{m}) = NaN;
    madSacVec{m}(nonSaccadeTimePts{m}) = NaN;
    madSacsMat{m}(~madDesacMatTemp{m}) = NaN;

    % Convert concatenated desaccaded vectors into matrices
    if parameters.test.condition == 3 && m == 1
        madDesacMatTemp{1} = NaN(parameters.test.fr*(1/parameters.test.frequency),numTime(m)*parameters.test.frequency*numBlocks(m));
    else
        madDesacMatTemp{m} = reshape(desacVecTemp{m},parameters.test.fr*(1/parameters.test.frequency),numTime(m)*parameters.test.frequency*numBlocks(m));
        madDesacMat{m} = reshape(madDesacVec{m},parameters.test.fr*(1/parameters.test.frequency),numTime(m)*parameters.test.frequency*numBlocks(m));
    end
    
end

%% Plot checks on desaccading

figure('Name',figName)
for i = 1:parameters.test.numConditions
    subplot(parameters.test.numConditions,1,i); hold on
    plot(rawVecData{i},'k')
    plot(madDesacVec{i},'r')
    title(subNames{i});
    if i == 1
        legend('Raw eye vel.','Desaccaded eye vel.');
    elseif i == 3
        xlabel('Time (ms)');
    end
    ylabel('Velocity');
end

%% Convert cell arrays into structure arrays and nest in larger struct arrays

matData(4).vel = cell2struct(madDesacMat,subNames,2);
matData(2).sacs = cell2struct(madSacsMat,subNames,2);
matData(2).sacTimepts = cell2struct(madDesacMatTemp,subNames,2);

vecData(4).filtVel = cell2struct(madDesacVec,subNames,2);
vecData(4).sacs = cell2struct(madSacVec,subNames,2);
vecData(4).sacTimepts = cell2struct(desacVecTemp,subNames,2);

parameters.eye.mad = cell2struct(madVec,subNames,2);
parameters.eye.madMedianVec = cell2struct(medianVec,subNames,2);
parameters.eye.lowerBound = cell2struct(lowerBound,subNames,2);
parameters.eye.upperBound = cell2struct(upperBound,subNames,2);

% Reorganize concatenated blocks matrix into individual block matrices

matData(3).vel = cell2struct(convertMatsVecs(matData(4).vel,parameters,1),subNames,2);
matData(1).sacs = cell2struct(convertMatsVecs(matData(2).sacs,parameters,1),subNames,2);
matData(1).sacTimepts = cell2struct(convertMatsVecs(matData(2).sacTimepts,parameters,1),subNames,2);

vecData(3).filtVel = cell2struct(convertMatsVecs(vecData(4).filtVel,parameters,2),subNames,2);
vecData(3).sacs = cell2struct(convertMatsVecs(vecData(4).sacs,parameters,2),subNames,2);
vecData(3).sacTimepts = cell2struct(convertMatsVecs(vecData(4).sacTimepts,parameters,2),subNames,2);
