function [dataOut] = sortedStructure(parameters,data,names)
%
%   Creates structure array containing blocks of data grouped by test
%   condition.
%
%   Alex Fanning, March 2021
% *************************************************************************

visualFreq = cell(1,parameters.test.numFreq);
for i = 1:parameters.test.numFreq
    visualFreq{i} = cat(1,{data{1:length(parameters.test.conditionIdxs{i})}});
end

dataOut = cell2struct(visualFreq,names,2);