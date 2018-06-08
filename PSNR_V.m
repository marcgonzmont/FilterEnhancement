function psnr=PSNR_V(I1, I2)
% function psnr=PSNR(I1, I2)
% Funcion que calcula la Relaci?n Se?al a Ruido de Pico entre dos imagenes


if (size(I1)~=size(I2))
    error('Las im?genes tienen que tener el mismo tama?o');
end

if ((I1-I2)==0)
    error('Las im?genes son iguales');
end

maximo=max(I1(:));

N=size(I1,1);
M=size(I1,2);
P=size(I1,3);

if (P==1)
    MSE=(1/(M*N))*sum(sum((I1-I2).^2));
else
    MSE=(1/(M*N*P))*sum(sum(sum((I1-I2).^2)));
end

psnr=20*log10(maximo/sqrt(MSE));

end