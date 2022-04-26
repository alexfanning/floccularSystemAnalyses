function [vecData,matData] = nonconDataRemoval(vecData,matData,parameters)
%
%   Removes segments of data that are not continuous for a minimum amount
%       of time specified by the user (parameters.eye.minDataLength)
%
%   Takes in desaccaded vector, finds the length of each non-desaccaded
%   segment, and removes data that isn't continuous for at least .minDataLength
%
%   Alex Fanning, March 2020
% *************************************************************************

% Create cell array with desaccaded vector, depending on desaccading method
% that was used

vecDataTemp = {vecData(4).filtVel.vord, vecData(4).filtVel.visual, vecData(4).filtVel.gap};
vecDataFilt = vecDataTemp;

nanTimepts = cell(1,parameters.test.numConditions);
chunkLengths = cell(1,parameters.test.numConditions);
nanEnds = cell(1,parameters.test.numConditions);
goodChunkStarts = cell(1,parameters.test.numConditions);
goodChunkLengths = cell(1,parameters.test.numConditions);

for i = 1:parameters.test.numConditions
    
    a = 1;

    % Find NaN indices
    nanTimepts{i} = find(isnan(vecDataTemp{i}));

    % Find saccade endpoints
    chunkLengths{i} = nanTimepts{i}(2:end) - nanTimepts{i}(1:end-1);
    for m = 1:length(chunkLengths{i})

        if chunkLengths{i}(m) ~= 1
            nanEnds{i}(a) = m;
            a = a + 1;
        end
        
    end
    
    nanEnds{i} = nanTimepts{i}(nanEnds{i});

    % Determine lengths of each non-desaccaded segment
    chunkLengths{i}(chunkLengths{i} == 1) = [];

    % Create vector with the start times of each segment to keep
    goodChunkStarts{i} = nanEnds{i} + 1;

    % Check if segment is longer than the minimum continuous data threshold
    goodChunkStarts{i}(chunkLengths{i} >= parameters.eye.minDataLength) = [];

    goodChunkLengths{i} = chunkLengths{i};
    goodChunkLengths{i}(goodChunkLengths{i} >= parameters.eye.minDataLength) = [];
    
    % Remove segments of data that do not exceed threshold
    for k = 1:length(goodChunkStarts{i})
        vecDataTemp{i}(goodChunkStarts{i}(k):goodChunkStarts{i}(k) + goodChunkLengths{i}(k) - 1) = NaN;
    end

end

%% Plot minimum data removal check

name = {'vord', 'visual', 'gap'};
figure('Name','Minimum data check')
for i = 1:parameters.test.numConditions

    if parameters.plot.minDataCheck == 1
        subplot(parameters.test.numConditions,1,i); hold on
        plot(vecDataFilt{i})
        plot(vecDataTemp{i})
        title(name{i})
        if i == 1
        legend('Desaccaded eye vel.','Min. data removed')
        elseif i == 2
            ylabel('Eye vel.')
        elseif i == 3
            xlabel('Time (ms)')
        end
    end

end

%% Plot distribution of length of non-desaccaded segments 

if parameters.plot.minSegLengths == 1
    figure('Name','Check segment lengths');
    for m = 1:parameters.test.numConditions
        subplot(parameters.test.numConditions,1,m); hold on
        histogram(chunkLengths{m},40)
        if m == 2
            ylabel('Number of segments')
        end
        title(name{m})
    end
    xlabel('Length of all non-desaccaded segments')
end

%% Convert cell arrays to structure arrays and store as output

vecData(4).filtVel = cell2struct(vecDataTemp,name,2);
vecData(3).filtVel = cell2struct(convertMatsVecs(vecData(4).filtVel,parameters,2),name,2);

matData(3).vel = cell2struct(convertMatsVecs(vecData(3).filtVel,parameters,4),name,2);
matData(4).vel = cell2struct(convertMatsVecs(matData(3).vel,parameters,3),name,2);
