function [calciumVectors] = getF0(calciumData,parameters) 

%   Calculates change in fluorescence divided by isobestic fluorescence
%
%   Uses 20th percentile value calculated across a sliding window
%   on the raw fluorescence
%
%   f = raw fluorescence signal
%   window = width of the sliding Window
%   f0 = baseline fluorescence
%
%   Alex Fanning, September 2019
% *************************************************************************

calciumVectors.f = calciumData.f';                                           % calcium-dependent fluorescence
calciumVectors.g = calciumData.g';                                           % isobestic fluorescence

N = length(calciumVectors.f);

% Loop through each sample to calculate f0
for i = 1:N
    dom = i-parameters.calcium.windowSize/2:i+parameters.calcium.windowSize/2;
    dom = dom(find(dom>=1 & dom<=N));
    pc = calciumVectors.f(dom);
    mi = prctile(pc,15);
    ma = prctile(pc,25);
    id = find(pc>mi & pc<ma);
    calciumVectors.f0(i) = median(pc(id));
end

calciumVectors.f0 = smooth(calciumVectors.f0,parameters.calcium.f0smoothFactor)';
calciumVectors.deltaF = ((calciumVectors.f-calciumVectors.f0)./calciumVectors.g);

% Plot f and f0 to judge goodness of fit
figure('Name','Baseline fluorescence fitting');
subplot(2,1,1)
plot(calciumVectors.f(1:end-1)); hold on
plot(calciumVectors.f0(1:end-1), 'r')
legend('F','F_0')
ylabel('F (AUs)')

% Plot deltaF/g
subplot(2,1,2)
plot(calciumVectors.deltaF(1:end-1))
ylabel('\DeltaF/G')
xlabel('Frame #')
    