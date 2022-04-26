%%  Analysis of stimuli, behavior, and fluorescence signals

clear
params.test = {}; params.eye = {}; params.calcium = {};

% Set variables for germane analyses
params.test.protocol = 0;                                   % Used to extract different keystrokes for segmenting of different experimental protocols (0 for default, 1 for older default version, 2 for sriramOKR, 3 for sriramOKRtestModAlex, or 4 for OKR with VORD tests during training)
params.test.condition = 1;                                  % Set to 0 for gain down, 1 for gain up or x1 vor, 2 for OKR, 3 for VORD, or 4 for alt x2x0 analyses
params.test.frequency = 1;                                  % Frequency of stimuli
params.test.fr = 1000;                                      % Sampling rate
params.eye.saccadeThresh = 500;                             % Eye velocity mean squared error threshold for what is considered a saccade (linear regression desaccading; typically between 100 and 1000)
params.eye.presac = 50;                                     % Number of points to remove prior to the first detected saccade timepoint
params.eye.postsac = 50;                                    % Number of points to remove following the last detected saccade timepoint
params.calcium.windowSize = 500;                            % Number of timepoints to remove from fluorescence trace re each detected saccade
params.calcium.shift = 100;                                 % Shift windowsize in time (positive value shifts rightward)

params.test.expSubType = 0;                 % Set to 0 for default analysis, 1 for alternating x2,x0 test analyses, 3 for VORD acute experiments, 4 for OKR acute experiments, or 5 for VORD training experiments
params.eye.desacMethod = 1;                 % Set to 0 for MSE desaccading, 1 for median absolute deviation (MAD) desaccading, or 2 for cluster desaccading
params.test.sinesFitting = 0;               % Set to 0 for sines-fitting or 1 to skip sines-fitting
params.eye.minDataLength = 250;             % Minimum number of datapoints that need to be continuous to be included in analysis
params.eye.goodCycMin = 0;                  % Minimum number of cycles per block needed to add block to cycle-average
params.test.nextCycleTime = 0;              % Set time (in ms) to look at cycle-averaged peak indexes that fall outside of the typical 1 second analysis window
params.calcium.desacCalcium = 0;            % Apply "desaccading" of fluorescence signal
params.test.numConditions = 3;              % Number of different conditions to do separate analysis on (e.g. the default protocol has gaps, VORD, and  visual tests for a total of 3 conditions)
params.eye.clusterDesacThresh = 0.002;      % Threshold for cluster saccading threshold (typically between 0.001-1)
params.eye.clusterDesacMovMean = 50;        % Related to cluster desaccading; smoothing of eye data, which turns more "neighbor" points into saccades (typically between 10-150)
params.eye.madMultipliers = {};
params.eye.madMultipliers.visual = 3;         % Related to MAD desaccading; multiplier for upper and lower threshold bounds for visual conditions
params.eye.madMultipliers.vord = 3;           % Related to MAD desaccading; multiplier for VORD segments
params.eye.madMultipliers.gap = 3;            % Related to MAD desaccading; multiplier for gap segments
params.eye.sacLength = 500;                 % NEED TO MODIFY
params.eye.neighborThresh = 200;            % NEED TO MODIFY
params.eye.isUsingSaccades = false;         % NEED TO MODIFY

params.plot.master = 0;                     % Turns on/off all plots
if params.plot.master == 0
    params.plot.eyeArtifact = 1;            % Plots separation of saccades from blinks and eyelid twitches
    params.plot.minDataCheck = 1;           % Plots data removed from not meeting params.eye.minDataLength
    params.plot.minSegLengths = 1;
    params.plot.cycAvg = 1;                 % Plots unfitted cycle averages of stimuli, eye, retinal slip, and calcium for each block and across the record
    params.plot.sinesFitting = 1;           % Plots sines-fitted cycle averages of stimuli, eye, retinal slip, and calcium for each block and across the record
    params.plot.eyeGain = 1;                % Plots eye gain relative to pretests
    params.plot.phase = 1;                  % Plots phase relationship of stimuli, eye, retinal slip, and calcium
    params.plot.calciumNorm = 1;            % Plots cycle-averaged calcium normalized by spontaneous activity
    params.plot.prePost = 1;                % Plots unfitted and sines-fitted post - pre test eye velocity
end

%%  Extract stimuli data, select and scale eye data

disp('Grab .smr file')
params.test.file = uigetfile('*.smr');
disp('Grab .csv file')

