% Ralf Mouthaan
% University of Adelaide
% December 2023
% 
% Implementing algorithms described in Madsen et al. "On-axis digital
% holographic microscopy: Current trends and algorithms", Optics
% Communications 537 (2023) 129458.
%
% Algorithm 3_1: Gerchberg Saxton or Fienup. References Latychevskaia and
% Fink "Solution to the Twin Image Problem in Holography".
%
% Bounces back and forth imposing observed intensity constraint in the
% hologram plane and positive absorption constraint in the object plane.

clc; clear variables; close all;
addpath('Functions/')

%% User-Defined Parameters

bolNonAbsorbing = false; % True: Particle is assumed to be non-absorbing
                         % False: Particle can be absorbing
Nx = 1000;
lambda = 532e-9;
z0 = 1; % Distance from source
z = 2.5e-6; % Distance from object plane to screen plane
x = linspace(-2.5e-6, 2.5e-6, Nx);

%% Generate hologram

[a, phi] = Target_TwoBeads(x, lambda); % Object ground truth
Ref = ones(Nx); % Reference field
Obj = Ref.*(1-a).*exp(1i*phi); % Ref(1-a*exp(i*phi)) does not work 
                               % because the object must be absorptive
                               % i.e. all amplitudes must be < 1

% Propagate to hologram plane, calculate what hologram would be
F = propFresnel2(Obj, x, lambda, z);
H = abs(F);

%% Calculations

for ii = 1:100

    fprintf('Iteration %d\n', ii)

    F = propFresnel2(F, x, lambda, -z); % Propagate to object plane
    if bolNonAbsorbing ; F = exp(1i*angle(F)); % Impose absorption constraints
    else ; F(abs(F) > 1) = exp(1i*angle(F(abs(F) > 1))); end
    F = propFresnel2(F, x, lambda, z); % Propagate to hologram plane
    F = H.*exp(1i*angle(F)); % Impose hologram amplitude constraints

end

% Final propagation back to object plane
F = propFresnel2(F, x, lambda, -z);

%% Show results

subplot(2,2,1);
imagesc(abs(Obj));
axis square;
xticks(''); yticks('');
title('Truth - Mag');

subplot(2,2,2);
imagesc(angle(Obj));
axis square;
xticks(''); yticks('');
title('Truth - Phase');

subplot(2,2,3);
imagesc(abs(F));
axis square;
xticks(''); yticks('');
title('Estimate - Magnitude')

subplot(2,2,4);
imagesc(angle(F));
axis square;
xticks(''); yticks('');
title('Estimate - Phase')