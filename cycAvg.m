function dataAvgs = cycAvg(dataIn, dataAvgs, parameters, type)
%
%   Takes average of each block and of concatenated blocks (whole record)
%
%   Alex Fanning, April 2020
% *************************************************************************

% Create cell arrays that hold the relevant data
if type == 1
    dataTemp = {{struct2cell(dataIn(1).deltaF),struct2cell(dataIn(2).deltaF),struct2cell(dataIn(3).deltaF),struct2cell(dataIn(4).deltaF)},...
        {struct2cell(dataIn(1).f),struct2cell(dataIn(2).f)},...
        {struct2cell(dataIn(1).g),struct2cell(dataIn(2).g)},...
        {struct2cell(dataIn(1).f0),struct2cell(dataIn(2).f0)}};
elseif type == 2
    dataTemp = {{struct2cell(dataIn(1).pos),struct2cell(dataIn(2).pos),struct2cell(dataIn(3).pos),struct2cell(dataIn(4).pos)},...
        {struct2cell(dataIn(1).vel),struct2cell(dataIn(2).vel),struct2cell(dataIn(3).vel),struct2cell(dataIn(4).vel)},...
        {struct2cell(dataIn(1).acc),struct2cell(dataIn(2).acc)},...
        {struct2cell(dataIn(1).sacs),struct2cell(dataIn(2).sacs)}};
elseif type == 3
    dataTemp = {{struct2cell(dataIn(1).drumPos),struct2cell(dataIn(2).drumPos)},...
        {struct2cell(dataIn(1).drumVel),struct2cell(dataIn(2).drumVel)},...
        {struct2cell(dataIn(1).ttablePos),struct2cell(dataIn(2).ttablePos)},...
        {struct2cell(dataIn(1).ttableVel),struct2cell(dataIn(2).ttableVel)},...
        {struct2cell(dataIn(1).rawRslip),struct2cell(dataIn(2).rawRslip)},...
        {struct2cell(dataIn(1).filtRslip),struct2cell(dataIn(2).filtRslip)}};
end

names = {'vord', 'visual','gap'};
dataAvgs.cycAvgs = {};

% Cycle through each block of each variable
for k = 1:length(dataTemp)

    for i = 1:length(dataTemp{k})

        % Take average across all cycles of a block or the concatenated blocks
        blockTemp{k}{i} = cellfun(@(x) nanmean(x,2),dataTemp{k}{i},'UniformOutput',false);

%         plotCycAvgs(blockTemp{k}{i},parameters,names,'Calcium cycle avgs',k);
        
        % Create and store data in appropriate field
        if type == 1

            if k == 1
                dataAvgs.cycAvgs(i).deltaF = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 2
                dataAvgs.cycAvgs(i).f = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 3
                dataAvgs.cycAvgs(i).g = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 4
                dataAvgs.cycAvgs(i).f0 = cell2struct(blockTemp{k}{i},names,1);
            end

        elseif type == 2
            if k == 1
                dataAvgs.cycAvgs(i).pos = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 2
                dataAvgs.cycAvgs(i).vel = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 3
                dataAvgs.cycAvgs(i).acc = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 4
                dataAvgs.cycAvgs(i).sacs = cell2struct(blockTemp{k}{i},names,1);
            end
        elseif type == 3
            if k == 1
                dataAvgs.cycAvgs(i).drumPos = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 2
                dataAvgs.cycAvgs(i).drumVel = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 3
                dataAvgs.cycAvgs(i).ttablePos = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 4
                dataAvgs.cycAvgs(i).ttableVel = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 5
                dataAvgs.cycAvgs(i).rawRslip = cell2struct(blockTemp{k}{i},names,1);
            elseif k == 6
                dataAvgs.cycAvgs(i).filtRslip = cell2struct(blockTemp{k}{i},names,1);
            end
        end
    end
end
