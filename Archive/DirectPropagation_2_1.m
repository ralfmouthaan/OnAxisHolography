% Ralf Mouthaan
% University of Adelaide
% December 2023
% 
% Implementing algorithms described in Madsen et al. "On-axis digital
% holographic microscopy: Current trends and algorithms", Optics
% Communications 537 (2023) 129458.
%
% Algorithm 2_1: Direct propagation method. This simply applied the angular
% spectrum method to the intensity pattern.
%
% This is the most naive approach. It effectively assumes the phase in the
% measurement plane is flat. It is fast, though.

clc; clear variables; close all;
addpath('Functions/')

%% User-Defined Parameters

Nx = 1000;
lambda = 532e-9;
z = 2.5e-6;
x = linspace(-2.5e-6, 2.5e-6, Nx);

%% Generate hologram

O_truth = Target_TwoBeads(x, lambda); % Object ground truth
R = ones(size(O_truth)); % Reference field
I = abs(PropagateZ(O_truth, x, z, lambda) + R).^2; % Intensity measured at camera
O_est = PropagateZ(I, x, -z, lambda);

%% Show results

figure;

subplot(2,2,1);
imagesc(abs(O_truth));
axis square;
xticks(''); yticks('');
title('Truth - Mag');

subplot(2,2,2);
imagesc(angle(O_truth));
axis square;
xticks(''); yticks('');
title('Truth - Phase');

subplot(2,2,3);
imagesc(abs(O_est));
axis square;
xticks(''); yticks('');
title('Estimate - Magnitude')

subplot(2,2,4);
imagesc(angle(O_est));
axis square;
xticks(''); yticks('');
title('Estimate - Phase')