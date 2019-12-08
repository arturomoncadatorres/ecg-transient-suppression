function y_n = ecgTransientSuppression(x_n, fs, fd, BW, M)
%%
% ECGTRANSIENTSUPPRESSION - ECG IIR notch filtering using transient
%   suppression.
%
% Y_N = ECGTRANSIENTSUPPRESSION(X_N, FS, FD, BW, M) performs a second
%   order IIR filtering of the input signal X_N. The sampling rate FS,
%   the notch frequency FD, and the notch bandwidth BW are all in Hz.
%   M is the number of initial samples to be considered for the transient
%   suppression technique. It is suggested to be between 5-15, but can be
%   adjusted empirically.
%
%   This is the MATLAB implementation of the algorithm proposed in
%   the paper
%       Pei, Soo-Chang, and Chien-Cheng Tseng. "Elimination of AC
%       interference in electrocardiogram using IIR notch filter with
%       transient suppression." Biomedical Engineering, IEEE
%       Transactions on 42.11 (1995): 1128-1132.
%       http://ieeexplore.ieee.org/xpl/articleDetails.jsp?tp=&arnumber=469385
%   Full credit goes to the authors of the paper.
%
% Created August 5, 2014.
% Arturo Moncada-Torres - ETH Zurich
%   arturomoncadatorres@gmail.com
%   http://www.arturomoncadatorres.com


%% 1. Calculate a1 and a2 coefficients (using Eq. 2).

w0 = 2 * pi * (fd/fs);          % Notch frequency [rad/s].
omega = 2 * pi * (BW/fs);       % Bandwidth [rad/s].

a1 = (2 * cos(w0)) / (1 + tan(omega/2));
a2 = (1 - tan(omega/2)) / (1 + tan(omega/2));


%% 2. Construct input data vector X and projection matrix P.
X = x_n(1:M)';

A(1:M,1) = cos((0:M-1).*w0);
A(1:M,2) = sin((0:M-1).*w0);
P = A*inv((A'*A))*A';


%% 3. Calculate first M output samples as (I-P)X .
I = eye(M);
y_n = ((I - P) * X)';


%% 4. From n = M+1 to N,  calculate the output, given by Eq. 14.
N = numel(x_n);
for n = M+1:N
    y_n(n) = 0.5 * ((1 + a2)* x_n(1,n) - 2*a1*x_n(n-1) + (1 + a2)*x_n(n-2)) + (a1*y_n(n-1)) - (a2*y_n(n-2));
end
