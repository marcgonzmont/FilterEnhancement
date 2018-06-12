clear all; close all; clc;

% Set image size
[row, col] = deal(256);
exponential = true;
%
tic
%
source_path = fullfile('..\Data\P1\Imagenes_Ap4');
file_names = struct2cell(dir(fullfile(source_path,'*.dcm')));
file_names = file_names(1,:);
file_names = natsortfiles(file_names);
n_files = length(file_names);
all_images = zeros(col, row, n_files);
TE = zeros(1, n_files);
Y = repmat(int16(0), [256 256 1 20]);

figure('Name','DICOM Images','NumberTitle','off');
for i=1:n_files
    name = file_names{i};
    info = dicominfo(fullfile(source_path, name));
    [X, map] = dicomread(info);
    ax = subplot(2, 4, i);
    imshow(X,[], 'Parent', ax)
    X=double(X);
    all_images(:,:,i) = X;
    TE(i) = sscanf(name,'IM-TE%d');
end
% tightfig;

B = zeros(col, row);
if exponential
    for i=1:row
        parfor j=1:col
            %         AB=polyfit(TE, log([all_images(i,j,1), all_images(i,j,2),...
            %             all_images(i,j,3), all_images(i,j,4), all_images(i,j,5),...
            %             all_images(i,j,6), all_images(i,j,7), all_images(i,j,8)]), 1);
            AB=fit(TE', [all_images(i,j,1), all_images(i,j,2),...
                all_images(i,j,3), all_images(i,j,4), all_images(i,j,5),...
                all_images(i,j,6), all_images(i,j,7), all_images(i,j,8)]', 'exp1');
            B(i,j)=AB(2);
        end
    end
    %
    %
    figure()
    imshow((uint16(B*5))), title('Iron map from images')
else
    for i=1:row
        parfor j=1:col
            AB=polyfit(TE, log([all_images(i,j,1), all_images(i,j,2),...
                all_images(i,j,3), all_images(i,j,4), all_images(i,j,5),...
                all_images(i,j,6), all_images(i,j,7), all_images(i,j,8)]), 2);
            B(i,j)=AB(2);
        end
    end
    %
    %
    figure()
    imshow((uint8(B*15))), title('Iron map from images')
end


%
toc