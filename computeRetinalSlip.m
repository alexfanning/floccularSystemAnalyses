function [stimuli] = computeRetinalSlip(stimuli,eyeTraces,startStopTimes,parameters)
%
%   Computes raw and desaccaded retinal slip
%
%   Verifies the sign of the stimuli according to condition, corrects if
%   erroneous, and then calculates image motion.
%
%   Alex Fanning, January 2020
% *************************************************************************

if parameters.test.condition == 0
    if stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0
        stimuli(2).rawRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel*-1 + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel*-1 + eyeTraces(2).filtVel);
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0
        stimuli(2).rawRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).filtVel);
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0
        stimuli(2).rawRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel + eyeTraces(2).filtVel);
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0
        stimuli(2).rawRslip = stimuli(2).drumVel - (stimuli(2).ttableVel*-1 + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel - (stimuli(2).ttableVel*-1 + eyeTraces(2).filtVel);
    end
elseif parameters.test.condition == 1
    if stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0
        stimuli(2).rawRslip = stimuli(2).drumVel - (stimuli(2).ttableVel*-1 + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel - (stimuli(2).ttableVel*-1 + eyeTraces(2).filtVel);
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0
        stimuli(2).rawRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel + eyeTraces(2).filtVel);
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0
        stimuli(2).rawRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).filtVel);
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0 && stimuli(2).ttableVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0
        stimuli(2).rawRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel*-1 + eyeTraces(2).rawVel');
        stimuli(2).filtRslip = stimuli(2).drumVel*-1 - (stimuli(2).ttableVel*-1 + eyeTraces(2).filtVel);
    end
elseif parameters.test.condition == 2 && parameters.test.protocol ~= 3 && parameters.test.protocol ~= 2
    if stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0
        stimuli(2).rawRslip = stimuli(2).drumVel - eyeTraces(2).rawVel';
        stimuli(2).filtRslip = stimuli(2).drumVel - eyeTraces(2).filtVel;
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(1).gap(1))+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0
        stimuli(2).rawRslip = stimuli(2).drumVel*-1 - eyeTraces(2).rawVel';
        stimuli(2).filtRslip = stimuli(2).drumVel*-1 - eyeTraces(2).filtVel;
    end
elseif parameters.test.condition == 2 && parameters.test.protocol == 3
    if stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(3).gap)+(((1/parameters.test.frequency)*parameters.test.fr))/4) > 0
        stimuli(2).rawRslip = stimuli(2).drumVel - eyeTraces(2).rawVel';
        stimuli(2).filtRslip = stimuli(2).drumVel - stimuli(2).ttableVel + eyeTraces(2).filtVel;
    elseif stimuli(2).drumVel((startStopTimes(1).visual(1)-startStopTimes(3).gap)+(((1/parameters.test.frequency)*parameters.test.fr))/4) < 0
        stimuli(2).rawRslip = stimuli(2).drumVel*-1 - eyeTraces(2).rawVel';
        stimuli(2).filtRslip = stimuli(2).drumVel*-1 - eyeTraces(2).filtVel;
    end
elseif parameters.test.condition == 2 && parameters.test.protocol == 2
    stimuli(2).rawRslip = stimuli(2).drumVel - eyeTraces(2).rawVel';
    stimuli(2).filtRslip = stimuli(2).drumVel - eyeTraces(2).filtVel;
elseif parameters.test.condition == 4
    stimuli(2).rawRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).rawVel');
    stimuli(2).filtRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).filtVel);
else
    stimuli(2).rawRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).rawVel');
    stimuli(2).filtRslip = stimuli(2).drumVel - (stimuli(2).ttableVel + eyeTraces(2).filtVel);
end