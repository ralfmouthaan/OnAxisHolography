% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Angular spectrum method for propagating.

function Fz = PropagateZ(F, x, z, lambda)

    Nx = length(x);
    dx = x(2) - x(1);
    kx = linspace(-1/dx/2, 1/dx/2, Nx); % Do I need a factor of 2pi in here?
    kr = sqrt(kx.^2 + kx.'.^2);

    invF = ifftshift(fft2(fftshift(F)));
    
    % Angular spectrum method for propagation
    if z >= 0
        Fz = ifftshift(ifft2(fftshift(invF.*exp(1i*2*pi*z*sqrt(1/lambda^2 - kr.^2)))));
    else
        Fz = ifftshift(ifft2(fftshift(invF.*conj(exp(1i*2*pi*abs(z)*sqrt(1/lambda^2 - kr.^2)))))); % Is this right?????
    end

end