function [ gain_static ] = gainstaticcompressor( envelope_log, threshold_db, ratio )
% GAINSTATICCOMPRESSOR - get compressor static gain
%
% Syntax: [ gain_static ] = gainstaticcompressor( envelope_log, threshold_db, ratio )
% 
% Inputs:
% envelope_log          Input signals envelope (log)
% threshold_log         Filter threshold (dB)
% ratio                 Compressor ratio
%
% Outputs:
% gain_static           Gain reduction function of input envelope
%
% Example:
% gainstatic(input_envelope_log, -6, 2)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Convert ratio to slope
slope_log = ratiotoslope(ratio);
% Convert threshold dB to log
threshold_log = threshold_db / 20;

% Initialize static gain (create empty zero-filled matrix)
gain_static = zeros(size(envelope_log));

% For each sample
for n=1:length(envelope_log);
    % If signal is above threshold
    if ( envelope_log(n) > threshold_log )
        gain_static(n) =  slope_log * (threshold_log - envelope_log(n));
    end;
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end