function [data,dataSubset] = importDatObject(file,version)
%
%   Imports raw data from .smr experimental file
%
%   Need importSpike.m and readSpikeFile.m to run
%
%   For data collected from new rigs in d243a or d243b, spike2 characterizes
%   readouts of the stimuli as 'event' channels and/or had the wrong sampling
%   rate. Code was inserted here to upsample those data and/or
%   extract the 'continuous' raw data by adding code to importSpike.m
%   
%
%   Alex Fanning, September 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chanList = readSpikeFile(fullfile(file),[]);
chanIndAll = [chanList.number];
[data,dataDrumVel,dataDrumPos,dataChairVel,dataChairPos] = importSpike(fullfile(file),chanIndAll(:));
idxs = NaN(1,length(data));
for i = 1:length(data)
    idxs(i) = data(1,i).chanval;
end

%for data gathered from new rigs in d243a or d243b, spike
if version ~= 0
    if version == 2
        dataDrumNew = upsampDownsamp(dataDrumVel,data(5).data);
        dataChairVelNew = upsampDownsamp(dataChairVel,data(5).data);
        dataDrumPosNew = upsampDownsamp(dataDrumPos,data(5).data);
        dataChairPosNew = upsampDownsamp(dataChairPos,data(5).data);
    end
    
    data(7).data = dataDrumNew;
    data(8).data = dataChairVelNew;
    data(3).data = dataDrumPosNew;
    data(4).data = dataChairPosNew;

    drumVind = find(idxs==7);
end

chVind = find(idxs==8);
chPind = find(idxs==4);
drumPind = find(idxs==3);
eyeCh1ind = find(idxs==5);
eyeCh2ind = find(idxs==6);
LEDidxs = find(idxs==9);
if isempty(LEDidxs)
    LEDidxs = find(idxs==10);
end
keystrokes = find(idxs==31);
fpIdxs = find(idxs==15);

if ~isempty(LEDidxs) && ~isempty(fpIdxs) && version == 0
    dataSubset = [chVind chPind drumPind eyeCh1ind eyeCh2ind LEDidxs(1) LEDidxs(2) fpIdxs(1) fpIdxs(2) keystrokes];
elseif isempty(fpIdxs) && version == 0
    dataSubset = [chVind chPind drumPind eyeCh1ind eyeCh2ind LEDidxs(1) LEDidxs(2) NaN NaN keystrokes];
elseif version ~= 0
    dataSubset = [chVind chPind drumPind eyeCh1ind eyeCh2ind LEDidxs(1) LEDidxs(2) fpIdxs(1) fpIdxs(2) drumVind keystrokes];
else
    dataSubset = [chVind chPind drumPind eyeCh1ind eyeCh2ind NaN NaN fpIdxs(1) fpIdxs(2) keystrokes];
end
