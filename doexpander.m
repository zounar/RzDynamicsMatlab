function [] = doexpander(do_mode, input_file_name, threshold_db, ratio, range_db, averaging, attack, release, hold_time, markup_gain_db, sidechain_file_name)
% DOEXPANDER - load input files, expand the audio and show results
%
% Syntax: [] = doexpander(do_mode, input_file_name, threshold_db, ratio, range_db, averaging, attack, release, hold_time, markup_gain_db, sidechain_file_name)
% 
% Inputs:
% do_mode                           What to do with results ( 0 - 4 )
% input_file_name                   Name of input file name
% threshold_db          [optional]  Threshold relative to maximum of input signal
% ratio                 [optional]  Expanding ratio
% range_db              [optional]  Expander range (dB)
% averaging             [optional]  Envelope detector averaging time constant in seconds
% attack                [optional]  Expander attack time in seconds
% release               [optional]  Expander release time in seconds
% hold_time             [optional]  Expander hold time in seconds
% markup_gain_db        [optional]  Gain to used to boost up a signal after compression
% sidechain_file_name   [optional]  Name of file used in sidechain ( if empty, input file is used )
%
% Outputs:
%
% Example:
% doexpander(1, 'sample_440.wav', -6, 0.5, -20, 5e-4, 5e-3, 5e-2, 5e-2, -6, 'sample_440_faded.wav')
%
% Author: Robin Zoò <xzonro00@vutbr.cz>

% - - - - - - - - - - - - - - BEGIN CODE - - - - - - - - - - - - - - -
close all;


% - - - - - - - - - - - - - - PARAMETERS - - - - - - - - - - - - - - -


% If 3rd function parameter ( threshold_db ) is not given
if nargin < 3
    threshold_db = -10;
end;

% If 4th function parameter ( ratio ) is not given
if nargin < 4
    ratio = 0.25;
end;

% If 5th function parameter ( range_db ) is not given
if nargin < 5
    range_db = -20;
end;

% If 6th function parameter ( averaging ) is not given
if nargin < 6
    averaging = 2e-2;
end;

% If 7rd function parameter ( attack ) is not given
if nargin < 7
    attack =  5e-3;
end;

% If 8th function parameter ( release ) is not given
if nargin < 8
    release = 5e-2;
end;

% If 9th function parameter ( hold_time ) is not given
if nargin < 9
    hold_time = 5e-2;
end;

% If 10th function parameter ( markup_gain_db ) is not given
if nargin < 10
    markup_gain_db = 0;
end;

% If 11th function parameter ( sidechain_file_name ) is not given
if nargin < 11
    sidechain_file_name = input_file_name;
end;


% - - - - - - - - - - - - - - - PRINT INFO - - - - - - - - - - - - - -


fprintf([
'- - - - - - - - - - \n', ...
'Performing: \tEXPANDER\n', ...
'Input file: \t%s\n', ...
'Threshold: \t\t%g dB\n', ...
'Ratio: \t\t\t%g:1\n', ...
'Range: \t\t\t%g dB\n', ...
'Averaging: \t\t%g s\n', ...
'Attack: \t\t%g s\n', ...
'Release: \t\t%g s\n', ...
'Hold: \t\t\t%g s\n', ...
'Markup gain: \t%g dB\n'], input_file_name, threshold_db, ratio, range_db, averaging, attack, release, hold_time, markup_gain_db);
if( strcmp(sidechain_file_name, input_file_name) == 0 )
    fprintf('Sidechain file: %s\n', sidechain_file_name);
end;
fprintf('- - - - - - - - - - \n');


% - - - - - - - - - - - - - - - PROCESS  - - - - - - - - - - - - - - -


% Load audio files
[input, sidechain, sample_rate] = audioreadmultiple(input_file_name, sidechain_file_name);

% Process the audio
[output, sidechain_envelope, gain_static, gain_dynamic] = expander( input, sidechain, sample_rate, threshold_db, ratio, range_db, averaging, attack, release, hold_time, markup_gain_db );


% - - - - - - - - - - - - - - - RESULTS  - - - - - - - - - - - - - - -

