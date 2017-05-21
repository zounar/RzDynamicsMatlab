function [ output, envelope, gain_static, gain_dynamic ] = noisegate(input, sidechain, sample_rate, threshold_db, averaging, attack, release, hold )
% NOISEGATE - process input signal by gating it
%
% Syntax: [ output, envelope, gain_static, gain_dynamic ] = noisegate(input, sidechain, sample_rate, threshold_db, averaging, attack, release, hold )
% 
% Inputs:
% input                 Input signal (time domain)
% sidechain             Sidechain signal (time domain)
% sample_rate           Sample rate of input signal (must be same as sidechain)
% threshold_db          Threshold for closing the gate
% averaging             Envelope detector averaging time constant in seconds
% attack                Attack time in seconds
% release               Release time in seconds
% hold                  Hold time in seconds
%
% Outputs:
% output                Compressed input signal
% envelope              Envelope of sidechain signal
% gain_static           Gain used to compress the input (before dynamic filtering)
% gain_dynamic          Gain used to compress the input (after dynamic filtering)
%
% Example:
% noisegate(input_signal, sidechain_signal, 44100, -40, 5-e3, 5e-2, 5e-1, 5e-2)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -



% - - - - - - - - - - - - - - SIDECHAIN - - - - - - - - - - - - - - - -

% Get input signal envelope
envelope_square = enveloperms(sidechain, sample_rate, averaging);

% Lin^2 / log
envelope_log = log10(envelope_square) / 2;

% Get static gain to use for reduction
gain_static_log = gainstaticexpander(envelope_log, threshold_db, 0.000001);

% Log / lin
gain_static = logtolin(gain_static_log);

% Get dynamic gain to use for reduction
gain_dynamic = gaindynamicarh(gain_static, sample_rate, attack, release, hold);

% - - - - - - - - - - - - - - - VCA - - - - - - - - - - - - - - - - - -

% Gate the signal
output = input .* gain_dynamic;

% Square root envelope (for plot purposes)
envelope = sqrt(envelope_square);

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end