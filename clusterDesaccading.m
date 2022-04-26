function [matData,vecData,parameters] = clusterDesaccading(matData,vecData,parameters,figName)
%
%   Desaccades eye velocity vector using median of differences between
%       adjacent points of the same period that are most tightly clustered.
%
%   clusterSize = number of datapoints considered to be "clustered"
%   together (effectively the number of cycles). Defines window size that
%   median is taken.
%
%   saccadeFilter = saccade identifying function
%
%   Alex Fanning, September 2021
% *************************************************************************

if parameters.test.numBlocks.vord == 0
    matData(2).vel.vord = {};
elseif parameters.test.numBlocks.visual == 0
    matData(2).vel.visual = {};
end

% Create cell array with data to iterate through each test condition, separately
dataCell = struct2cell(matData(2).vel);

% Create cell arrays to hold data
vecDesaccaded = cell(1,parameters.test.numConditions);
vecSacs = cell(1,parameters.test.numConditions);
sacTimepts = cell(1,parameters.test.numConditions);
matDesaccaded = cell(1,parameters.test.numConditions);
matSacs = cell(1,parameters.test.numConditions);
matSacTimepts = cell(1,parameters.test.numConditions);
connectDist = cell(1,parameters.test.numConditions);
clusterCtrs = cell(1,parameters.test.numConditions);
vecDataOut = cell(1,parameters.test.numConditions);
matDataOut = cell(1,parameters.test.numConditions);

% Iterate through each test condition and desaccade raw data
for t = 1:parameters.test.numConditions

    dataInput = double(dataCell{t});

    if ~isempty(dataInput) 
        
        % Define cluster size
        clusterSize = size(dataInput,2)/3;
        parameters.eye.clusterSize = 2*floor(clusterSize)/2 - 1;

        % Get saccade timepoints and return in vector and matrix form
        [vecDataOut{t},matDataOut{t},connectDist{t},clusterCtrs{t}] = saccadeFilter(dataInput,parameters);

        % Create copies of raw data
        matDesaccaded{t} = dataInput;
        matSacs{t} = dataInput;
        
        % Desaccade raw data copies
        matDesaccaded{t}(logical(matDataOut{t})) = NaN;
        matSacs{t}(logical(matDataOut{t})) = NaN;
        matSacTimepts{t} = matDataOut{t};

        % Convert concatenated desaccaded vectors into vectors
        vecDesaccaded{t} = matDesaccaded{t}(:);
        vecSacs{t} = matSacs{t}(:);
        sacTimepts{t} = vecDataOut{t};
    end
end

%% Check desaccading with plots

structName = {'vord', 'visual','gap'};
rawMats = struct2cell(matData(2).vel);

% Plot raw and desaccaded matrix data for each test condition, separately
figure('Name',figName)
for i = 1:parameters.test.numConditions
    subplot(parameters.test.numConditions,1,i); hold on
    plot(rawMats{i},'Color','k')
    plot(matDesaccaded{i},'Color','r')
    plot(clusterCtrs{i},'LineWidth',3)
    plot(clusterCtrs{i}+connectDist{i},'LineWidth',3,'Color','b')
    ylabel('Amplitude')
    title(structName{i})
end

% Plot raw and desaccaded vector data for each test condition, separately
rawVecs = struct2cell(vecData(4).rawVel);

figure('Name',figName)
for i = 1:parameters.test.numConditions
    subplot(parameters.test.numConditions,1,i); hold on
    plot(rawVecs{i},'Color','k')
    plot(vecDesaccaded{i},'Color','r')
    ylabel('Amplitude')
    title(structName{i})
end
legend('Raw eye vel.','Desaccaded')

%% Convert from cell array to structure array form

matData(4).vel = cell2struct(matDesaccaded,structName,2);
matData(2).sacs =  cell2struct(matSacs ,structName,2);
matData(2).sacTimepts = cell2struct(matSacTimepts,structName,2);

vecData(4).filtVel = cell2struct(vecDesaccaded,structName,2);
vecData(4).sacs = cell2struct(vecSacs,structName,2);
vecData(4).sacTimepts = cell2struct(sacTimepts,structName,2);

parameters.eye.connectionDist = cell2struct(connectDist,structName,2);
parameters.eye.clusterCtrs = cell2struct(clusterCtrs,structName,2);

% Reorganize concatenated blocks matrix into individual block matrices

matData(3).vel = cell2struct(convertMatsVecs(matData(4).vel,parameters,1),structName,2);
matData(1).sacs = cell2struct(convertMatsVecs(matData(2).sacs,parameters,1),structName,2);
matData(1).sacTimepts = cell2struct(convertMatsVecs(matData(2).sacTimepts,parameters,1),structName,2);

vecData(3).filtVel = cell2struct(convertMatsVecs(vecData(3).filtVel,parameters,2),structName,2);
vecData(3).sacs = cell2struct(convertMatsVecs(vecData(3).sacs,parameters,2),structName,2);
vecData(3).sacTimepts = cell2struct(convertMatsVecs(vecData(3).sacTimepts,parameters,2),structName,2);
