function [ output, envelope, gain_static, gain_dynamic ] = limiter(input, sidechain, sample_rate, threshold_db, attack, release, env_correction_db )
% LIMITER - process input signal by limiting it
%
% Syntax: [ output, envelope, gain_static, gain_dynamic ] = limiter(input, sidechain, sample_rate, threshold_db, attack, release, env_correction_db )
% 
% Inputs:
% input                         Input signal (time domain)
% sidechain                     Sidechain signal (time domain)
% sample_rate                   Sample rate of input signal (must be same as sidechain)
% threshold_db                  Threshold of limiter (dB)
% attack                        Limiter attack time in seconds [ envelope_time dynamic_filter_time ]
% release                       Limiter release time in seconds [ envelope_time dynamic_filter_time ]
% env_correction_db [optional]  Gain to boost envelope output (dB)
%
% Outputs:
% output                        Compressed input signal
% envelope                      Envelope of sidechain signal
% gain_static                   Gain used to compress the input (before dynamic filtering)
% gain_dynamic                  Gain used to compress the input (after dynamic filtering)
%
% Example:
% limiter(input, sidechain, 44100, [ 1e-3, 1e-2 ], [ 2e-3, 2e-2 ], -6, 6 )
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Envelope correction gain argument is optional
if nargin < 7
    env_correction_db = 0;
end;

% - - - - - - - - - - - - - - SIDECHAIN - - - - - - - - - - - - - - - -

% Get input signal envelope
envelope = envelopepeak(sidechain, sample_rate, attack(1), release(1), env_correction_db);

% Lin / log
envelope_log = log10(envelope);

% Get static gain to use for reduction (compression ratio 10000:1)
gain_static_log = gainstaticcompressor(envelope_log, threshold_db, 10000);

% Log / lin
gain_static = logtolin(gain_static_log);

% Get dynamic gain to use for reduction
gain_dynamic = gaindynamicar(gain_static, sample_rate, attack(2), release(2), 1);

% - - - - - - - - - - - - - - - VCA - - - - - - - - - - - - - - - - - -

% Reduce the signal
output = input .* gain_dynamic;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end