function [ output_lin ] = logtolin( input_log )
% LOGTOLIN - convert matrix from logarithmic scale to linear
%
% Syntax: [ output_lin ] = logtolin( input_log )
% 
% Inputs:
% input_log          Input signal (log)
%
% Outputs:
% output_lin         Output signal (lin)
%
% Example:
% logtolin( 10 )
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -
   
% Convert log to lin
output_lin = 10 .^ input_log;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end