function [data] = peakAmps(data,parameters,type)
%
%   Extracts peak and trough amplitudes of unfitted and sines-fitted data.
%
%   Alex Fanning, April 2020
% *************************************************************************

if type == 1
    dataTemp = {struct2cell(data.cycAvgs(1).deltaF), struct2cell(data.cycAvgs(2).deltaF), struct2cell(data.cycAvgs(3).deltaF), struct2cell(data.cycAvgs(4).deltaF)};
    sinesTemp = {struct2cell(data.sines(1).deltaF), struct2cell(data.sines(2).deltaF), struct2cell(data.sines(3).deltaF), struct2cell(data.sines(4).deltaF)};
elseif type == 2
    dataTemp = {{struct2cell(data.cycAvgs(1).pos), struct2cell(data.cycAvgs(2).pos), struct2cell(data.cycAvgs(3).pos), struct2cell(data.cycAvgs(4).pos)},...
        {struct2cell(data.cycAvgs(1).vel), struct2cell(data.cycAvgs(2).vel), struct2cell(data.cycAvgs(3).vel), struct2cell(data.cycAvgs(4).vel)}};
    sinesTemp = {{struct2cell(data.sines(1).pos), struct2cell(data.sines(2).pos), struct2cell(data.sines(3).pos), struct2cell(data.sines(4).pos)},...
        {struct2cell(data.sines(1).vel), struct2cell(data.sines(2).vel), struct2cell(data.sines(3).vel), struct2cell(data.sines(4).vel)}};
elseif type == 3
    dataTemp = {{struct2cell(data.cycAvgs(1).drumPos), struct2cell(data.cycAvgs(2).drumPos)},...
        {struct2cell(data.cycAvgs(1).drumVel), struct2cell(data.cycAvgs(2).drumVel)},...
        {struct2cell(data.cycAvgs(1).ttablePos), struct2cell(data.cycAvgs(2).ttablePos)},...
        {struct2cell(data.cycAvgs(1).ttableVel), struct2cell(data.cycAvgs(2).ttableVel)},...
        {struct2cell(data.cycAvgs(1).rawRslip), struct2cell(data.cycAvgs(2).rawRslip)},...
        {struct2cell(data.cycAvgs(1).filtRslip), struct2cell(data.cycAvgs(2).filtRslip)}};
    sinesTemp = {{struct2cell(data.sines(1).drumPos), struct2cell(data.sines(2).drumPos)},...
        {struct2cell(data.sines(1).drumVel), struct2cell(data.sines(2).drumVel)},...
        {struct2cell(data.sines(1).ttablePos), struct2cell(data.sines(2).ttablePos)},...
        {struct2cell(data.sines(1).ttableVel), struct2cell(data.sines(2).ttableVel)},...
        {struct2cell(data.sines(1).rawRslip), struct2cell(data.sines(2).rawRslip)},...
        {struct2cell(data.sines(1).filtRslip), struct2cell(data.sines(2).filtRslip)}};
end

subNames = {'vord', 'visual', 'gap'};

dataPeaks = cell(1,length(dataTemp)); sineDataPeaks = cell(1,length(dataTemp));
dataTroughs = cell(1,length(dataTemp)); sineDataTroughs = cell(1,length(dataTemp));
dataAmps = cell(1,length(dataTemp)); sineDataAmps = cell(1,length(dataTemp));
dataPeakIdxs = cell(1,length(dataTemp)); sineDataPeakIdxs = cell(1,length(dataTemp));
dataTroughIdxs = cell(1,length(dataTemp)); sineDataTroughIdxs = cell(1,length(dataTemp));
amps = cell(1,length(dataTemp)); sineAmps = cell(1,length(dataTemp));
peaks = cell(1,length(dataTemp)); sinePeaks = cell(1,length(dataTemp));
troughs = cell(1,length(dataTemp)); sineTroughs = cell(1,length(dataTemp));
peakIdxs = cell(1,length(dataTemp)); sinePeakIdxs = cell(1,length(dataTemp));
troughIdxs = cell(1,length(dataTemp)); sineTroughIdxs = cell(1,length(dataTemp));

