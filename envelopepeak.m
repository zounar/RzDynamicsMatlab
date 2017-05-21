function [ envelope ] = envelopepeak( input, sample_rate, attack, release, env_correction_db )
% ENVELOPEPEAK - get peak envelope of input signal
%
% Syntax: [ envelope ] = envelopepeak( input, sample_rate, attack, release, env_correction_db )
% 
% Inputs:
% input                         Input signal to get envelope from
% sample_rate                   Sample rate of input signal
% attack                        Envelope attack time (in seconds)
% release                       Envelope release time (in seconds)
% env_correction_db [optional]  Gain to boost envelope output (in dB)
%
% Outputs:
% envelope          Peak envelope of input signal
%
% Example:
% envelopepeak(input, 44100, 5e-3, 5e-2, 6)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Last argument is optional
if nargin < 5
    env_correction_db = 0;
end;

% Convert envelope correction dB to linear
env_correction = dbtolin(env_correction_db);
% Get attack time (for sampling period)
AT = timebyperiod(attack, sample_rate);
% Get release time (for sampling period)
RT = timebyperiod(release, sample_rate);

% Initialize envelope (create empty zero-filled matrix)
envelope = zeros(size(input));

% Get rectified input
input_abs = abs(input);

% For each input sample starting from 2nd
for n=2:length(input);
    % If signal is above the previous envelope sample level
    if(input_abs(n) > envelope(n - 1))
        envelope(n) = AT * input_abs(n) + (1 - AT - RT) * envelope(n - 1);
    else
        envelope(n) = (1 - RT) * envelope(n - 1);
    end;
end;

% Envelope correction
envelope = env_correction .* envelope;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end