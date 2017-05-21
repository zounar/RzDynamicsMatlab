function [ output, envelope, gain_static, gain_dynamic ] = expander(input, sidechain, sample_rate, threshold_db, ratio, range_db, averaging, attack, release, hold_time, markup_gain_db )
% EXPANDER - process input signal by expanding it
%
% Syntax: [ output, envelope, gain_static, gain_dynamic ] = expander(input, sidechain, sample_rate, threshold_db, ratio, range_db, averaging, attack, release, hold_time, markup_gain_db )
% 
% Inputs:
% input                     Input signal (time domain)
% sidechain                 Sidechain signal (time domain)
% sample_rate               Sample rate of input signal (must be same as sidechain)
% threshold_db              Threshold (dB)
% ratio                     Ratio
% range_db                  Gain reduction range (dB)
% averaging                 Envelope detector averaging time constant in seconds
% attack                    Attack time in seconds
% release                   Release time in seconds
% hold_time      [optional] Hold time in seconds
% markup_gain_db [optional] Markup gain (dB)
%
% Outputs:
% output                Compressed input signal
% envelope              Envelope of sidechain signal
% gain_static           Gain used to compress the input (before dynamic filtering)
% gain_dynamic          Gain used to compress the input (after dynamic filtering)
%
% Example:
% expander(input, sidechain, 44100, -20, 0.5, -15, 5e-3, 5e-2, 3e-2, 5e-2, -6 )
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Hold argument is optional
if nargin < 10
    hold_time = 1e-6;
end;

% Markup_gain_db argument is optional
if nargin < 11
    markup_gain_db = 0;
end;

% Convert markup gain from dB to linear
markup_gain = dbtolin(markup_gain_db);

% - - - - - - - - - - - - - - SIDECHAIN - - - - - - - - - - - - - - - -

% Get input signal envelope
envelope_square = enveloperms(sidechain, sample_rate, averaging);

% Lin^2 / log
envelope_log = log10(envelope_square) / 2;

% Get static gain to use for reduction
gain_static_log = gainstaticexpander(envelope_log, threshold_db, ratio, range_db);

% Log / lin
gain_static = logtolin(gain_static_log);

% Get dynamic gain to use for reduction
gain_dynamic = gaindynamicarh(gain_static, sample_rate, attack, release, hold_time);

% - - - - - - - - - - - - - - - VCA - - - - - - - - - - - - - - - - - -

% Gate the signal
output = input .* ( gain_dynamic .* markup_gain );

% Square root envelope (for plot purposes)
envelope = sqrt(envelope_square);

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end