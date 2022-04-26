function Sn = RousseeuwCrouxSn(X)
% Compute the measure of scale 'Sn', from Rousseeuw & Croux (1993)
%
%   A robust alternative to MADn for statistical outlier identification.
%   Unlike MADn, Sn does not make an assumption of symmetry, so in
%   principle should be more robust to skewed distributions.
%
%   The outputs of this function have been validated against equivalent
%   function in Maple(tm).
%
% Example:          X = [1 5 2 2 7 4 1 5]
%                   Sn = RousseeuwCrouxSn(X) % should give 3.015
%
% Requires:         none
%
% See also:         mad.m
%
% Author(s):        Pete R Jones <petejonze@gmail.com>
% 
% Version History:  19/04/2016  PJ  Initial version
%                                               
%
% Copyright 2016 : P R Jones
% *********************************************************************
% 
    % get number of elements
    n = length(X);
      % Set c: bias correction factor for finite sample size
      if n < 10
          cc = [NaN 0.743 1.851 0.954 1.351 0.993 1.198 1.005 1.131];
          c = cc(n);
      elseif mod(n,2)==0 % is odd
          c = n/(n-.9);
      else % is even
          c = 1;
      end
      % compute median difference for each element
      tmp = nan(n,1);
      for i = 1:n
          tmp(i) = median(abs(X(i) - X([1:i-1 i+1:end])));
      end
      % compute median of median differences, and apply finite sample correction
      Sn = c * median(tmp);
 end
