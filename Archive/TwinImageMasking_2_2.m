% Ralf Mouthaan
% University of Adelaide
% December 2023
% 
% Implementing algorithms described in Madsen et al. "On-axis digital
% holographic microscopy: Current trends and algorithms", Optics
% Communications 537 (2023) 129458.
%
% Algorithm 2_2: Twin image masking, as per McElhinney et al. "Removing the
% Twin Image in Digital Holograpy by Segmented Filtering of In-Focus Twin
% Image", Optics and Photonics for Information Processing II, Proc. of SPIE
% Vol. 7072, 707208 (2008).
%
% This approach attempts to get rid of the twin image by masking it out
% in the plane where it is in focus. In doing so, it also gets rid of a lot
% % of the image of interest. The approach of developing a mask based on
% the image variance is also not great, as propagation to the twin image
% plane introduces some variance.
% 
% This doesn't work properly - I gave up, as the approach seems flawed.

clc; clear variables; close all;
addpath('Functions/')

%% User-Defined Parameters

Nx = 1000;
lambda = 532e-9;
z = 2.5e-6;
x = linspace(-2.5e-6, 2.5e-6, Nx);

%% Generate hologram

O_truth = Target_Mandrill(x, lambda); % Object ground truth
R = ones(size(O_truth)); % Reference field
I = abs(PropagateZ(O_truth, x, z, lambda) + R).^2; % Intensity measured at camera

%% Calculations

F = I - mean(mean(I)); % Remove DC component
F = PropagateZ(F, x, -z, lambda); % Propagate to twin image plane

Mask = zeros(size(F));
WindowSize = 2;

for i = 1 + WindowSize/2 : Nx - WindowSize/2
    for j = 1 + WindowSize/2 : Nx - WindowSize/2
        Window = F(i - WindowSize/2:i+WindowSize/2,...
                        j - WindowSize/2:j+WindowSize/2);
        Mask(i,j) = var(abs(Window(:)));
    end
end

figure; imagesc(Mask);

Mask(Mask > 0.15) = 1;
Mask(Mask <=0.15) = 0;

F = F.*Mask;


F = PropagateZ(F, x, 2*z, lambda);

figure; imagesc(abs(F));

return;

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