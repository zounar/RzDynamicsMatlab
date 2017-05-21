function [] = runexample( example_number, run_mode )
% RUNEXAMPLE - run predefined audio processing examples
% 1 - 4 - Compressors
% 5 - 8 - Expanders
% 9 - 12 - Limiters
% 13 - 16 - Noise Gates
% 17 - Ducking
%
% Syntax: [] = runexample( example_number, run_mode )
% 
% Inputs:
% example_numer                 <1,17>
% run_mode          [optional]  <1,4> 
%                               {   1 => play output, 
%                                   2 => play input/output, 
%                                   3 => play input/output & save plots and output, 
%                                   4 => save plots and output}
%
% Outputs:
%
% Example:
% runexample(3)
% runexample(5,3)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% If 1st function parameter (example_number) is not given or is out of range
if ( nargin < 1 || example_number > 17 )
    error('First function parameter (example_number) must be in range of 1 - 17');
end;

% If 2nd function parameter ( run_mode ) is not given
if nargin < 2
    % Set default - 0 - plot only
    run_mode = 0;
end;

% Matrix of audio samples
ex_max = 4;
ex = {'sample_440.wav'; 'sample_440_fade.wav'; 'sample_kick.wav'; 'sample_music.wav'};

% Get audio sample as modulo of example_number
input_file = ex{mod(example_number-1, ex_max) + 1, 1};


% 5 - 8 - Compressors
if example_number == 1
    docompressor(run_mode, input_file, -12, 4, 1e-4, 5e-3, 5e-3);
elseif example_number == 2
    docompressor(run_mode, input_file, -12, 4, 1e-4, 5e-3, 5e-3);
elseif example_number == 3
    docompressor(run_mode, input_file, -24, 10, 9e-4, 5e-3, 2e-2);
elseif example_number == 4
    docompressor(run_mode, input_file, -24, 2, 4e-2, 8e-3, 5e-2);
end;

% 9 - 12 - Expanders
if example_number == 5
    doexpander(run_mode, input_file, -6, 0.2, -12, 5e-5, 9e-5, 9e-5, 5e-5);
elseif example_number == 6
    doexpander(run_mode, input_file, -6, 0.2, -12, 5e-5, 9e-4, 9e-3, 5e-5);
elseif example_number == 7
    doexpander(run_mode, input_file, -16, 0.1, -20, 3e-4, 9e-4, 1e-1, 5e-2);
elseif example_number == 8
    doexpander(run_mode, input_file, -22, 0.2, -12, 2e-4, 1e-2, 7e-3, 5e-3);
end;

% 1 - 4 - Limiters
if example_number == 9
    dolimiter(run_mode, input_file, -12, [ 1e-4 5e-4 ] ,[ 1e-3 1e-2 ], 0 );
elseif example_number == 10
    dolimiter(run_mode, input_file, -12, [ 1e-4 5e-4 ],[ 1e-3 1e-2 ], 0);
elseif example_number == 11
    dolimiter(run_mode,input_file, -18, [ 1e-3 5e-5 ], [ 1e-3 1e-2 ], 6);
elseif example_number == 12
    dolimiter(run_mode, input_file, -18, [ 5e-3 5e-4 ], [ 7e-2 2e-3 ], 1);
end;

% 13 - 16 - Noise Gates
if example_number == 13
    donoisegate(run_mode, input_file, -6, 5e-5, 3e-5, 5e-4, 5e-5);
elseif example_number == 14
    donoisegate(run_mode, input_file, -6, 5e-5, 3e-4, 9e-3, 5e-5);
elseif example_number == 15
    donoisegate(run_mode, input_file, -20, 3e-4, 9e-4, 1e-1, 5e-2);
elseif example_number == 16
    donoisegate(run_mode, input_file, -30, 3e-4, 8e-2, 2e-3, 5e-4);
end;

% 17 - Ducking
if example_number == 17
    docompressor(run_mode, ex{4,1}, -24, 5, 4e-3, 2e-2, 8e-2, 0, 'sample_voice.wav');
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end