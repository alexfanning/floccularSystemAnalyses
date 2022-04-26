function calciumData = photobleachCalc(calVecs,parameters,type)
%
%   Determines percentage of photobleaching from beginning to end of
%       record. Calculates mean raw fluorescence (f) or isobestic
%       fluorescence (g) for first and last 5 seconds of acquisition
%
%   Alex Fanning, December 2019
% *************************************************************************

tempData = cell(4,1);
tempData{1} = type;
tempData{2} = mean(calVecs(1:parameters.test.fr*5));
tempData{3} = mean(calVecs(end-(parameters.test.fr*5)+1:end));
tempData{4} = -(1-(tempData{3}/tempData{2}))*100;

names = {'Type','Initial','Last','PctChange'};
calciumData = cell2struct(tempData,names,1);