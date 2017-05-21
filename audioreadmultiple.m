function [ input, sidechain, sample_rate ] = audioreadmultiple( input_file_name, sidechain_file_name )
% AUDIOREADMULTIPLE - read multiple audio files and match length
%
% Syntax: [ input, sidechain, sample_rate ] = audioreadmultiple( input_file_name, sidechain_file_name )
% 
% Inputs:
% input_file_name       Name of file used as input signal
% sidechain_file_name   Name of file used as sidechain
%
% Outputs:
% input                 Input signal
% sidechain             Sidechain signal
% sample_rate           Sample rate
%
% Example:
% audioreadmultiple('audio.wav', 'sidechain.wav')
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% If input and sidechain is the same file
if( strcmp(sidechain_file_name,input_file_name) == 1 )
    % For Matlab >= R2012b use audioread instead of wavread
    if ( exist('audioread','file') ~= 0 )
        % Load file
        [input, input_sample_rate] = audioread(input_file_name);
    else
        % Load file 
        [input, input_sample_rate] = wavread(input_file_name);
    end;
    % Set sidechain signal as input signal
    sidechain = input;
    % Set sidechain sample rate as input sample rate
    sidechain_sample_rate = input_sample_rate;
else
    % For Matlab >= R2012b use audioread instead of wavread
    if ( exist('audioread','file') ~= 0 )
        % Load input signal
        [input, input_sample_rate] = audioread(input_file_name);
        % Load sidechain signal
        [sidechain, sidechain_sample_rate] = audioread(sidechain_file_name);
    else
        % Load input signal
        [input, input_sample_rate] = wavread(input_file_name);
        % Load sidechain signal
        [sidechain, sidechain_sample_rate] = wavread(sidechain_file_name);
    end;
end;

% Sample rates must be equal
if ( input_sample_rate ~= sidechain_sample_rate )
    error('Sample rates do not match!\nInput sample rate (%s): %d\nSidechain sample rate (%s): %d',input_file_name, input_sample_rate, sidechain_file_name, sidechain_sample_rate);
else
    sample_rate = input_sample_rate;
end;

% Match matrixes (set same length to both signals)
% Get max length of both signals
samples = max([length(input) length(sidechain)]);
% Append zeros after input signal to match max length
input = [input; zeros(samples - length(input), 1)];
% Append zeros after sidechain signal to match max length
sidechain = [sidechain; zeros(samples - length(sidechain),1)];

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end