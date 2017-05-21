function [ output ] = timebyperiod( time, sample_rate )
% TIMEBYPERIOD - convert time in seconds to time by period
%
% Syntax: [ output ] = timebyperiod( time, sample_rate )
% 
% Inputs:
% time                  Input time (in seconds)
% sample_rate           Sample rate to compare with
%
% Outputs:
% output                Time by period
%
% Example:
% timebyperiod( 0.3, 44100 )
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Converts time to time by given period (num of samples)
output = 1 - exp(-2.2 ./ (time .* sample_rate));
    
% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -    
end