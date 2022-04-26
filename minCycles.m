function [matData,vecData,stimMatData,stimVecData] = minCycles(matData,vecData,stimMatData,stimVecData,parameters)
%
%   Removes blocks of data that do not have a minimum number of cycles
%       without saccades or other artifact.
%
%   Alex Fanning, March 2020
% *************************************************************************

% Grab data to iterate through
matTemp = {matData(3).vel.vord, matData(3).vel.visual, matData(3).vel.gap};
matTemp = matTemp(~cellfun('isempty',matTemp));
numBlocks = [parameters.test.numBlocks.vord,parameters.test.numBlocks.visual,parameters.test.numBlocks.gap];
numTime = [parameters.test.numTime.vord, parameters.test.numTime.visual, parameters.test.numTime.gap];

% Create cell arrays to hold data
badCycles = cell(1,sum(numBlocks));
goodCycles = cell(1,sum(numBlocks));
badCycTemp = cell(max(numTime),length(matTemp));
newMat = cell(max(numBlocks),parameters.test.numConditions);

% Iterate through each block of each condition and mark the number of bad
% cycles per block
for i = 1:sum(numBlocks)
    
    badCycles{i} = zeros(size(matTemp{i},2),1);

    % Loop through each cycle of a block separately
    for k = 1:size(matTemp{i},2)
        
        % Mark if saccades occur in the cycle
        badCycTemp{k,i} = find(isnan(matTemp{i}(:,k)));

        % If the cycle has a saccade/artifact, mark that cycle as bad
        if isempty(badCycTemp{k,i})
            badCycles{i}(k) = 1;
        end

    end

    % Count the number of good cycles for each block
    goodCycles{i} = sum(badCycles{i});

    % Remove data in a block that does not have enough good cycles
    if goodCycles{i} <= parameters.eye.goodCycMin
        matTemp{i} = {};
    end

end

%% Create a new cell array that can be converted into the proper structure array

counter = 1;
for m = 1:parameters.test.numConditions

    for j = 1:numBlocks(m)

        newMat{j,m} = matTemp{counter};

        % Fill blocks where data was removed with NaNs
        if isempty(matTemp{counter})
            newMat{j,m} = NaN(1/parameters.test.frequency*parameters.test.fr,numTime(m));
        end

        counter = counter + 1;
    end

end

%% Convert cell array back into structure array

names = {'vord', 'visual', 'gap'};

matData(3).vel = cell2struct(newMat,names,2);
matData(4).vel = cell2struct(convertMatsVecs(matData(3).vel,parameters,3),names,2);

vecData(3).filtVel = cell2struct(convertMatsVecs(matData(3).vel,parameters,5),names,2);
vecData(4).filtVel = cell2struct(convertMatsVecs(vecData(3).filtVel,parameters,6),names,2);

%% Remove same datapoints from retinal slip vectors and matrices

vecCopy = struct2cell(vecData(4).filtVel);
stimVecTemp = struct2cell(stimVecData(4).filtRslip);

idx = cell(1,parameters.test.numConditions);
for i = 1:parameters.test.numConditions
    tempIdx = find(isnan(vecCopy{i}));
    idx{i} = tempIdx;
    stimVecTemp{i}(idx{i}) = NaN;
end

stimVecData(4).filtRslip = cell2struct(stimVecTemp,names,1);
stimVecData(3).filtRslip = cell2struct(convertMatsVecs(stimVecData(4).filtRslip,parameters,2),names,2);

stimMatData(1).filtRslip = cell2struct(convertMatsVecs(stimVecData(3).filtRslip,parameters,4),names,2);
stimMatData(2).filtRslip = cell2struct(convertMatsVecs(stimMatData(1).filtRslip,parameters,3),names,2);

