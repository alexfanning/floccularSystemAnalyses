function [startEndTimes,stimuli] = startStopTimes(varargin)
%
%   startStopTimes = finds the start and stop time of each test in the
%   experimental record.
%
%   SampKeys = extracts the sample keys which correspond to some sequencer
%   command(s) that define(s) a test or gap period.
%
%   SampKeyTimes = the corresponding timepoints for each sample key
%   extracted in SampKeys.
%
%   Includes extraction for the default protocol (0), an older version of
%   the default protocol (1), Sriram's OKR training protocol (2),
%   Sriram's multiple frequency OKR protocol (3), and Alex's OKR training
%   VORD tests protocol (4).
%
%   Alex Fanning, October 2019
% *************************************************************************

startEndTimes(1).type = 'start times';
startEndTimes(2).type = 'end times';
% Default experimental protocol
if varargin{end} == 0
    SampKeys = strcat(varargin{1}(varargin{2}(end)).samplerate(any(varargin{1}(varargin{2}(end)).samplerate == ['H' 'x' 'S' 's' 'L' 'X' 'h'], 2))');
    SampKeyTimes = round(varargin{1}(varargin{2}(end)).data(any(varargin{1}(varargin{2}(end)).samplerate == ['H' 'x' 'S' 's' 'L' 'X' 'h'], 2))*varargin{3}.test.fr)';

    startEndTimes(1).vord = SampKeyTimes(strfind(SampKeys, 'XS'));
    startEndTimes(2).vord = SampKeyTimes(strfind(SampKeys, 'XSx')+2);
    startEndTimes(1).visual = SampKeyTimes(strfind(SampKeys, 'XL'));
    startEndTimes(2).visual = SampKeyTimes(strfind(SampKeys, 'XLxs')+3);
    startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'xss'));
    if isempty('startEndTimes(1).gap')
        startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'xssL'));
    end
    startEndTimes(2).gap = SampKeyTimes(strfind(SampKeys, 'sX')+1);
    startRec = SampKeyTimes(strfind(SampKeys, 'H'));
    endRec = SampKeyTimes(strfind(SampKeys, 'h'));
    stimuli = varargin{4};
    if isnan(varargin{2}(8)) || stimuli.fpTTL(1) < 0
        stimuli.fpTTL(1) = startRec(end);
        stimuli.fpTTL(1,2) = endRec(end);
    end

    if numel(stimuli.fpTTL) == 4
        if isnan(stimuli.fpTTL(2,2))
            stimuli.fpTTL(2,2) = length(varargin{1}(1).data);
        end
        for i = 1:length(startEndTimes(1).gap)
            if startEndTimes(1).gap(i) < stimuli.fpTTL(2)
                startEndTimes(1).gap(i) = NaN;
            end
        end
        startEndTimes(1).gap = startEndTimes(1).gap(~isnan(startEndTimes(1).gap));
    end
% Old default experimental protocol
elseif varargin{end} == 1
    SampKeys = strcat(varargin{1}(varargin{2}(end)).samplerate(any(varargin{1}(varargin{2}(end)).samplerate == ['x' 'S' 's' 'L' 'X'], 2))');
    SampKeyTimes = round(varargin{1}(varargin{2}(end)).data(any(varargin{1}(varargin{2}(end)).samplerate == ['x' 'S' 's' 'L' 'X'], 2))*varargin{3}.test.fr)';

    startEndTimes(1).vord = SampKeyTimes(strfind(SampKeys, 'S'));
    endPrePostVord = SampKeyTimes(strfind(SampKeys, 'Ss')+1);
    endTrainVord = SampKeyTimes(strfind(SampKeys, 'SL')+1);
    startEndTimes(1).visual = SampKeyTimes(strfind(SampKeys, 'LssLS'));
    startEndTimes(2).visual = SampKeyTimes(strfind(SampKeys, 'LssLS')+1);
    startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'ssLS'));
    startEndTimes(2).gap = SampKeyTimes(strfind(SampKeys, 'ssLS')+3);
    startEndTimes(2).vord = sort([endPrePostVord endTrainVord]);
    stimuli = varargin{4};
