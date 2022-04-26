function write2excel(parameters,calData,eyeData,stimuliData)
%
%   Creates tables in excel that contain peak amplitudes and the time of
%   their occurrence for each block of each test condition.
%
%
%   Alex Fanning, April 2020
% *************************************************************************

% File to be written to
excelDoc = [parameters.test.file(1:end-4) '_analysis.xlsx'];

numBlocks = [parameters.test.numBlocks.vord, parameters.test.numBlocks.visual, parameters.test.numBlocks.gap];

% Create cell array with relevant unfitted variables
blockAmps = {table([calData.unfitAmps(3).peakMinusTrough.vord]', [eyeData.unfitAmps(3).wholeCycleVelAmp.vord]',[stimuliData.unfitAmps(1).wholeCycleTtableVelAmp.vord]',...
    [calData.unfitAmpIdxs(3).peakIdxs.vord]', [eyeData.unfitAmpIdxs(3).ipsiIdxsVel.vord]', [eyeData.unfitAmpIdxs(3).contraIdxsVel.vord]',...
    [stimuliData.unfitAmpIdxs(1).ipsiIdxsTtableVel.vord]', [stimuliData.unfitAmpIdxs(1).contraIdxsTtableVel.vord]'),...
    table([calData.unfitAmps(3).peakMinusTrough.visual]', [eyeData.unfitAmps(3).wholeCycleVelAmp.visual]',[stimuliData.unfitAmps(1).wholeCycleTtableVelAmp.visual]',...
    [stimuliData.unfitAmps(1).wholeCycleDrumVelAmp.visual]', [stimuliData.unfitAmps(1).wholeCycleFiltRslipAmp.visual]',...
    [calData.unfitAmpIdxs(3).peakIdxs.visual]', [eyeData.unfitAmpIdxs(3).ipsiIdxsVel.visual]',[eyeData.unfitAmpIdxs(3).contraIdxsVel.visual]',...
    [stimuliData.unfitAmpIdxs(1).ipsiIdxsTtableVel.visual]', [stimuliData.unfitAmpIdxs(1).contraIdxsTtableVel.visual]',...
    [stimuliData.unfitAmpIdxs(1).ipsiIdxsDrumVel.visual]', [stimuliData.unfitAmpIdxs(1).contraIdxsDrumVel.visual]',...
    [stimuliData.unfitAmpIdxs(1).ipsiIdxsFiltRslip.visual]', [stimuliData.unfitAmpIdxs(1).contraIdxsFiltRslip.visual]')};

tabNames = {'Unfitted amps (vord)','Unfitted amps (visual)'};
blockNames = {{'deltaF/G' 'Eye vel.','Turntable vel.','peak deltaF/G idx','peak ipsi eye idx','peak contra eye idx','peak ipsi head idx', 'peak contra head idx'},...
    {'deltaF/G' 'Eye vel','Turntable vel.','Drum vel.','Rslip','peak deltaF/G idx','peak ipsi eye idx','peak contra eye idx','peak ipsi head idx', 'peak contra head idx',...
    'peak ipsi drum vel idx','peak contra drum vel idx', 'peak ipsi rSlip idx', 'peak contra rSlip idx'}};

% Iterate through each block and write the data to a table in excelDoc
for i = 1:length(blockAmps)
    blockAmps{i}.Properties.VariableNames = blockNames{i};
    writetable(blockAmps{i},excelDoc,'Sheet',tabNames{i});
end

% Create cell array with relevant sines-fitted variables
sineBlockAmps = {table([calData.sinesFitAmps(3).peakMinusTrough.vord]', [eyeData.sinesFitAmps(3).wholeCycleVelAmp.vord]',[stimuliData.sinesFitAmps(1).wholeCycleTtableVelAmp.vord]',...
    [calData.sinesFitAmpIdxs(3).peakIdxs.vord]', [eyeData.sinesFitAmpIdxs(3).ipsiIdxsVel.vord]', [eyeData.sinesFitAmpIdxs(3).contraIdxsVel.vord]',...
    [stimuliData.sinesFitAmpIdxs(1).ipsiIdxsTtableVel.vord]', [stimuliData.sinesFitAmpIdxs(1).contraIdxsTtableVel.vord]'),...
    table([calData.sinesFitAmps(3).peakMinusTrough.visual]', [eyeData.sinesFitAmps(3).wholeCycleVelAmp.visual]',[stimuliData.sinesFitAmps(1).wholeCycleTtableVelAmp.visual]',...
    [stimuliData.sinesFitAmps(1).wholeCycleDrumVelAmp.visual]', [stimuliData.sinesFitAmps(1).wholeCycleFiltRslipAmp.visual]',...
    [calData.sinesFitAmpIdxs(3).peakIdxs.visual]', [eyeData.sinesFitAmpIdxs(3).ipsiIdxsVel.visual]',[eyeData.sinesFitAmpIdxs(3).contraIdxsVel.visual]',...
    [stimuliData.sinesFitAmpIdxs(1).ipsiIdxsTtableVel.visual]', [stimuliData.sinesFitAmpIdxs(1).contraIdxsTtableVel.visual]',...
    [stimuliData.sinesFitAmpIdxs(1).ipsiIdxsDrumVel.visual]', [stimuliData.sinesFitAmpIdxs(1).contraIdxsDrumVel.visual]',...
    [stimuliData.sinesFitAmpIdxs(1).ipsiIdxsFiltRslip.visual]', [stimuliData.sinesFitAmpIdxs(1).contraIdxsFiltRslip.visual]')};

tabNames = {'Sines-fitted amps (vord)','Sines-fitted amps (visual)'};

for i = 1:length(sineBlockAmps)
    sineBlockAmps{i}.Properties.VariableNames = blockNames{i};
    writetable(sineBlockAmps{i},excelDoc,'Sheet',tabNames{i});
end

blockAvgs = {table(calData.cycAvgs(3).deltaF.vord),table(calData.cycAvgs(3).deltaF(1:numBlocks(2)).visual)};
tabNames = {'Unfitted vord block avgs', 'Unfitted visual block avgs'};

for i = 1:length(blockAvgs)
    blockNames = string(1:numBlocks(i));
    blockAvgs{i}.Properties.VariableNames = blockNames;
    writetable(blockAvgs{i},excelDoc,'Sheet',tabNames{i});
end
