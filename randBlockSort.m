function[parameters] = randBlockSort(parameters)
%
%   Takes vector with the pseudo-randomized test conditions, which are
%       recorded in order of presentation during the experiment, and sorts
%       them according to test condition
%
%   parameters.test.randBlockStr = order of the randomized test conditions
% 
%   Alex Fanning, February 2021
% *************************************************************************

numRow = [1,1,1,1,1,1];
randSort = cell(parameters.test.numFreq,1);

for i = 1:parameters.test.numBlocks.visual
    if parameters.test.randBlockStr(i) == 0.5
        randSort{1}(numRow(1)) = i;
        numRow(1) = numRow(1) + 1;
    elseif parameters.test.randBlockStr(i) == 1
        randSort{2}(numRow(2)) = i;
        numRow(2) = numRow(2) + 1;
    elseif parameters.test.randBlockStr(i) == 2
        randSort{3}(numRow(3)) = i;
        numRow(3) = numRow(3) + 1;
    elseif parameters.test.randBlockStr(i) == 4
        randSort{4}(numRow(4)) = i;
        numRow(4) = numRow(4) + 1;
    elseif parameters.test.randBlockStr(i) == 5
        randSort{5}(numRow(5)) = i;
        numRow(5) = numRow(5) + 1;
    elseif parameters.test.randBlockStr(i) == 6
        randSort{6}(numRow(6)) = i;
        numRow(6) = numRow(6) + 1;
    end
end

parameters.test.conditionIdxs = randSort;