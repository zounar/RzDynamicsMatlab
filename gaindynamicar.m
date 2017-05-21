function [ gain_dynamic ] = gaindynamicar( gain_static, sample_rate, attack, release, is_compressor )
% GAINDYNAMICAR - dynamic filter with attack and release constants
%
% Syntax: [ gain_dynamic ] = gaindynamicar( gain_static, sample_rate, attack, release, is_compressor )
% 
% Inputs:
% gain_static               Static gain function of envelope
% sample_rate               Sample rate of input signal
% attack                    Filter attack time (in seconds)
% release                   Filter release time (in seconds)
% is_compressor [optional]  If 1 (true), dynamic filter will behave as it is filtering compressor
%                               gain reduction signal (attack and release constants are swapped)
%
% Outputs:
% gain_dynamic          Dynamic filtered static gain function
%
% Example:
% gaindynamic(gain_static, 44100, 5e-3, 5e-2, 1)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Last argument is optional
if nargin < 5
    is_compressor = 0;
end;

% Swap time constants if filtering compressor signal
if( is_compressor == 1 )
    [ attack, release ] = deal(release, attack);
end;
    
% Get attack time (for sampling period)
AT = timebyperiod(attack, sample_rate);
% Get release time (for sampling period)
RT = timebyperiod(release, sample_rate);

% Initialize dynamic gain (create empty one-filled matrix)
gain_dynamic = ones(size(gain_static));

% For each input sample starting from 2nd
for n=2:length(gain_static);
    % If envelope sample is greater than previous output
    if (gain_static(n) > gain_dynamic(n-1))
        % Signal is attacking
        gain_dynamic(n) = (1 - AT) * gain_dynamic(n-1) + AT * gain_static(n);
    else
        % Signal is releasing
        gain_dynamic(n) = (1 - RT) * gain_dynamic(n-1) + RT * gain_static(n);
    end;
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end