function [dataOut] = structSegments(dataMatIn,parameters)
%
%   Takes entire record matrix data in and reorganizes it into single block
%   vector form, all blocks concatenated into single vector form, and
%   single block matrix form.
%
%   Alex Fanning, February 2020
% *************************************************************************

numBlocks = [parameters.test.numBlocks.vord, parameters.test.numBlocks.visual, parameters.test.numBlocks.gap];

dataTemp = cell(1,parameters.test.numConditions);
dataBlocks = cell(max(numBlocks),parameters.test.numConditions);
dataMatTemp = cell(1,parameters.test.numConditions);

for i = 1:parameters.test.numConditions
    for k = 1:numBlocks(i)
        dataBlocks{k,i} = dataMatIn{k,i}(:);
    end
    dataTemp{i} = cat(1,dataBlocks{:,i});
    dataMatTemp{i} = cat(2,dataMatIn{:,i});
end

dataOut{1} = dataMatIn;
dataOut{2} = dataMatTemp;
dataOut{3} = dataBlocks;
dataOut{4} = dataTemp;