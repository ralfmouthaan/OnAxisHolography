function [F, x] = propFresnel2(F, x, lambda, z)

    % This uses a double Fourier transform approach to do the Fresnel
    % approximation calculation. As per Latchevskaia "Practical
    % Algorithms for Simulation and Reconstruction of Digital In-Line
    % Holograms", Applied Optics, 54 (9) 2015.

    % Coord calculations
    Nx = length(x);
    dx = (max(x) - min(x))/(Nx-1);
    du = 1/(Nx*dx);
    u = (-Nx/2:Nx/2-1)*du;
    [u_mesh, v_mesh] = meshgrid(u, u);

    F = fftshift(fft2(fftshift(F)));
    F = F.*exp(-1i*pi*lambda*z*(u_mesh.^2 + v_mesh.^2));
    F = fftshift(ifft2(fftshift(F)));
    
end