function [desaccade] = removeAroundCenters(vecData,parameters)
%
%   removeAroundCenters = expands the window around saccades and removes saccade-related data
%   from the fluorescence trace.
%
%   omitCenters = contains the windows of time removed around each identified saccade
%
%   desaccade = contains the windows of time to remove from fluorescence,
%   calculated by convolving the windowSize parameter defined by the user
%   with the omitCenters windows.
%
%   Alex Fanning, December 2019
% *************************************************************************

% Set size of and shifts window
vecData = circshift(vecData(2).sacTimepts, [parameters.calcium.shift 0]);
vecData(1:parameters.calcium.shift) = 0;

% Convolve expanded windows for fluorescence with sacTimepts windows
sacmask = ones(1, parameters.calcium.windowSize);
desaccade = conv(double(vecData),sacmask);
desaccade = logical(desaccade(parameters.calcium.windowSize / 2:parameters.calcium.windowSize / 2 + length(vecData) - 1));