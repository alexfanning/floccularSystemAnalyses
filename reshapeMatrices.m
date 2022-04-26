function [dataVecOutput,dataMatOutput] = reshapeMatrices(parameters,dataMats,type)
%
%   Takes each matrix and converts the data into a vector, then it reshapes
%       the vector back into a matrix using the proper frequency for each
%       test.
%
%   Alex Fanning, March 2021
% *************************************************************************

% Create cell arrays with the data matrices of the proper type (i.e. calcium, eye, or stimuli)

if type == 1
    dataVecs = {dataMats.deltaF.raw.newVisual; dataMats.deltaF.desaccaded.newVisual; dataMats.f.raw.newVisual;...
        dataMats.g.raw.newVisual; dataMats.f0.raw.newVisual};
elseif type == 2
    dataVecs = {dataMats.pos.raw.newVisual; dataMats.pos.desaccaded.newVisual; dataMats.vel.raw.newVisual;...
        dataMats.vel.desaccaded.newVisual; dataMats.acc.raw.newVisual; dataMats.sacs.raw.newVisual};
elseif type == 3
    dataVecs = {dataMats.drum.pos.newVisual; dataMats.drum.vel.newVisual; dataMats.ttable.pos.newVisual;...
        dataMats.ttable.vel.newVisual; dataMats.rSlip.raw.newVisual; dataMats.rSlip.desaccaded.newVisual};
end

%% Convert each matrix into a vector and then back into a matrix

freq = [0.5 1 2 4 0.5 0.5];
for t = 1:length(dataVecs)
    dataInputStruct = struct2cell(dataVecs{t});
    for i = 1:length(dataInputStruct)
        dataInputCell = dataInputStruct{i};
        for m = 1:length(parameters.test.conditionIdxs{i})
            dataInput = {dataInputCell{m}};
            dataVectors{t,i}(m) = cellfun(@(x) x(:),dataInput,'UniformOutput',false);
            dataMatsTemp{t,i}{m} = reshape(dataVectors{t,i}{m},parameters.test.fr*1/freq(i),parameters.test.numTime.visual*freq(i));
        end
    end
end

%% Convert cell arrays back into structure arrays

if type == 1
    fields = {'deltaFraw','deltaFdesaccaded', 'f', 'g', 'f0'};
elseif type == 2
    fields = {'posRaw','posDesaccaded', 'velRaw', 'velDesaccaded', 'accRaw', 'sacsRaw'};
elseif type == 3
    fields = {'drumPos','drumVel', 'ttablePos', 'ttableVel', 'rSlipRaw', 'rSlipDesaccaded'};
end

dataVecOutput = cell2struct(dataVectors,fields,1);
dataMatOutput = cell2struct(dataMatsTemp,fields,1);
