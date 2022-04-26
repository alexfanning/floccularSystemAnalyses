function [saccadeVec,saccadeArray,connectionDistance,clusterCenter] = saccadeFilter(chunks,parameters)
% 
%   Detect saccades/artifacts in periodic data
%
%   This function takes in period data reshaped into a matrix
%       where each row in the matrix is one cycle/period of the data.
%
%   It considers each column of the array (points that are equivalent in
%   time) as a (sorted) distribution and labeling outlier points as saccades/events. 
%
%   Outliers are defined via their relationship to the "center" of this 
%   distribution, which we take to be the point in the middle of 
%   the tightest cluster of this distribution. This is done to account for
%   the case of characteristically timed saccades/events. Outliers are then
%   found by computing Sn (a robust scale measure), and 
%   comparing the distance between successive pairs of points both above 
%   and below the center until this distance exceeds the Sn-value (connectionDistance).
%   Once this occurs, all points further away from the center are labelled
%   as saccades, events. 
%   
%   As a final step, the binary vector of saccades/events is smoothed so 
%   that points tend to have the same label as their neighbors.
%   
%   The function returns a binary vector of length m * n, as well as the
%   vector input data.
%
%   Andrew Kirjner, July 2021
%
%   Modified by Alex Fanning, September 2021
% *********************************************************************
   
% Reshape matrix so that each column represents a cycle

% Create a logical array to be filled with saccades delineated
[m, ~] = size(chunks);
saccadeArray = zeros(size(chunks));

% Store cluster center and connection distance values for each timepoint
clusterCenter = NaN(1,size(chunks,2));
connectionDistance = NaN(1,size(chunks,2));

% Loop through each period
for i = 1:m

    % Consider each chunk (distribution of equvialent points mod period length)
    chunk = chunks(i,:);

    % Sort the chunk, keeping track of the sorted indices
    [sortedChunk, sortedIdxs] = sort(chunk);

    % Get the index of the center of the tightest cluster
    [clusterCenter(i),sortedCenterIdx] = findTightestCluster(sortedChunk, parameters.eye.clusterSize);

    % Find the indices of the saccade/event points within a given chunk
    [saccadeTemp,connectionDistance(i)] = getSaccadeIdxs(sortedCenterIdx,sortedChunk);
    saccadeIdxs = sortedIdxs(saccadeTemp);

    % Create binary vector that is the size of the chunk, with ones in
    % at the indices of points labeled as saccades
    chunkBin = zeros(length(chunk), 1);
    for j = 1:length(chunk)
        if ismember(j, saccadeIdxs)
            chunkBin(j) = 1;
        end
    end

    % Fill the column of the saccade array with the binary vector
    saccadeArray(i,:) = chunkBin;
end

% Convert array to vector and smooth using a moving average filter and a thresold. These values can be changed
saccadeVec = reshape(saccadeArray.', 1, []);
saccadeVec = (smoothdata(saccadeVec, 'movmean', parameters.eye.clusterDesacMovMean) > parameters.eye.clusterDesacThresh);
