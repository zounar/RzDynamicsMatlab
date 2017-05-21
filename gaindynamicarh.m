function [ gain_dynamic ] = gaindynamicarh(gain_static, sample_rate, attack, release, hold, is_compressor)
% GAINDYNAMICARH - dynamic filter with attack, release and hold time
%
% Syntax: [ gain_dynamic ] = gaindynamicarh(gain_static, sample_rate, attack, release, hold, is_compressor)
% 
% Inputs:
% gain_static           Static gain function of envelope
% sample_rate           Sample rate of input signal
% attack                Filters attack time (in seconds)
% release               Filters release time (in seconds)
% hold                  Filters hold time (in seconds)
% is_compressor [optional]  If 1 (true), dynamic filter will behave as it is filtering compressor
%                               gain reduction signal (attack and release constants are swapped)
%
% Outputs:
% gain_dynamic          Dynamic filtered static gain function
%
% Example:
% gaindynamicarh(gain_static, 44100, 0.05, 0.1, 0.1, 1)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Last argument is optional
if nargin < 6
    is_compressor = 0;
end;

% Get attack time (for sampling period)
AT = timebyperiod(attack,sample_rate);
% Get release time (for sampling period)
RT = timebyperiod(release,sample_rate);
% Get number of samples in hold
HSAMP = round(hold * sample_rate);

% Initialize dynamic gain (create empty one-filled matrix)
gain_dynamic = ones(size(gain_static));

% Counter of samples below the threshold level but in HOLD time
under_cnt = 0;


% If filtering compressor signal
if( is_compressor == 1 )
    
    % For each input sample starting from 2nd
    for n=2:length(gain_static)        
        % Signal is attacking
        if( gain_static(n) <= gain_dynamic(n - 1) )
            gain_dynamic(n) = (1 - AT) * gain_dynamic(n - 1) + AT * gain_static(n);
            under_cnt = 0;
        else
            % Still in hold
            if( under_cnt < HSAMP )
                gain_dynamic(n) = gain_dynamic(n - 1);
                under_cnt = under_cnt + 1;
            % In release
            else
                gain_dynamic(n) = (1 - RT) * gain_dynamic(n-1) + RT * gain_static(n);
            end;
        end;
    end;
    
% Filtering regular signal (expander, gate ...)
else
    
    % For each input sample starting from 2nd
    for n=2:length(gain_static)     
        % Signal is attacking
        if( gain_static(n) >= gain_dynamic(n - 1) )
            gain_dynamic(n) = (1 - AT) * gain_dynamic(n - 1) + AT * gain_static(n);
            under_cnt = 0;
        else
            % If expander/gate was oppened and still in hold
            if( gain_dynamic(n - 1) > 0.982 && under_cnt < HSAMP )
                gain_dynamic(n) = gain_dynamic(n - 1);
                under_cnt = under_cnt + 1;
            % In release
            else
                gain_dynamic(n) = (1 - RT) * gain_dynamic(n-1) + RT * gain_static(n);
            end;
        end;
    end;
    
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end