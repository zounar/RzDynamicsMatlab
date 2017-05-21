function [ envelope ] = enveloperms( input, sample_rate, averaging )
% ENVELOPERMS - get RMS envelope of input signal (squared)
%
% Syntax: [ envelope ] = enveloperms( input, sample_rate, averaging )
% 
% Inputs:
% input             Input signal to get envelope from
% sample_rate       Sample rate of input signal
% averaging         Envelope averaging time constant (in seconds)
%
% Outputs:
% envelope          Envelope of input signal
%
% Example:
% enveloperms(input, 44100, 5e-4)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Get averaging time (for sampling period)
TAV = timebyperiod(averaging, sample_rate);

% Initialize envelope (create empty zero-filled matrix)
envelope = zeros(size(input));

% For each input sample starting from 2nd
for n=2:length(input);
    envelope(n) = TAV * (input(n))^2 + ( 1 - TAV ) * envelope(n-1);
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end