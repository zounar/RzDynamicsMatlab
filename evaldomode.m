function [] = evaldomode( do_mode, input_signal, output_signal, sample_rate, figure_characteristics, figure_sidechain )
% EVALDOMODE - play signals or save plots
%
% Syntax: [] = evaldomode( do_mode, input_signal, output_signal, sample_rate, figure_characteristics, figure_sidechain )
% 
% Inputs:
% do_mode                   <1,4>
% input_signal              Signal before processing
% output_signal             Signal after processing
% sample_rate               Sample rate of both signals
% figure_characteristics    Plot of dynamic processors IO characteristics
% figure_sidechain          Plot of dynamic processors signal
%
% Outputs:
%
% Example:
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -

% Delay of input and output signal (in samples)
in_out_delay = 20000;

% Output plots file extension [ png, pdf, svg ]
output_plots_extension = 'png';

if do_mode == 1
    % Play output sound
    sound(output_signal, sample_rate, 16);
elseif do_mode > 1 && do_mode < 4
    % Play input and output sound after
    sound([input_signal ; zeros(in_out_delay,1) ; output_signal], sample_rate, 16);
end;

if do_mode > 2
    % For Matlab >= R2012b use audiowrite instead of wavread
    if ( exist('audiowrite','file') ~= 0 )
        % Save output to WAV file
        audiowrite('output.wav', output_signal, sample_rate);
    else
        % Save output to WAV file
        wavwrite(output_signal, sample_rate, 'output.wav');
    end;
    % Set size of paper to as small as possible
    set(figure_characteristics, 'papersize', [14 11]);
    set(figure_sidechain, 'papersize', [31 19]);
    % Align center
    set(figure_characteristics, 'PaperPositionMode', 'Auto'); 
    set(figure_sidechain, 'PaperPositionMode', 'Auto');
    % Print both plots to file
    print(figure_characteristics, sprintf('-d%s',output_plots_extension), sprintf('output_characteristics.%s',output_plots_extension));
    print(figure_sidechain, sprintf('-d%s',output_plots_extension), sprintf('output_sidechain.%s',output_plots_extension));
end;

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end