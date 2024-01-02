% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Returns an object consisting of two beads.
% Most of the parameters are hard-coded in.

function F = Target_AbsorbingBeads(x, lambda)

    [x_mesh, y_mesh] = meshgrid(x, x.');
    Radius = 0.5e-6;
    n1 = 1.5;
    Offset = 1e-6; % Offset between the beads
    
    Object1 = 2*Radius - 2*Radius*((x_mesh-Offset/2).^2/Radius^2 + y_mesh.^2/Radius^2);
    Object1(Object1 < 0) = 0;
    Object2 = 2*Radius - 2*Radius*((x_mesh+Offset/2).^2/Radius^2 + y_mesh.^2/Radius^2);
    Object2(Object2 < 0) = 0;
    F = Object1 + Object2;
    F = exp(-0.01*F).*exp(1i*n1*F/lambda);

end