for i = 1:length(dataTemp)
    for k = 1:length(dataTemp{i})
        if type ~= 1

            [dataPeaks{i}{k}, dataPeakIdxs{i}{k}] = cellfun(@(x) max(x),dataTemp{i}{k},"UniformOutput",false);
            [dataTroughs{i}{k}, dataTroughIdxs{i}{k}] = cellfun(@(x) min(x),dataTemp{i}{k},"UniformOutput",false);
            [sineDataPeaks{i}{k}, sineDataPeakIdxs{i}{k}] = cellfun(@(x) max(x),sinesTemp{i}{k},"UniformOutput",false);
            [sineDataTroughs{i}{k}, sineDataTroughIdxs{i}{k}] = cellfun(@(x) min(x),sinesTemp{i}{k},"UniformOutput",false);
        
            for m = 1:parameters.test.numConditions
                for j = 1:length(dataPeaks{i}{k}(m,:))
                    if type == 1
                        dataAmps{i}{k}{m,j} = dataPeaks{i}{k}{m,j} - dataTroughs{i}{k}{m,j};
                        sineDataAmps{i}{k}{m,j} = sineDataPeaks{i}{k}{m,j} - sineDataTroughs{i}{k}{m,j};
                    else
                        dataAmps{i}{k}{m,j} = (dataPeaks{i}{k}{m,j} - dataTroughs{i}{k}{m,j})/2;
                        sineDataAmps{i}{k}{m,j} = (sineDataPeaks{i}{k}{m,j} - sineDataTroughs{i}{k}{m,j})/2;
                    end
                end
            end
            
            amps{i}{k} = cell2struct(dataAmps{i}{k},subNames,1);
            peaks{i}{k} = cell2struct(dataPeaks{i}{k},subNames,1);
            troughs{i}{k} = cell2struct(dataTroughs{i}{k},subNames,1);
            peakIdxs{i}{k} = cell2struct(dataPeakIdxs{i}{k},subNames,1);
            troughIdxs{i}{k} = cell2struct(dataTroughIdxs{i}{k},subNames,1);
    
            sineAmps{i}{k} = cell2struct(sineDataAmps{i}{k},subNames,1);
            sinePeaks{i}{k} = cell2struct(sineDataPeaks{i}{k},subNames,1);
            sineTroughs{i}{k} = cell2struct(sineDataTroughs{i}{k},subNames,1);
            sinePeakIdxs{i}{k} = cell2struct(sineDataPeakIdxs{i}{k},subNames,1);
            sineTroughIdxs{i}{k} = cell2struct(sineDataTroughIdxs{i}{k},subNames,1);

        else
            [dataPeaks{i}, dataPeakIdxs{i}] = cellfun(@(x) max(x),dataTemp{i},"UniformOutput",false);
            [dataTroughs{i}, dataTroughIdxs{i}] = cellfun(@(x) min(x),dataTemp{i},"UniformOutput",false);
            [sineDataPeaks{i}, sineDataPeakIdxs{i}] = cellfun(@(x) max(x),sinesTemp{i},"UniformOutput",false);
            [sineDataTroughs{i}, sineDataTroughIdxs{i}] = cellfun(@(x) min(x),sinesTemp{i},"UniformOutput",false);
        
            for m = 1:parameters.test.numConditions
                for j = 1:length(dataPeaks{i}(m,:))
                    if type == 1
                        dataAmps{i}{m,j} = dataPeaks{i}{m,j} - dataTroughs{i}{m,j};
                        sineDataAmps{i}{m,j} = sineDataPeaks{i}{m,j} - sineDataTroughs{i}{m,j};
                    else
                        dataAmps{i}{m,j} = (dataPeaks{i}{m,j} - dataTroughs{i}{m,j})/2;
                        sineDataAmps{i}{m,j} = (sineDataPeaks{i}{m,j} - sineDataTroughs{i}{m,j})/2;
                    end
                end
            end
            
            amps{i} = cell2struct(dataAmps{i},subNames,1);
            peaks{i} = cell2struct(dataPeaks{i},subNames,1);
            troughs{i} = cell2struct(dataTroughs{i},subNames,1);
            peakIdxs{i} = cell2struct(dataPeakIdxs{i},subNames,1);
            troughIdxs{i} = cell2struct(dataTroughIdxs{i},subNames,1);
    
            sineAmps{i} = cell2struct(sineDataAmps{i},subNames,1);
            sinePeaks{i} = cell2struct(sineDataPeaks{i},subNames,1);
            sineTroughs{i} = cell2struct(sineDataTroughs{i},subNames,1);
            sinePeakIdxs{i} = cell2struct(sineDataPeakIdxs{i},subNames,1);
            sineTroughIdxs{i} = cell2struct(sineDataTroughIdxs{i},subNames,1);

        end
    
    end

end

if type == 1
    data.unfitAmps = struct('peakMinusTrough',amps,'peaks',peaks,'troughs',troughs);
    data.unfitAmpIdxs = struct('peakIdxs',peakIdxs,'troughIdxs',troughIdxs);

    data.sinesFitAmps = struct('peakMinusTrough',sineAmps,'peaks',sinePeaks,'troughs',sineTroughs);
    data.sinesFitAmpIdxs = struct('peakIdxs',sinePeakIdxs,'troughIdxs',sineTroughIdxs);
