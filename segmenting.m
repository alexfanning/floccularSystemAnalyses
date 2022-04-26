function [dataMatrices, dataVectors] = segmenting(dataVectors,segmentTimes,parameters,type)
%
%   Reorganizes data vectors into matrices. Each matrix represents a
%       testing block and matrices are grouped according to test condition
%
%   Spits out matrices for raw and desaccaded calcium, raw and desaccaded
%   eye position (pos) and eye velocity (vel), raw eye acceleration (acc),
%   and saccades (sacs), turntable position (ttable pos) and velocity
%   (ttable vel), drum position (drum pos) and velocity (drum vel), and
%   raw and desaccaded retinal slip (rSlip)
%
%
%
%   Alex Fanning, February 2020
% *************************************************************************

if isempty(parameters.test.keep.vord)
    parameters.test.keep.vord = 0;
    parameters.test.numTime.vord = 0;
elseif isempty(parameters.test.keep.visual)
    parameters.test.keep.visual = 0;
    parameters.test.numTime.visual = 0;
end

startStopTimes = {segmentTimes.vord; segmentTimes.visual; segmentTimes.gap};
keep = [parameters.test.keep.vord, parameters.test.keep.visual, parameters.test.keep.gap];
numTime = [parameters.test.numTime.vord, parameters.test.numTime.visual, parameters.test.numTime.gap];
numBlocks = [parameters.test.numBlocks.vord, parameters.test.numBlocks.visual, parameters.test.numBlocks.gap];

if type == 1
    dataCell = {dataVectors(2).deltaF; dataVectors(2).filtDeltaF; dataVectors(2).f; dataVectors(2).g; dataVectors(2).f0; dataVectors(2).sacTimepts};
elseif type == 2
    dataCell = {dataVectors(2).rawPos; dataVectors(2).filtPos; dataVectors(2).rawVel; dataVectors(2).filtVel; dataVectors(2).accRaw; dataVectors(2).sacs; dataVectors(2).sacTimepts};
elseif type == 3
    dataCell = {dataVectors(2).drumPos; dataVectors(2).drumVel; dataVectors(2).ttablePos; dataVectors(2).ttableVel; dataVectors(2).rawRslip; dataVectors(2).filtRslip};
end

dataTemp = cell(1,parameters.test.numConditions);
dataMatrices = {};
for k = 1:length(dataCell)
    dataInput = dataCell{k};

    for t = 1:parameters.test.numConditions
        
        nthTime = 1;
        if t == 1 && parameters.test.numBlocks.vord <= 0
            continue
        elseif t == 2 && parameters.test.numBlocks.visual <= 0 && (parameters.test.protocol == 3 || parameters.test.condition == 3)
            continue
        else
            for i = 1:numBlocks(t)
                if startStopTimes{t}(1) ~= startStopTimes{3}(1) && parameters.test.protocol ~= 3
                    blockSeg = dataInput((startStopTimes{t,1}(nthTime) - startStopTimes{3}(1)):(startStopTimes{t,2}(nthTime) - startStopTimes{3}(1)));
                elseif parameters.test.protocol == 3
                    blockSeg = dataInput((startStopTimes{t,1}(nthTime)+1 - startStopTimes{3,3}):(startStopTimes{t,2}(nthTime) - startStopTimes{3,3}));
                else
                    blockSeg = dataInput((startStopTimes{t,1}(nthTime)+1 - startStopTimes{3}(1)):(startStopTimes{t,2}(nthTime) - startStopTimes{3}(1)));
                end

                if length(blockSeg) >= keep(t)
                    blockSegTrunc = blockSeg(1:keep(t));
                elseif length(blockSeg) + 300 >= keep(t)
                    if islogical(blockSeg)
                        blockSeg(end:end+300) = 0;
                    else
                        blockSeg(end:end+300) = NaN;
                    end
                    blockSegTrunc = blockSeg(1:keep(t));
                else
                    blockSegTrunc = NaN(1,length(keep(t)));
                end

                if parameters.test.keep.vord == 0 && t == 1
                    continue
                elseif parameters.test.keep.visual == 0 && t == 2
                    continue
                else
                    dataTemp{i,t} = reshape(blockSegTrunc,parameters.test.fr*(1/parameters.test.frequency),numTime(t)*parameters.test.frequency);
                end
                
                nthTime = nthTime + 1;
            end
        end
    end
    
    % Convert cell arrays to structure arrays and appropriately store
    if type == 1
        [dataMatrices,dataVectors] = createStructArrays(dataMatrices,dataVectors,parameters,dataTemp,k,1,0);
    elseif type == 2
        [dataMatrices,dataVectors] = createStructArrays(dataMatrices,dataVectors,parameters,dataTemp,k,2,0);
    elseif type == 3
        [dataMatrices,dataVectors] = createStructArrays(dataMatrices,dataVectors,parameters,dataTemp,k,3,0);
    end
end