% Extracts raw calcium imaging data
try
    calcium = cell2struct(num2cell(table2array(readtable(uigetfile('*.csv'))),1), {'TimeStamps1','TimeStamps2','f','g'}, 2);
catch ME
    if strcmp(ME.identifier,'MATLAB:textio:textio:FileNotFound') || strcmp(ME.identifier,'MATLAB:textio:textio:InvalidStringProperty')
        disp('Change directory to folder with .csv file')
    end
end

[rawData,params.test.dataSubset] = importDatObject(params.test.file,0);                                % extracts raw data from .smr experimental file

stimuliVectors(1).drumPos = rawData(1,params.test.dataSubset(3)).data;                                              % drum position
stimuliVectors(1).drumVel = smooth([diff(smooth(stimuliVectors(1).drumPos,50)); 0],50) * params.test.fr;   % drum velocity
stimuliVectors(1).ttablePos = rawData(1,params.test.dataSubset(2)).data * -1;                                       % turntable position (the sign for the turntable in d019 or d241a isn't flipped properly during acquistion)
stimuliVectors(1).ttableVel = rawData(1,params.test.dataSubset(1)).data * -1;                                       % turntable velocity

if params.test.condition ~= 3
    stimuli.drumLED = [rawData(1,params.test.dataSubset(6)).data rawData(1,params.test.dataSubset(7)).data]*params.test.fr;  % drum LEDs (high and low 'events')
elseif params.test.protocol == 3                                               % Sets parameters for sriramOKRtestModAlex experimental protocol
    stimuli.drumLED = [];
end
if ~isnan(params.test.dataSubset(8))
    stimuli.fpTTL = [rawData(1,params.test.dataSubset(8)).data rawData(1,params.test.dataSubset(9)).data]*params.test.fr;    % find beginning and end timepoints of calcium imaging data in relation to Spike2 acquisition
    if isnan(stimuli(1).fpTTL(2))
        stimuli.fpTTL(2) = length(stimuliVectors(1).ttableVel);
    end
else
    stimuli(1).fpTTL = [];
end

if params.test.protocol == 3                                               % Sets parameters for sriramOKRtestModAlex experimental protocol
    if ~isempty(dir('*.txt'))
        params.test.randFileName = dir('*.txt');
    else
        params.test.randFileName = uigetfile('*.txt');                                 % extracts order of test conditions
    end
    params.test.randFile = fopen(params.test.randFileName.name);
    params.test.dataRand = textscan(params.test.randFile,'%s','delimiter','\n');
    params.test.randBlockStr = str2double(strsplit(params.test.dataRand{1}{1},','));
    params.test.numFreq = numel(unique(params.test.randBlockStr))-1;
    params.test.numTestPerFreq = round((numel(params.test.randBlockStr)-1)/params.test.numFreq);
end

%   Grab calibration file and scale eye position data
[eyeVectors,params] = scaleEyePos(rawData,params);

%%  Calculate deltaF/G

params.calcium.windowSize = calSampRate(calcium.TimeStamps1);              % window size for baseline fitting (typically should be the sampling rate)
params.calcium.f0smoothFactor = params.calcium.windowSize - 10;            % number of frames to smooth across baseline (this calculation empirically seemed ideal)

[calciumVectors] = getF0(calcium,params);                           % calculates deltaF/G

%%  Find start and end times for all test segments

if params.test.protocol == 0
    [segmentTimes,stimuli] = startStopTimes(rawData,params.test.dataSubset,params,stimuli,0);
elseif params.test.protocol == 1
    [segmentTimes,~] = startStopTimes(rawData,params.test.dataSubset,params,stimuli,1);
elseif params.test.protocol == 2
    [segmentTimes,~] = startStopTimes(rawData,params.test.dataSubset,params,stimuli,2);
elseif params.test.protocol == 3
    [segmentTimes,~] = startStopTimes(rawData,params.test.dataSubset,params,stimuli,3);
else
    [segmentTimes,stimuli] = startStopTimes(rawData,params.test.dataSubset,params,stimuli,4);
end

%% Extract number of blocks per test condition and the length (in seconds) of each block
[params] = expParams(params,segmentTimes);

%%  Mean squared error desaccading

% Remove high-frequency artifact from eye position data
eyeVectors(1).filtPos = removeTransients(eyeVectors(1).rawPos)';

% Desaccade eye velocity data
[params,eyeVectors] = desaccading(eyeVectors,params,stimuliVectors);

%% Remove non-experimental datapoints in beginning and end of vectors

eyeVectors(2) = structfun(@(x) x(stimuli(1).fpTTL(end,1):stimuli(1).fpTTL(end,end)),eyeVectors,'UniformOutput',false);
stimuliVectors(2) = structfun(@(x) x(stimuli(1).fpTTL(end,1):stimuli(1).fpTTL(end,end)),stimuliVectors,'UniformOutput',false);

%% Upsampling and desaccading calcium data

% Upsample calcium data to match sampling rate of behavioral data
calciumVectors(2) = structfun(@(x) upsampDownsamp(x,eyeVectors(2).rawVel),calciumVectors,'UniformOutput',false);

% Create expanded desaccading window to remove saccade-related fluorescence
calciumVectors(2).sacTimepts = removeAroundCenters(eyeVectors,params);

% "Desaccade" calcium data
calciumVectors(2).filtDeltaF = calciumVectors(2).deltaF;                                        % Create copy of upsampled raw calcium data
calciumVectors(2).filtDeltaF(calciumVectors(2).sacTimepts) = NaN;                               % Remove saccade-related fluorescence

%% Plot desaccaded fluorescence trace relative to desaccaded eye trace

figure('Name','"Desaccading" fluorescence check'); hold on
plot(eyeVectors(2).rawVel)
plot(eyeVectors(2).filtVel)
plot(calciumVectors(2).deltaF*1000)                                         % Arbitrary scaling by 1000 for visualization purposes
plot(calciumVectors(2).filtDeltaF*1000)                                         % Arbitrary scaling by 1000 for visualization purposes
ylim([-50 50])
legend('Raw eye vel.','Desaccaded eye vel.','Raw fluorescence','Desaccaded fluorescence')
xlabel('Time (ms)')

%% Calculate photobleaching of fluorescence across experimental record 

calcium.photobleach = {};
calcium.photobleach.f = photobleachCalc(calciumVectors(2).f,params,'Fluorescence (f)');
calcium.photobleach.g = photobleachCalc(calciumVectors(2).g,params,'Isobestic (g)');

%% Calculate retinal slip and veryify sign of stimuli

stimuliVectors = computeRetinalSlip(stimuliVectors,eyeVectors,segmentTimes,params);

%% Segment data into blocks and with respect to test conditions

[calciumMat,calciumVectors] = segmenting(calciumVectors,segmentTimes,params,1);
[eyeMat,eyeVectors] = segmenting(eyeVectors,segmentTimes,params,2);
[stimuliMat,stimuliVectors] = segmenting(stimuliVectors,segmentTimes,params,3);

if params.test.protocol == 3

    % Group tests according to condition (experiment pseudo-randomizes order)
    [params] = randBlockSort(params);

    % Eye sorting for multiple frequency experiment
    [calciumMat] = multiFreqSort(params,calciumMat,1);
    [eyeMat] = multiFreqSort(params,eyeMat,2);
    [stimuliMat] = multiFreqSort(params,stimuliMat,3);

end

%% Preprocessing for MAD and cluster desaccading

% Combine all blocks of a given test condition into single array
if params.eye.desacMethod == 1

    % Median Absolute Deviation (MAD) desaccading
    if params.test.protocol ~= 3 && params.test.expSubType ~= 1
        [eyeVectors,eyeMat,params] = madDesaccade(eyeVectors,eyeMat,params,'MAD desaccading eye vel.');

    elseif params.test.expSubType == 1
        [eyeVisualMatOut,eyeDarkMatOut,eyeGapMatOut,eyeVisualOutVector,eyeDarkOutVector,eyeGapOutVector,saccadesDarkMat,saccadesVisualMat,saccadesGapMat,upperVisual,lowerVisual,upperDark,lowerDark] = madDesac(numBlocksDark,numBlocksVisual,numBlocksGap,params.eye.madMultiplierVisual,params.eye.madMultiplierVord,params.eye.madMultiplierGap,eyeVisualMatIn,eyeDarkMatIn,eyeGapMatIn,presac,postsac,'MAD desaccading eye vel.');
        [eyeVisualMatOut2,~,~,eyeVisualOutVector2,~,~,~,saccadesVisualMat2,~,upperVisual,lowerVisual,upperDark,lowerDark] = madDesac(numBlocksDark,numBlocksVisual,numBlocksGap,params.eye.madMultiplierVisual,params.eye.madMultiplierVord,params.eye.madMultiplierGap,eyeVisualMatIn2,eyeDarkMatIn,eyeGapMatIn,presac,postsac,'MAD desaccading eye vel.');

    else
        [eyeVisualMatOut05,eyeVisualMatOut1,eyeVisualMatOut2,eyeVisualOutVector05,eyeVisualOutVector1,eyeVisualOutVector2,saccadesVisualMat1,saccadesVisualMat05,saccadesVisualMat2,upperVisual,lowerVisual,upperDark,lowerDark] = madDesac(numBlocksVisual,numBlocksVisual,numBlocksVisual,params.eye.madMultiplierVisual,params.eye.madMultiplierVord,params.eye.madMultiplierGap,eyeVisualMatIn05,eyeVisualMatIn1,eyeVisualMatIn2,presac,postsac,'MAD desaccading eye vel.');
        [eyeVisualMatOut4,eyeVisualMatOut5,eyeVisualMatOut10,eyeVisualOutVector4,eyeVisualOutVector5,eyeVisualOutVector10,saccadesVisualMat5,saccadesVisualMat4,saccadesVisualMat10,upperVisual,lowerVisual,upperDark,lowerDark] = madDesac(numBlocksVisual,numBlocksVisual,numBlocksVisual,params.eye.madMultiplierVisual,params.eye.madMultiplierVord,params.eye.madMultiplierGap,eyeVisualMatIn4,eyeVisualMatIn5,eyeVisualMatIn10,presac,postsac,'MAD desaccading eye vel.');
    end
        
% Cluster desaccading
elseif params.eye.desacMethod == 2

    [eyeMat,eyeVectors,params] = clusterDesaccading(eyeMat,eyeVectors,params,'Cluster desaccaded eye');

%     if params.calcium.desacCalcium == 0
%         params.eye.presac = params.eye.presac * 4;
%         params.eye.postsac = params.eye.postsac * 4;
%         [calciumMat,calciumVectors,params] = clusterDesaccading(calciumMat,calciumVectors,params,'Cluster desaccaded calcium');
%     end
    
end

%% Recalculate retinal slip using MAD or cluster desaccaded eye vectors

stimuliVectors = computeRetinalSlip(stimuliVectors,eyeVectors,segmentTimes,params);
[stimuliMat,stimuliVectors] = segmenting(stimuliVectors,segmentTimes,params,3);

%% Distinguishing saccades from eye blinks
% Prep
% if condition ~= 3 && protocol ~=3

%% Remove discontinuous data and blocks with too few cycles without saccades
if params.test.protocol ~= 3

    % Remove data that is not continuous for minimum amount of time
    [eyeVectors,eyeMat] = nonconDataRemoval(eyeVectors,eyeMat,params);

    % Remove blocks of data that do not contain a minimum number of good cycles
    [eyeMat,eyeVectors,stimuliMat,stimuliVectors] = minCycles(eyeMat,eyeVectors,stimuliMat,stimuliVectors,params);

end


 %% Calculate average of each block and across whole record for each condition
    
 calcium = cycAvg(calciumMat,calcium,params,1);
 eye = {};
 eye = cycAvg(eyeMat,eye,params,2);
 stimuli = cycAvg(stimuliMat,stimuli,params,3);

%% Plot cycle averages

plotCycAvgs(calcium,eye,stimuli,params)


%% Sines-fitting each block and across whole record for each condition

if params.test.sinesFitting == 0 && params.test.protocol ~= 3
    if params.test.expSubType ~= 3 && params.test.expSubType ~= 5
        [calcium] = sinesFit(calcium,params,1);
        [eye] = sinesFit(eye,params,2);
        [stimuli] = sinesFit(stimuli,params,3);

    end
end

%% Grab peak amplitudes and indices

[calcium] = peakAmps(calcium,params,1);
[eye] = peakAmps(eye,params,2);
[stimuli] = peakAmps(stimuli,params,3);

write2excel(params,calcium,eye,stimuli);





eyeVectors(1).type = 'Entire record vector';
stimuliVectors(1).type = 'Entire record vector';
calciumVectors(1).type = 'Entire record vector';
eyeVectors(2).type = 'RunExpt data (extraneous removed)';
stimuliVectors(2).type = 'RunExpt data (extraneous removed)';              % Extraneous data in the beginning and end of record is removed
calciumVectors(2).type = 'Upsampled (Raw)';
