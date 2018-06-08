function plotBars( y, x, option, param, img )
%PLOTBARS Summary of this function goes here
%   Detailed explanation goes here
% len_x = length(x)
% len_y = length(y)
if param == "k"
    name = strcat("PSNR value for ", img, " with option ", num2str(option));
    figure('Name',name,'NumberTitle','off');
    bar(x,y,'b')
    title('K vs PSNR')
    xlabel('K parameter')
    ylabel('PSNR value')

elseif param == "lambda"
    name = strcat("PSNR value for ", img, " with option ", num2str(option));
    figure('Name',name,'NumberTitle','off');
    bar(x,y,'b')
    title('LAMBDA vs PSNR')
    xlabel('LAMBDA parameter')
    ylabel('PSNR value')
    
elseif param == "comb"
    str_x = strings(1, length(x));
    
    for col = 1: size(x,2)
        str_x(:,col) = strcat(num2str(x(1,col)),"-",num2str(x(2,col)));
    end
    
%     disp(str_x)
    
    name = strcat("PSNR value for ", img, " with option ", num2str(option));
    figure('Name',name,'NumberTitle','off');
%     plot(categorical(str_x),y,'-b')
    plot(y,'-b')
    title('K, LAMBDA vs PSNR')
    xlabel('(K, LAMBDA) combination')
    ylabel('PSNR value')

end


end

