function [clusterCenter,sortedCenterIdx] = findTightestCluster(sortedChunk, clusterSize)
%
%   Find the center of the tightest cluster in a given chunk
%
%   This function takes in a sorted chunk and the size of the cluster to be
%   considered. It calculates the range (max - min) of each cluster
%   (sliding window of clusterSize size) and returns the index of the center
%   of the cluster with the smallest range (ignoring clusters that contain NaNs).
% 
%   Andrew Kirjner, July 2021
%
%   Modified by Alex Fanning, September 2021
% *********************************************************************

% Set initial minimum to infinity and set initial cluster center index
minRange = Inf;
winCenterIdx = floor(clusterSize/2);

% Loop through all potential clusters
for i = 1:length(sortedChunk)-clusterSize
    
    win = sortedChunk(i:i+clusterSize-1);
    
    % Skip clusters containing NaNs
    if sum(isnan(win)) > 0
        continue
    end

    winCenter = sortedChunk(i + winCenterIdx);
    windowRange = range(win);

    if windowRange < minRange
        minRange = windowRange;
        sortedCenterIdx = i + winCenterIdx;
    end
end

% Grab clusters center datapoint value
clusterCenter = sortedChunk(sortedCenterIdx);
