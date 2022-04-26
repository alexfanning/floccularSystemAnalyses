function [parameters,eyeTrace] = desaccading(eyeTrace,parameters,stimuli)
%
%   Desaccading = removes saccades using a threshold
%   of the mean squared error (MSE) of eye velocity.
%
%   parameters.eye.velMSE = mean squared error (MSE) of the difference of raw eye
%   velocity trace minus the sinusoidal fit of raw eye velocity.
%
%   eyeTrace.sacTimepts = datapoints exceeding MSE threshold defined by user
%
%   sacmask = Expanded window to desaccade datapoints surrounding saccades
%   contained in omitCenters. The start and stop of saccades typically
%   precedes and follows those points found in omitCenters by 10-75 ms.
%
%   Alex Fanning, January 2020
% *************************************************************************

segLength = length(eyeTrace(1).filtPos);
segTime = (1:segLength)/parameters.test.fr;
eyeTrace(1).rawVel = smooth([diff(smooth(eyeTrace(1).filtPos,50)); 0],50)'*parameters.test.fr;        % Create copy of raw eye velocity

% Remove high-parameters.test.frequency data
N = 4;
fc = 15;
nq = parameters.test.fr / 2;
[bb,aa] = butter(N, fc/nq, 'low');                                          % Low-pass Buttersworth filter coefficients
eyeTrace(1).filtPos = filtfilt(bb,aa,double(eyeTrace(1).filtPos));                    % Filters eye position vector twice

% Differentiate eye position
eyeTrace(1).filtVel = smooth([diff(smooth(eyeTrace(1).filtPos,50)); 0],50)*parameters.test.fr;

%% Find best fit to raw eye velocity
y1 = sin(2*pi*parameters.test.frequency*segTime(:));
y2 = cos(2*pi*parameters.test.frequency*segTime(:));
constant = ones(segLength,1);
vars = [y1 y2 constant];
keep = abs(eyeTrace(1).filtVel) < 5*std(abs(eyeTrace(1).filtVel)) + mean(abs(eyeTrace(1).filtVel));       % Remove obvious artifact
b = regress(eyeTrace(1).filtVel(keep),vars(keep,:));                                  % Use linear regression to find best fit to eye velocity
fit1 = vars*b;

% Find mean-squared error (MSE) re best fit of eye velocity trace
parameters.eye.velMSE = (eyeTrace(1).filtVel - fit1).^2;

% Find MSE points exceeding threshold representing saccades
omitCenters = parameters.eye.velMSE > parameters.eye.saccadeThresh;

% Create expanded desaccading window to convolve with omitCenters
sacmask = ones(1,parameters.eye.presac+parameters.eye.postsac);

% Expand points around omitCenters as defined by pre & post saccade times
rejecttemp1 = conv2(double(omitCenters'),sacmask);
rejecttemp2 = rejecttemp1(parameters.eye.presac:parameters.eye.presac+length(eyeTrace(1).filtPos)-1);

% Desaccade eye velocity vector
eyeTrace(1).filtVel(logical(rejecttemp2)) = NaN;
eyeTrace(1).sacTimepts = isnan(eyeTrace(1).filtVel);

%% Include acceleration as a second parameter for removing saccade data
% eye_acc_pfilt = [diff(eyeTrace(1).rawVel); 0] * parameters.test.fr;
% parameters.eye.accelThresh = 500;
% omitCenters2 = abs(eye_acc_pfilt) > parameters.eye.accelThresh;
% rejecttemp3 = conv(double(omitCenters2),sacmask);
% rejecttemp4 = rejecttemp3(parameters.eye.presac:parameters.eye.presac+length(eyeTrace(1).filtPos)-2);
% eyeTrace(1).filtVel(logical(rejecttemp4))= NaN;
% eyeTrace(1).sacTimepts = isnan(eyeTrace(1).filtVel);
% 
% figure('Name','Filtering with acceleration')
% plot(eye_acc_pfilt)
% yline(parameters.eye.accelThresh,'k')
% xlabel('Time (ms)')
% ylabel('Acceleration')

%% Plot raw and filtered eye velocity with corresponding MSE and threshold
figure('Name','MSE desaccading')
ax1 = subplot(2,1,1);
plot(eyeTrace(1).rawVel); hold on
plot(eyeTrace(1).filtVel)
plot(eyeTrace(1).sacTimepts)
plot(stimuli.drumVel)
plot(stimuli.ttableVel)
ylim([-50 50])
legend('Raw eye vel','Desaccaded eye vel','Desaccade timepts','Drum vel.','Turntable vel.')
ylabel('Velocity')

ax2 = subplot(2,1,2);
plot(parameters.eye.velMSE,'k'); hold on
xlabel('Time (ms)')
ylabel('Eye vel MSE')
linkaxes([ax1 ax2],'x')
set(ax1,'ylim',[-50 50])
set(ax2,'ylim',[0 1000])

eyeTrace(1).accRaw = [diff(eyeTrace(1).rawVel)'; 0]'*parameters.test.fr;               % Eye acceleration vector
eyeTrace(1).sacs = eyeTrace(1).rawVel;
eyeTrace(1).sacs(~eyeTrace(1).sacTimepts) = nan;                          % Vector of only saccades

