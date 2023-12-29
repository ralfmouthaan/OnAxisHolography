% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Returns an object consisting of two beads.
% Most of the parameters are hard-coded in.

function F = Target_Mandrill(x, lambda)

    load Mandrill 'X';
    X = X/255*1.5;
    %X = imgaussfilt(X, 3);
    Nx = length(x);
    F = zeros(Nx);
    F(Nx/2 - size(X, 1)/2:Nx/2 + size(X, 1)/2 - 1,...
        Nx/2 - size(X, 2)/2:Nx/2 + size(X, 2)/2 - 1) = X;
    F = exp(1i*F);

end