% Protection from division by zero
if ratio == 1
    ratio = 0.999999999999999;
end;

% Get bottom threshold point position
ratio_inv = 1/ratio;
threshold_bottom =  ( threshold_db - ratio_inv * ( range_db + threshold_db ) ) / ( 1 - ratio_inv ) - range_db;

% - - - - - PLOT CHARACTERISTICS
% Initialize the characteristics (create empty zero-filled matrix)
% Storing 150 samples because of aliasing
characteristics = zeros(2,150);

% Get the characteristics line
for n=1:150;
    in = -n/2;
    characteristics(1,n) = in;

    if( in > threshold_db )
        characteristics(2,n) = in;
    else
        if( in > threshold_bottom )
            characteristics(2,n) = (in/ratio) + threshold_db - (threshold_db/ratio);
        else
            characteristics(2,n) = in + range_db;
        end;
    end;
end;

% Plot the characteristics
fig = figure(2);
hold on;
plot(characteristics(1,:), characteristics(2,:));
grid on;
axis([-75 0 -75 0]);
set(gca,'xtick',linspace(-72,0,13));
set(gca,'ytick',linspace(-72,0,13));
title(sprintf('Prevodni charakteristika, thr = %g db, ratio = %g:1, range = %g dB', threshold_db, ratio, range_db));
xlabel('x (dB)');
ylabel('y (dB)');
hold off;



% - - - - - PLOT SIGNAL


% Get plot length (X axis)
plot_length = length(input);
% Start plotting new figure - fullscreened
fig2 = figure('units','normalized','outerposition',[0 0 1 1]);
% Get threshold line to use for plot
threshold_line = dbtolin(threshold_db) * ones(size(input));

% - - - - - PLOT INPUT
subplot(5,1,1);
hold on;
plot(input);
plot(threshold_line, 'r');
grid on;
axis([0 plot_length -1 1]);
ylabel('x[n]');
title('Vstupni signal');
legend('x[n]', 'threshold[n]');
hold off;

% - - - - - PLOT ENVELOPE
subplot(5,1,2);
hold on;
plot(sidechain_envelope);
plot(threshold_line, 'r');
grid on;
axis([0 plot_length 0 ceil(max(sidechain_envelope))] );
ylabel('sidechain\_env[n]');
title(sprintf('Amplitudova obalka ridici vetve t_a_v = %g s',averaging));
legend('sidechain\_env[n]', 'threshold[n]');
hold off;


% - - - - - PLOT STATIC GAIN
subplot(5,1,3);
hold on;
plot(gain_static);
grid on;
axis([0 plot_length 0 max([ceil(max(gain_static)) 1])] );
ylabel('gain\_static[n]');
title(sprintf('Uroven zesileni expanderu (bez dynamicke filtrace), thr = %g dB, ratio = %g:1, range = %g dB', threshold_db, ratio, range_db ));
legend('gain\_static[n]');
hold off;


% - - - - - PLOT DYNAMIC GAIN
subplot(5,1,4);
hold on;
plot(gain_dynamic);
grid on;
axis([0 plot_length 0 max([ceil(max(gain_dynamic)) 1])] );
ylabel('gain\_dynamic[n]');
title(sprintfc('Uroven zesileni expanderu (s dynamickym filtrem) t_a = %g s, t_r = %g s',[attack release]));
legend('gain\_dynamic[n]');
hold off;


% - - - - - PLOT OUTPUT
m = ceil(max(output));
subplot(5,1,5);
hold on;
plot(output);
plot(threshold_line, 'r');
axis([0 plot_length -m m]);
grid on;
ylabel('y[n]');
title(sprintfc('Vystupni (expandovany) signal, gain_m = %g dB',markup_gain_db));
xlabel('n');
legend('y[n]', 'threshold[n]');
hold off;


% - - - - - - - - - - - - - - - DO MODE  - - - - - - - - - - - - - - -

% Play or save files based on do_mode
evaldomode(do_mode, input, output, sample_rate, fig, fig2);

% - - - - - - - - - - - - - - END OF CODE  - - - - - - - - - - - - - -
end