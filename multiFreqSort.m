function [dataMatrices] = multiFreqSort(parameters,dataMatrices,type)
%
%   Converts each data matrix into a data vector and then reshapes the
%       vector back into a matrix according to the appropriate frequency. This
%       script is only called for protocols that have multiple frequency tests
%       in an experiment.
%
% Alex Fanning, March 2021
% *************************************************************************

% Create cell array of relevant data matrices according to type (calcium,eye, or stimuli)

if type == 1
    dataCell = {dataMatrices.deltaF.raw.visual; dataMatrices.deltaF.desaccaded.visual; dataMatrices.f.raw.visual;...
        dataMatrices.g.raw.visual; dataMatrices.f0.raw.visual};
elseif type == 2
    dataCell = {dataMatrices.pos.raw.visual; dataMatrices.pos.desaccaded.visual; dataMatrices.vel.raw.visual;...
        dataMatrices.vel.desaccaded.visual; dataMatrices.acc.raw.visual; dataMatrices.sacs.raw.visual};
elseif type == 3
    dataCell = {dataMatrices.drum.pos.visual; dataMatrices.drum.vel.visual; dataMatrices.ttable.pos.visual;...
        dataMatrices.ttable.vel.visual; dataMatrices.rSlip.raw.visual; dataMatrices.rSlip.desaccaded.visual};
end

% Group blocks of data according to test condition

dataOutput = cell(parameters.test.numFreq,size(parameters.test.conditionIdxs{5},2));
for j = 1:length(dataCell)
    dataInput = dataCell{j};
    for t = 1:parameters.test.numFreq
            for i = 1:length(parameters.test.conditionIdxs{j})
                if length(parameters.test.conditionIdxs{t}) >= i
                    dataOutput{t,i} = dataInput{parameters.test.conditionIdxs{t}(i)};
                end
            end
    end

    % Convert data matrices into data vectors to be resorted according to the proper frequency

    [dataMatrices] = createStructArrays(dataMatrices,parameters,dataOutput,j,type,1);
    
end

% Turn each data matrix into a data vector and then convert back to a
% matrix using the proper frequency for each test

[dataVectors.new, dataMatrices.new] = reshapeMatrices(parameters,dataMatrices,type);
