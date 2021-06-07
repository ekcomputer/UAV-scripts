dir_in='/Volumes/Gleason2/UAV Data/20180821/Phantom/Mapir/Photo2/';
dir_in='/Users/ethankyzivat/Desktop/';
% img_in='/Users/ethankyzivat/Desktop/2018_0821_122125_054.jpg';
files=ls(dir_in);
files=textscan(files, '%s', 'Delimiter', '\t');
files=files{:};
for i = 1:length(files)
    clear cir filepath
    clf
    title(files{i})
    disp(files{i})
    filepath=[dir_in, files{i}];
    cir=imread(filepath);
    cir=im2double(cir);
    r_ndwi=(cir(:,:,2)-cir(:,:,3))./(cir(:,:,3)+cir(:,:,2));
    % imagesc(r_ndwi)
    subplot(322)
    histogram(cir(:,:,1))
    subplot(324)
    histogram(cir(:,:,2))
    subplot(326)
    histogram(cir(:,:,3))
    subplot(121)
    imagesc(r_ndwi); axis equal
    pause
end
