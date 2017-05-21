function [ output, envelope, gain_static, gain_dynamic ] = compressor( input, sidechain, sample_rate, threshold_db, ratio, averaging, attack, release, markup_gain_db )
% COMPRESSOR - process input signal by compressing it
%
% Syntax: [ output, envelope, gain_static, gain_dynamic ] = compressor( input, sidechain, sample_rate, threshold_db, ratio, averaging, attack, release, markup_gain_db )
% 
% Inputs:
% input                     Input signal (time domain)
% sidechain                 Sidechain signal (time domain)
% sample_rate               Sample rate of input signal (must be same as sidechain)
% threshold_db              Threshold (dB)
% ratio                     Compression ratio
% averaging                 Envelope follower averaging time constant in seconds
% attack                    Compressor attack time in seconds
% release                   Compressor release time in seconds
% markup_gain_db [optional] Gain to used to boost up a signal after compression (dB)
%
% Outputs:
% output                    Compressed input signal
% envelope                  Envelope of sidechain signal
% gain_static               Gain used to compress the input (before dynamic filtering)
% gain_dynamic              Gain used to compress the input (after dynamic filtering)
%
% Example:
% compressor(input, sidechain, 44100, -10, 3, 5e-3, 5e-2, 5e-2, 6)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Markup gain argument is optional
if nargin < 9
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
gain_static_log = gainstaticcompressor(envelope_log, threshold_db, ratio);

% Log / lin
gain_static = logtolin(gain_static_log);

% Get dynamic gain to use for reduction
gain_dynamic = gaindynamicar(gain_static, sample_rate, attack, release, 1);

% - - - - - - - - - - - - - - - VCA - - - - - - - - - - - - - - - - - -

% Compress the signal
output = input .* ( gain_dynamic .* markup_gain );

% Square root envelope (for plot purposes)
envelope = sqrt(envelope_square);

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end