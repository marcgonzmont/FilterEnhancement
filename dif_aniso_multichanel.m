% DIF_ANISO - Difusion Anisotr�pica multicanal
%
% Usage:
%  imdif = dif_aniso(im, niter, k, lambda, opcion)
%
% Par�metros:
%         im     - imagen de entrada
%         niter  - numero de iteraciones.
%         k - Coeficiente de conductancia
%         lambda - valor m�ximo de 0.25 para que sea estable
%         opcion - 1 Funcion 1 de Perona Malik 
%                  2 Funcion 2 de Perona Malik
%
% Returns:
%         imdif   - imagen filtrada
%
% kappa controls conduction as a function of gradient.  If kappa is low
% small intensity gradients are able to block conduction and hence diffusion
% across step edges.  A large value reduces the influence of intensity
% gradients on conduction.
%
% lambda controla la velocidad de difusi�n
%
% La funci�n de difusi�n 1 favorece lo bordes de alto contraste sobre los
% de bajo contraste
% LA funci�n de difusi�n 2 favorece las regiones grandes sobre las peque�as

% Referencia: 
% P. Perona and J. Malik. 
% Scale-space and edge detection using ansotropic diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 12(7):629-639, July 1990.
%
% 

function [ imdif1, psnr1, imdif2, psnr2 ] = dif_aniso_multichanel( noiseIm1,noiseIm2, niter, k, lambda, opcion, original1, original2 )


noiseIm1 = double(noiseIm1);
[ rows1, cols1 ] = size(noiseIm1);
imdif1 = noiseIm1;

noiseIm2 = double(noiseIm2);
[ rows2,cols2 ] = size(noiseIm2);
imdif2 = noiseIm2;

original1_d = double(original1);
original2_d = double(original2);
  
for i = 1:niter
%   fprintf('\rIteraci�n %d',i);

  % A�ado un marco de ceros a la imagen
  
  imdifm1 = zeros(rows1+2, cols1+2);
  imdifm1(2:rows1+1, 2:cols1+1) = imdif1;
  
  imdifm2 = zeros(rows2+2, cols2+2);
  imdifm2(2:rows2+1, 2:cols2+1) = imdif2;
  % Diferencias en las cuatro direcciones
  
  deltaN1 = imdifm1(1:rows1,2:cols1+1)   - imdif1;
  deltaS1 = imdifm1(3:rows1+2,2:cols1+1) - imdif1;
  deltaE1 = imdifm1(2:rows1+1,3:cols1+2) - imdif1;
  deltaW1 = imdifm1(2:rows1+1,1:cols1)   - imdif1;  
  
  deltaN2 = imdifm2(1:rows2,2:cols2+1)   - imdif2;
  deltaS2 = imdifm2(3:rows2+2,2:cols2+1) - imdif2;
  deltaE2 = imdifm2(2:rows2+1,3:cols2+2) - imdif2;
  deltaW2 = imdifm2(2:rows2+1,1:cols2)   - imdif2;
  
  deltaN = sqrt(deltaN1.^2+deltaN2.^2);
  deltaS = sqrt(deltaS1.^2+deltaS2.^2);
  deltaE = sqrt(deltaE1.^2+deltaE2.^2);
  deltaW = sqrt(deltaW1.^2+deltaW2.^2);
  
  % Conductancia

  if opcion == 1
    cN = exp(-(deltaN/k).^2);
    cS = exp(-(deltaS/k).^2);
    cE = exp(-(deltaE/k).^2);
    cW = exp(-(deltaW/k).^2);
  elseif opcion == 2
    cN = 1./(1 + (deltaN/k).^2);
    cS = 1./(1 + (deltaS/k).^2);
    cE = 1./(1 + (deltaE/k).^2);
    cW = 1./(1 + (deltaW/k).^2);
  end

  imdif1 = imdif1 + lambda*(cN.*deltaN1 + cS.*deltaS1 + cE.*deltaE1 + cW.*deltaW1);
  imdif2 = imdif2 + lambda*(cN.*deltaN2 + cS.*deltaS2 + cE.*deltaE2 + cW.*deltaW2);
  psnr1(i)=PSNR_V(original1_d, imdif1);
  psnr2(i)=PSNR_V(original2_d, imdif2);
%  Las siguientes l�neas permiten ver la progresi�n de las im�genes

 % subplot(ceil(sqrt(niter)),ceil(sqrt(niter)), i)
 % imagesc(imdif), colormap(gray), axis image

end

