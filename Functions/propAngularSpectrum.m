% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Angular spectrum method for propagating.

function Fz = propAngularSpectrum(F, x, lambda, z)

    Nx = length(x);
    dx = x(2) - x(1);
    kx = linspace(-1/dx/2, 1/dx/2, Nx); % Do I need a factor of 2pi in here?
    kr = sqrt(kx.^2 + kx.'.^2);

    invF = fftshift(fft2(fftshift(F)));
    Kernel = exp(1i*2*pi*abs(z)*sqrt(1/lambda^2 - kr.^2));
    Kernel(kr > 1/lambda) = 0;
    Kernel(lambda^2*kr.^2 > 1) = 0;
    Kernel(abs(Kernel) < 1e-10) = 0;

    if z < 0
        Kernel = conj(Kernel);
    end
    
    % Angular spectrum method for propagation
    Fz = fftshift(ifft2(fftshift(invF.*Kernel)));

end