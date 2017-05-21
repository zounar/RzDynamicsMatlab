function [ slope ] = ratiotoslope( ratio )
% RATIOTOSLOPE - convert ratio to slope
%
% Syntax: [ slope ] = ratiotoslope( ratio )
% 
% Inputs:
% ratio             Compression ratio
%
% Outputs:
% slope             Compression slope
%
% Example:
% ratiotoslope( 2 )
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

slope = 1 - (1 ./ ratio);

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end