elseif type == 2
    data.unfitAmps = struct('wholeCyclePosAmp',amps{1},'ipsiPeakPos',peaks{1},'contraPeakPos',troughs{1},'wholeCycleVelAmp',amps{2},'ipsiPeakVel',peaks{2},'contraPeakVel',troughs{2});
    data.unfitAmpIdxs = struct('ipsiIdxsPos',peakIdxs{1},'ContraIdxsPos',troughIdxs{1},'ipsiIdxsVel',peakIdxs{2},'contraIdxsVel',troughIdxs{2});
    
    data.sinesFitAmps = struct('wholeCyclePosAmp',sineAmps{1},'ipsiPeakPos',sinePeaks{1},'contraPeakPos',sineTroughs{1},'wholeCycleVelAmp',sineAmps{2},'ipsiPeakVel',sinePeaks{2},'contraPeakVel',sineTroughs{2});
    data.sinesFitAmpIdxs = struct('ipsiIdxsPos',sinePeakIdxs{1},'ContraIdxsPos',sineTroughIdxs{1},'ipsiIdxsVel',sinePeakIdxs{2},'contraIdxsVel',sineTroughIdxs{2});
elseif type == 3
    data.unfitAmps = struct('wholeCycleDrumPosAmp',amps{1},'ipsiPeakDrumPos',peaks{1},'contraPeakDrumPos',troughs{1},...
        'wholeCycleDrumVelAmp',amps{2},'ipsiPeakDrumVel',peaks{2},'contraPeakDrumVel',troughs{2},...
        'wholeCycleTtablePosAmp',amps{3},'ipsiPeakTtablePos',peaks{3},'contraPeakTtablePos',troughs{3},...
        'wholeCycleTtableVelAmp',amps{4},'ipsiPeakTtableVel',peaks{4},'contraPeakTtableVel',troughs{4},...
        'wholeCycleRawRslipAmp',amps{5},'ipsiPeakRawRslip',peaks{5},'contraPeakRawRslip',troughs{5},...
        'wholeCycleFiltRslipAmp',amps{6},'ipsiPeakFiltRslip',peaks{6},'contraPeakFiltRslip',troughs{6});
    data.unfitAmpIdxs = struct('ipsiIdxsDrumPos',peakIdxs{1},'ContraIdxsDrumPos',troughIdxs{1},...
        'ipsiIdxsDrumVel',peakIdxs{2},'contraIdxsDrumVel',troughIdxs{2},...
        'ipsiIdxsTtablePos',peakIdxs{3},'contraIdxsTtablePos',troughIdxs{3},...
        'ipsiIdxsTtableVel',peakIdxs{4},'contraIdxsTtableVel',troughIdxs{4},...
        'ipsiIdxsRawRslip',peakIdxs{5},'contraIdxsRawRslip',troughIdxs{5},...
        'ipsiIdxsFiltRslip',peakIdxs{6},'contraIdxsFiltRslip',troughIdxs{6});
    
    data.sinesFitAmps = struct('wholeCycleDrumPosAmp',sineAmps{1},'ipsiPeakDrumPos',sinePeaks{1},'contraPeakDrumPos',troughs{1},...
        'wholeCycleDrumVelAmp',sineAmps{2},'ipsiPeakDrumVel',sinePeaks{2},'contraPeakDrumVel',troughs{2},...
        'wholeCycleTtablePosAmp',sineAmps{3},'ipsiPeakTtablePos',sinePeaks{3},'contraPeakTtablePos',troughs{3},...
        'wholeCycleTtableVelAmp',sineAmps{4},'ipsiPeakTtableVel',sinePeaks{4},'contraPeakTtableVel',troughs{4},...
        'wholeCycleRawRslipAmp',sineAmps{5},'ipsiPeakRawRslip',sinePeaks{5},'contraPeakRawRslip',troughs{5},...
        'wholeCycleFiltRslipAmp',sineAmps{6},'ipsiPeakFiltRslip',sinePeaks{6},'contraPeakFiltRslip',troughs{6});
    data.sinesFitAmpIdxs = struct('ipsiIdxsDrumPos',sinePeakIdxs{1},'ContraIdxsDrumPos',sineTroughIdxs{1},...
        'ipsiIdxsDrumVel',sinePeakIdxs{2},'contraIdxsDrumVel',sineTroughIdxs{2},...
        'ipsiIdxsTtablePos',sinePeakIdxs{3},'contraIdxsTtablePos',sineTroughIdxs{3},...
        'ipsiIdxsTtableVel',sinePeakIdxs{4},'contraIdxsTtableVel',sineTroughIdxs{4},...
        'ipsiIdxsRawRslip',sinePeakIdxs{5},'contraIdxsRawRslip',sineTroughIdxs{5},...
        'ipsiIdxsFiltRslip',sinePeakIdxs{6},'contraIdxsFiltRslip',sineTroughIdxs{6});
    
end
