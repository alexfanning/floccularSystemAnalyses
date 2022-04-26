function [data] = sinesFit(data,parameters,type)
%
%   Fits a sinusoid to block averages or a concatenated blocks average.
%
%   sinesOffset = shifts the sinusoid according to any asymmetries in eye
%   movement.
%
%   Alex Fanning, March 2020
% *************************************************************************

% Grab the approrpiate data to iterate through
if type == 1
    dataTemp = {{struct2cell(data.cycAvgs(1).deltaF), struct2cell(data.cycAvgs(2).deltaF), struct2cell(data.cycAvgs(3).deltaF), struct2cell(data.cycAvgs(4).deltaF)}...
        {struct2cell(data.cycAvgs(1).f), struct2cell(data.cycAvgs(2).f)}...
        {struct2cell(data.cycAvgs(1).g), struct2cell(data.cycAvgs(2).g)}...
        {struct2cell(data.cycAvgs(1).f0), struct2cell(data.cycAvgs(2).f0)}};
elseif type == 2
    dataTemp = {{struct2cell(data.cycAvgs(1).pos), struct2cell(data.cycAvgs(2).pos), struct2cell(data.cycAvgs(3).pos), struct2cell(data.cycAvgs(4).pos)}...
        {struct2cell(data.cycAvgs(1).vel), struct2cell(data.cycAvgs(2).vel), struct2cell(data.cycAvgs(3).vel), struct2cell(data.cycAvgs(4).vel)}};
elseif type == 3
    dataTemp = {{struct2cell(data.cycAvgs(1).drumPos), struct2cell(data.cycAvgs(2).drumPos)}...
        {struct2cell(data.cycAvgs(1).drumVel), struct2cell(data.cycAvgs(2).drumVel)}...
        {struct2cell(data.cycAvgs(1).ttablePos), struct2cell(data.cycAvgs(2).ttablePos)}...
        {struct2cell(data.cycAvgs(1).ttableVel), struct2cell(data.cycAvgs(2).ttableVel)}...
        {struct2cell(data.cycAvgs(1).rawRslip), struct2cell(data.cycAvgs(2).rawRslip)}...
        {struct2cell(data.cycAvgs(1).filtRslip), struct2cell(data.cycAvgs(2).filtRslip)}};
end

names = {'vord', 'visual','gap'};

% Create empty cell arrays to hold data
phase = cell(length(dataTemp),1);
sine = cell(length(dataTemp),1);
offset = cell(length(dataTemp),1);

% Iterate through each block average and concatenated blocks average for
% each relevant variable according to test condition.
for i = 1:length(dataTemp)

    for m = 1:length(dataTemp{i})

        for k = 1:parameters.test.numConditions
            
            for j = 1:size(dataTemp{i}{m},2)
    
                % Create a sinusoidal trace confined to the experiments parameters

                segLength = size(dataTemp{i}{m}{k,j},1);
                segTime = (1:segLength)/parameters.test.fr;
                y1 = sin(2*pi*parameters.test.frequency*segTime(:));
                y2 = cos(2*pi*parameters.test.frequency*segTime(:));
                constant = ones(segLength,1);
                vars = [y1 y2 constant];
         
                % Find best fit sinusoid, amplitude, and phase measures

                offset{i}{m}{k,j} = nanmean(dataTemp{i}{m}{k,j});
                b = regress(dataTemp{i}{m}{k,j},vars);
                amp = sqrt(b(1)^2+b(2)^2);
                phase{i}{m}{k,j} = rad2deg(atan2(b(2),b(1)));
                sine{i}{m}{k,j} = (sin(2*pi*parameters.test.frequency*segTime + deg2rad(phase{i}{m}{k,j}))*amp)+offset{i}{m}{k,j};
            end
        end

        % Convert cell arrays to structure arrays and store in relevant array
        if type == 1

            % Calcium variables
            if i == 1
                data.sines(m).deltaF = cell2struct(sine{i}{m},names,1);
                data.phase(m).deltaF = cell2struct(phase{i}{m},names,1);
                data.offset(m).deltaF = cell2struct(offset{i}{m},names,1);
            elseif i == 2
                data.sines(m).f = cell2struct(sine{i}{m},names,1);
                data.phase(m).f = cell2struct(phase{i}{m},names,1);
                data.offset(m).f = cell2struct(offset{i}{m},names,1);
            elseif i == 3
                data.sines(m).g = cell2struct(sine{i}{m},names,1);
                data.phase(m).g = cell2struct(phase{i}{m},names,1);
                data.offset(m).g = cell2struct(offset{i}{m},names,1);
            elseif i == 4
                data.sines(m).f0 = cell2struct(sine{i}{m},names,1);
                data.phase(m).f0 = cell2struct(phase{i}{m},names,1);
                data.offset(m).f0 = cell2struct(offset{i}{m},names,1);
            end

        elseif type == 2

            % Eye variables
            if i == 1
                data.sines(m).pos = cell2struct(sine{i}{m},names,1);
                data.phase(m).pos = cell2struct(phase{i}{m},names,1);
                data.offset(m).pos = cell2struct(offset{i}{m},names,1);
            elseif i == 2
                data.sines(m).vel = cell2struct(sine{i}{m},names,1);
                data.phase(m).vel = cell2struct(phase{i}{m},names,1);
                data.offset(m).vel = cell2struct(offset{i}{m},names,1);
            end

        elseif type == 3

            % Stimuli variables
            if i == 1
                data.sines(m).drumPos = cell2struct(sine{i}{m},names,1);
                data.phase(m).drumPos = cell2struct(phase{i}{m},names,1);
                data.offset(m).drumPos = cell2struct(offset{i}{m},names,1);
            elseif i == 2
                data.sines(m).drumVel = cell2struct(sine{i}{m},names,1);
                data.phase(m).drumVel = cell2struct(phase{i}{m},names,1);
                data.offset(m).drumVel = cell2struct(offset{i}{m},names,1);
            elseif i == 3
                data.sines(m).ttablePos = cell2struct(sine{i}{m},names,1);
                data.phase(m).ttablePos = cell2struct(phase{i}{m},names,1);
                data.offset(m).ttablePos = cell2struct(offset{i}{m},names,1);
            elseif i == 4
                data.sines(m).ttableVel = cell2struct(sine{i}{m},names,1);
                data.phase(m).ttableVel = cell2struct(phase{i}{m},names,1);
                data.offset(m).ttableVel = cell2struct(offset{i}{m},names,1);
            elseif i == 5
                data.sines(m).rawRslip = cell2struct(sine{i}{m},names,1);
                data.phase(m).rawRslip = cell2struct(phase{i}{m},names,1);
                data.offset(m).rawRslip = cell2struct(offset{i}{m},names,1);
            elseif i == 6
                data.sines(m).filtRslip = cell2struct(sine{i}{m},names,1);
                data.phase(m).filtRslip = cell2struct(phase{i}{m},names,1);
                data.offset(m).filtRslip = cell2struct(offset{i}{m},names,1);
            end

        end

    end
    
end
