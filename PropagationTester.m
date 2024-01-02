% Ralf Mouthaan
% University of Adelaide
% January 2024
%
% Script to look into building an invertable angular spectrum method
% propagation function. The problem I have at the moment is that doing F(z)
% and then doing F(-z) does not bring me back to the same point. The
% difference is of the order of 1e-4, but this is much bigger than what I
% expect absorption to be at these scales.

clc; clear variables; close all;
addpath('Functions/')

%% User-Defined variables

Nx = 1000;
lambda = 532e-9;
z = 1e-6; % Distance from object plane to screen plane
x = linspace(-2.5e-6, 2.5e-6, Nx);

%% Generate hologram

[a, phi] = Target_TwoBeads(x, lambda); % Object ground truth

F1 = 10*a.*exp(1i*phi);

F2 = propAngularSpectrum(F1, x, lambda, z);

figure; imagesc(abs(F2));

F2 = propAngularSpectrum(F2, x, lambda, -z);

figure; imagesc(abs(F1 - F2));
colorbar;