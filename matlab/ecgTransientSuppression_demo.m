%%
% ECGTRANSIENTSUPPRESSION_DEMO - Demo for the function
% ecgTransientSuppression.
%
% Created August 5, 2014.
% Arturo Moncada-Torres
%   arturomoncadatorres@gmail.com
%   http://www.arturomoncadatorres.com


%% Preliminaries.
clc;
clear all;
close all;


%% Define execution parameters.

% Noise (AC interference) parameters.
A0 = 250;   % (Peak) amplitude [uV].
fd = 50;    % Frequency [Hz].
phi = 15;   % Phase [deg].


% Filtering parameters.
BW = 0.8;   % Notch bandwidth [Hz].
M = 10;     % Number of initial samples to consider for the transient
            % suppression technique.


%% Load data. 

% Data is contained in "data/ecg.mat".
% The original data was obtained from the MIT-BIH Polysomnographic
% Database (http://www.physionet.org/cgi-bin/atm/ATM).
% ecgOriginal   Original (clean) ECG signal (given by Eq. 3).
% fs            Sampling frequency [Hz].
load('../data/ecg');

s_n = ecgOriginal;              % To follow paper's notation.

% Original data consists of 10 s recording.
% For simplicity, we will consider only the first 5 s.
s_n = s_n(1:end/2);


%% Calculate important parameters.

N = numel(s_n);                 % Number of samples.
Ts = 1/fs;                      % Sampling period [s].
t = linspace(0, (N-1)*Ts, N);   % Time vector [s].

w0 = 2 * pi * (fd/fs);          % Notch frequency [rad/s].
omega = 2 * pi * (BW/fs);       % Bandwidth [rad/s].


%% Contaminate original signal.

% Create noise, i.e. AC interference (Eq. 4).
d_n = A0 * sin((2 * pi * fd) .* t + deg2rad(phi));

% Add the original signal with the noise (Eq, 3).
x_n = s_n + d_n;


%% Filtering process 1 (conventional).

% 1. Calculate a1 and a2 coefficients using Eq. 2.
a1 = (2 * cos(w0)) / (1 + tan(omega/2));
a2 = (1 - tan(omega/2)) / (1 + tan(omega/2));

% 2. Choose arbitrary initial conditions (x[-1], x[-2], y[-1], y[-2]).
x_1 = 0;    % x[-1].
x_2 = 0;	% x[-2].
y_1 = 0;	% y[-1].
y_2 = 0;	% y[-2].

% 3. From n = 0 to N,  calculate the output, given by Eq. 5.

% Manually calculate the first two samples (for sake of clarity).
y_n(1) = 0.5 * ((1 + a2)* x_n(1) - 2*a1*x_1    + (1 + a2)*x_2) + (a1*y_1)    - (a2*(y_2));
y_n(2) = 0.5 * ((1 + a2)* x_n(2) - 2*a1*x_n(1) + (1 + a2)*x_1) + (a1*y_n(1)) - (a2*y_1);

for n = 3:N
    y_n(n) = 0.5 * ((1 + a2)* x_n(1,n) - 2*a1*x_n(n-1) + (1 + a2)*x_n(n-2)) + (a1*y_n(n-1)) - (a2*y_n(n-2));
end

ecgFilt1 = y_n;


%% Filtering process 2 (notch filtering with transient state suppression).
y_n = ecgTransientSuppression(x_n, fs, fd, BW, M);
ecgFilt2 = y_n;


%% Plots.

figure('Name', 'Input Signal');
subplot(3,1,1);
plot(t,s_n,'b');
title('Original (Clean) ECG');
ylabel('Amplitude [\muV]')
subplot(3,1,2);
plot(t,d_n,'b');
title('Noise (AC Interference)');
ylabel('Amplitude [\muV]')
subplot(3,1,3);
plot(t,x_n,'b');
title('ECG + Noise');
xlabel('Time [s]');
ylabel('Amplitude [\muV]')

figure('Name','Filtering Comparison');
subplot(3,1,1);
plot(t,s_n,'b');
title('Original (Clean) ECG');
ylabel('Amplitude [\muV]')
subplot(3,1,2);
plot(t,ecgFilt1,'b');
title('Filtered ECG (Conventional Method)');
ylabel('Amplitude [\muV]')
subplot(3,1,3);
plot(t,ecgFilt2,'b');
title('Filtered ECG (Transient Suppression Method)');
xlabel('Time [s]');
ylabel('Amplitude [\muV]')
