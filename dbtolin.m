function [ output_lin ] = dbtolin( input_db )
% DBTOLIN - convert decibels to linear scale
%
% Syntax: [ output_lin ] = dbtolin( input_db )
% 
% Inputs:
% input_db              Input value in decibels
%
% Outputs:
% output_lin            Output value in linear scale
%
% Example:
% dbtolin(6)
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

output_lin = 10 .^ (input_db ./ 20);

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end