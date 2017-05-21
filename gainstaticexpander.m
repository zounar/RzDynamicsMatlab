function [ gain_static ] = gainstaticexpander(input_envelope_log, threshold_db, ratio, range_db )
% GAINSTATICCOMPRESSOR - get expander static gain
%
% Syntax: [ gain_static ] = gainstaticexpander(input_envelope_log, threshold_db, ratio, range_db )
% 
% Inputs:
% input_envelope_log    Input signal envelope (log)
% threshold_db          Filter threshold level (dB)
% ratio                 Expander ratio
% range_db   [optional] Filter range
%
% Outputs:
% gain_static           Gain reduction function of input envelope
%
% Example:
% gainstaticexpander(input_envelope_log, -20, 0.5, -20)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Range_db argument is optional
if nargin < 5
    range_db = -72;
end;

% Protection from division by zero
if ratio == 1
    ratio = 0.999999999999999;
end;

% Convert threshold from dB to log
threshold_log = threshold_db / 20;
% Convert ratio to slope
slope_log = ratiotoslope(ratio);
% Convert range fomm dB to log
range_log = range_db / 20;
% Count bottom threshold level
threshold_log_bottom = (threshold_log - (range_log + threshold_log)/ratio ) / slope_log - range_log;

% Initialize static gain (create empty zeros-filled matrix)
gain_static = zeros(size(input_envelope_log));

% For each input signal sample
for n=1:length(input_envelope_log)
    % If signal is under threshold
    if( input_envelope_log(n) < threshold_log )
        % If signal is above bottom threshold (is in range of expanding)
        if( input_envelope_log(n) > threshold_log_bottom )
            gain_static(n) = slope_log * (threshold_log - input_envelope_log(n));
        else
            gain_static(n) = range_log;
        end;
    end;
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end