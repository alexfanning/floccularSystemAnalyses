function [dataMatrices,dataVecs] = createStructArrays(dataMatrices,dataVecs,parameters,data,vecType,dataType,randSortTrue)
%
%   Creates structure arrays with easy to decipher nomenclature and are
%       filled with data matrices (calculated in segmenting.m) 
%
%   dataMatrices = structure array of data that contains all of the data
%   matrices calculated in segmenting.m.
%
%   parameters = contains all parameter variables.
%
%   data = contains data vectors for each raw data variable for all
%   protocols. Protocol 3 contains a second round of processing where 'data'
%   represents the blocks of visual data that have been organized according
%   to test condition.
%
%   vecType = refers to which vector of data is being processed (i.e.
%   deltaF raw, deltaF desaccaded, f raw, etc.).
%
%   dataType = refers to whether calcium, eye, or stimuli data matrices are
%   being processed and stored.
%
%   randSortTrue = set to 0 for segmenting purposes, otherwise set to 1 for
%   protocol 3 grouping of blocks according to test condition that had been
%   pseudo-randomized.
%
%   Alex Fanning, February 2020
% *************************************************************************

subNames = {'vord', 'visual','gap'};

if dataType == 1 || dataType == 2
    dataMatrices(1).type = 'Raw (blocks)';
    dataMatrices(2).type = 'Raw (whole record)';
    dataMatrices(3).type = 'Desaccaded (blocks)';
    dataMatrices(4).type = 'Desaccaded (whole record)';
else
    dataMatrices(1).type = 'Blocks';
    dataMatrices(2).type = 'Whole record';
end

dataVecs(3).type = 'Segmented (whole record)';
dataVecs(4).type = 'Segmented (blocks)';

if randSortTrue == 0
    if dataType == 1
        
        % Stores data in matrices for calcium variables
        if vecType == 1
            [dataOut] = structSegments(data,parameters);
            dataMatrices(1).deltaF = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).deltaF = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).deltaF = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).deltaF = cell2struct(dataOut{4},subNames,2);
        elseif vecType == 2

            [dataOut] = structSegments(data,parameters);

            dataMatrices(3).deltaF = cell2struct(dataOut{1},subNames,2);
            dataMatrices(4).deltaF = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).filtDeltaF = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).filtDeltaF = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 3

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).f = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).f = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).f = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).f = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 4

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).g = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).g = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).g = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).g = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 5

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).f0 = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).f0 = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).f0 = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).f0 = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 6

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).sacTimepts = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).sacTimepts = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).sacTimepts = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).sacTimepts = cell2struct(dataOut{4},subNames,2);
        end

    elseif dataType == 2
        
        % Stores data in matrices for eye variables  
        if vecType == 1

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).pos = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).pos = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).rawPos = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).rawPos = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 2
            [dataOut] = structSegments(data,parameters);

            dataMatrices(3).pos = cell2struct(dataOut{1},subNames,2);
            dataMatrices(4).pos = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).filtPos = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).filtPos = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 3

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).vel = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).vel = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).rawVel = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).rawVel = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 4
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(3).vel = cell2struct(dataOut{1},subNames,2);
            dataMatrices(4).vel = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).filtVel = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).filtVel = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 5
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).acc = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).acc = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).accRaw = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).accRaw = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 6
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).sacs = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).sacs = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).sacs = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).sacs = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 7
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).sacTimepts = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).sacTimepts = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).sacTimepts = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).sacTimepts = cell2struct(dataOut{4},subNames,2);
        end

    elseif dataType == 3    

        % Stores data in matrices for stimuli variables
        if vecType == 1
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).drumPos = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).drumPos = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).drumPos = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).drumPos = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 2
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).drumVel = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).drumVel = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).drumVel = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).drumVel = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 3

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).ttablePos = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).ttablePos = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).ttablePos = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).ttablePos = cell2struct(dataOut{4},subNames,2);

        elseif vecType == 4

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).ttableVel = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).ttableVel = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).ttableVel = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).ttableVel = cell2struct(dataOut{4},subNames,2);

            dataMatrices(1).ttableVel = cell2struct(data,subNames,2);
        elseif vecType == 5
            
            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).rawRslip = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).rawRslip = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).rawRslip = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).rawRslip = cell2struct(dataOut{4},subNames,2);

            dataMatrices(1).rawRslip = cell2struct(data,subNames,2);
        elseif vecType == 6

            [dataOut] = structSegments(data,parameters);

            dataMatrices(1).filtRslip = cell2struct(dataOut{1},subNames,2);
            dataMatrices(2).filtRslip = cell2struct(dataOut{2},subNames,2);
            dataVecs(3).filtRslip = cell2struct(dataOut{3},subNames,2);
            dataVecs(4).filtRslip = cell2struct(dataOut{4},subNames,2);

            dataMatrices(1).filtRslip = cell2struct(data,subNames,2);
        end

    end

else
    % Create and store reorganized data matrices into structure arrays
    names = {'sine05hz','sine1hz','sine2hz','sine4hz','step5ds','step10ds'};
    if dataType == 1
        if vecType == 1
            dataMatrices(1).deltaF = sortedStructure(parameters,data,names);
        elseif vecType == 2
            dataMatrices(1).filtDeltaF = sortedStructure(parameters,data,names);
        elseif vecType == 3
            dataMatrices(1).F = sortedStructure(parameters,data,names);
        elseif vecType == 4
            dataMatrices(1).G = sortedStructure(parameters,data,names);
       elseif vecType == 5
            dataMatrices(1).F0 = sortedStructure(parameters,data,names);
        end
    elseif dataType == 2
        if vecType == 1
            dataMatrices(1).pos = sortedStructure(parameters,data,names);
        elseif vecType == 2
            dataMatrices(3).pos = sortedStructure(parameters,data,names);
        elseif vecType == 3
            dataMatrices(1).vel = sortedStructure(parameters,data,names);
        elseif vecType == 4
            dataMatrices(3).vel = sortedStructure(parameters,data,names);
        elseif vecType == 5
            dataMatrices(1).acc = sortedStructure(parameters,data,names);
        elseif vecType == 6
            dataMatrices(1).sacs = sortedStructure(parameters,data,names);
        elseif vecType == 7
            dataMatrices(3).sacTimepts = sortedStructure(parameters,data,names);
        end
    elseif dataType == 3
        if vecType == 1
            dataMatrices(1).drumPos = sortedStructure(parameters,data,names);
        elseif vecType == 2
            dataMatrices(1).drumVel = sortedStructure(parameters,data,names);
        elseif vecType == 3
            dataMatrices(1).ttablePos = sortedStructure(parameters,data,names);
        elseif vecType == 4
            dataMatrices(1).ttableVel = sortedStructure(parameters,data,names);
        elseif vecType == 5
            dataMatrices(1).rawRslip = sortedStructure(parameters,data,names);
        elseif vecType == 6
            dataMatrices(1).filtRslip = sortedStructure(parameters,data,names);
        end
    end
end