% Sriram's OKR training protocol
elseif varargin{end} == 2
    SampKeys = strcat(varargin{1}(varargin{2}(end)).samplerate(any(varargin{1}(varargin{2}(end)).samplerate == ['x' 'S' 's' 'L' 'X'], 2))');
    SampKeyTimes = round(varargin{1}(varargin{2}(end)).data(any(varargin{1}(varargin{2}(end)).samplerate == ['x' 'S' 's' 'L' 'X'], 2))*varargin{3}.test.fr)';

    startEndTimes(1).vord = SampKeyTimes(strfind(SampKeys, 'XS'));
    startEndTimes(2).vord = SampKeyTimes(strfind(SampKeys, 'XSx')+2);
    startEndTimes(1).visual = SampKeyTimes(strfind(SampKeys, 'XL'));
    startEndTimes(2).visual = SampKeyTimes(strfind(SampKeys, 'XLSxs')+4);
    startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'xss'));
    if length(startEndTimes(2).vord) > 4
        startEndTimes(2).gap = SampKeyTimes(strfind(SampKeys, 'xssX')+3);
    else
        startEndTimes(2).gap = SampKeyTimes(strfind(SampKeys, 'xssLX')+4);
    end
    stimuli = varargin{4};
% Sriram's multiple frequency OKR protocol
elseif varargin{end} == 3
    SampKeys = strcat(varargin{1}(varargin{2}(end)).samplerate(any(varargin{1}(varargin{2}(end)).samplerate == ['t' 'S' 's' 'L' 'H' 'h'], 2))');
    SampKeyTimes = round(varargin{1}(varargin{2}(end)).data(any(varargin{1}(varargin{2}(end)).samplerate == ['t' 'S' 's' 'L' 'H' 'h'], 2))*varargin{3}.test.fr)';
    startSineL = SampKeyTimes(strfind(SampKeys, 'S'));
    endSineL = SampKeyTimes(strfind(SampKeys, 'Ss')+1);
    startStepL = SampKeyTimes(strfind(SampKeys, 't'));
    endStepL = SampKeyTimes(strfind(SampKeys, 'ts')+1);
    startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'sLL'));
    startGapOther = SampKeyTimes(strfind(SampKeys, 'sLs'));
    startEndTimes(3).gap = SampKeyTimes(strfind(SampKeys, 'H'));
    startEndTimes(2).gap = SampKeyTimes(strfind(SampKeys, 'sLL')+2);
    endRec = SampKeyTimes(strfind(SampKeys, 'h'));
    startEndTimes(1).visual = sort([startSineL startStepL]);
    startEndTimes(2).visual = sort([endSineL endStepL]);
    startEndTimes(1).vord = [];
    startEndTimes(2).vord = [];
    startEndTimes(1).gap = [startEndTimes(1).gap startGapOther];
    startEndTimes(2).gap = [startEndTimes(2).gap endRec];
    stimuli = varargin{4};
% Alex's OKR training with VORD tests protocol
elseif varargin{end} == 4
    SampKeys = strcat(varargin{1}(varargin{2}(end)).samplerate(any(varargin{1}(varargin{2}(end)).samplerate == ['x' 'S' 's' 'L' 'X'], 2))');
    SampKeyTimes = round(varargin{1}(varargin{2}(end)).data(any(varargin{1}(varargin{2}(end)).samplerate == ['x' 'S' 's' 'L' 'X'], 2))*varargin{3}.test.fr)';

    startEndTimes(1).vord = SampKeyTimes(strfind(SampKeys, 'XS'));
    startEndTimes(2).vord = SampKeyTimes(strfind(SampKeys, 'XSx')+2);
    startEndTimes(1).visual = SampKeyTimes(strfind(SampKeys, 'XL'));
    startEndTimes(2).visual = SampKeyTimes(strfind(SampKeys, 'XLSxs')+4);
    startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'xss'));
    if isempty('startTimes.gap')
        startEndTimes(1).gap = SampKeyTimes(strfind(SampKeys, 'xssL'));
    end
    startEndTimes(2).gap = SampKeyTimes(strfind(SampKeys, 'sX')+1);
    
    stimuli = varargin{4};
    stimuli.fpTTL = stimuli.fpTTL;
    if numel(stimuli.fpTTL) == 4
        for i = 1:length(startTimes.gap)
            if startEndTimes(1).gap(i) < stimuli.fpTTL(2)
                startEndTimes(1).gap(i) = NaN;
            end
        end
        startEndTimes(1).gap = startEndTimes(1).gap(~isnan(startEndTimes(1).gap));
    end
end
