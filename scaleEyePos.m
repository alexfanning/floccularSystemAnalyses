function [eyeVecs,parameters] = scaleEyePos(data,parameters)

parameters.eye.cali = {};
if ~isempty(dir('*analysis.mat'))
    parameters.eye.cali.file = dir('*analysis.mat');
    parameters.eye.cali.fileName = parameters.eye.cali.file.name;
else
    disp('Move to directory with calibration file')
    parameters.eye.cali.directory = uigetdir;
    cd(parameters.eye.cali.directory);
    if ~isempty(dir('*analysis.mat'))
        parameters.eye.cali.file = dir('*analysis.mat');
    else
        parameters.eye.cali.file = uigetfile('*.mat');
    end
    parameters.eye.cali.fileName = parameters.eye.cali.file.name;
    parameters.eye.cali.prompt = 'Scaling factor 1: ';                      % Corresponds to channel 5 in .smr
    parameters.eye.cali.prompt2 = 'Scaling factor 2: ';                     % Corresponds to channel 6
end

if parameters.eye.cali.fileName > 0
    parameters.eye.cali = load(parameters.eye.cali.fileName);
    if parameters.eye.cali.mag1.vel_fitr2 > parameters.eye.cali.mag2.vel_fitr2                  % Find eye channel with greater r-squared value
        parameters.eye.cali.sf = parameters.eye.cali.mag1.vel_scale;
        eyeVecs(1).rawPos = data(1,parameters.test.dataSubset(4)).data * parameters.eye.cali.sf;
    else
        parameters.eye.cali.sf = parameters.eye.cali.mag2.vel_scale;
        eyeVecs(1).rawPos = data(1,parameters.test.dataSubset(5)).data * parameters.eye.cali.sf;
    end
    eyeVecs(1).rawPos = detrend(eyeVecs(1).rawPos);                               % Removes best straight-fit line from data
else
    parameters.eye.cali.sf = input(parameters.eye.cali.prompt);
    if parameters.eye.cali.sf ~= 0
        eyeVecs(1).rawPos = data(1,parameters.test.dataSubset(4)).data * parameters.eye.cali.sf;
    else
        parameters.eye.cali.sf = input(parameters.eye.cali.prompt2);
        eyeVecs(1).rawPos = data(1,parameters.test.dataSubset(5)).data * parameters.eye.cali.sf;
    end
    eyeVecs(1).rawPos = detrend(eyeVecs(1).rawPos);
end
