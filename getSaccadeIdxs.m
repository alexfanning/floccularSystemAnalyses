function [saccadeIdxs,connectionDistance] = getSaccadeIdxs(sortedCenterIdx, sortedChunk)
% Find saccades/event indices within a given chunk
%
%   This function takes in a sorted chunk and the center of the tightest
%   cluster and uses the Sn scale measurement to determine the indices of
%   saccades/events 
%
%   The function returns the indices of the saccade/event points in the
%   sorted chunk 
% 
%   Andrew Kirjner, July 2021
%
%   Modified by Alex Fanning, September 2021
% *********************************************************************
      
% Start with defining the points that are non-saccades, define a
% counter to keep track of the current next index of this vector so
% that new indices can be easily appened

nonSaccadeIdxs = (sortedCenterIdx);
counter = 2;

% Compute the "connection distance", which is the maximum distance that
%   successive pairs of points can be apart to be considered
%   non-saccades/events. Note that we use the Sn metric here (and also
%   truncate the chunk to avoid NaNs and exceedingly large values), but
%   this connection distance can change in principle.

connectionDistance = RousseeuwCrouxSn(sortedChunk(abs(sortedChunk) < 35 & ~isnan(sortedChunk))) * 1;

% Consider the distance between pairs of successive points
%   above the tightest cluster center, and compare that distance to the
%   connection distance threshold. If the distance does not exceed the
%   threshold, the point further away from the cluster center is added
%   to the non-saccade/event indices vector

currUpperIdx = sortedCenterIdx + 1;
while 1
    if currUpperIdx > length(sortedChunk)
        break;
    end

    if sortedChunk(currUpperIdx) - sortedChunk(currUpperIdx-1) > connectionDistance
        break
    end

    nonSaccadeIdxs(counter) = currUpperIdx;
    counter = counter + 1;
    currUpperIdx = currUpperIdx + 1;
end

% Same process, but using successive pairs of points below the tight cluster center
currLowerIdx = sortedCenterIdx-1;
while 1
    if currLowerIdx == 0
        break;
    end

    if sortedChunk(currLowerIdx + 1) - sortedChunk(currLowerIdx) ...
            > connectionDistance
        break;
    end

    nonSaccadeIdxs(counter) = currLowerIdx;
    counter = counter + 1;
    currLowerIdx = currLowerIdx - 1;
end

% Return "saccade" indices
saccadeIdxs = 1:length(sortedChunk);
saccadeIdxs = saccadeIdxs(~ismember(saccadeIdxs, nonSaccadeIdxs));
