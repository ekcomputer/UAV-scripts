% for playing around with thresholding

clear; clc; close all
%% I/O
param.test_dir_in='F:\PAD2019\water_classification\test_clips\';
param.test_dir_out='F:\PAD2019\water_classification\output\';
param.logDir='F:\PAD2019\water_classification\logs\';
param.RegionGrowing=0; % set to test on global NDWI only
param.parallel=0; %parrallel processing?
nir=3; r=1; g=2;
logfile=[param.logDir, 'log.txt'];
fileQueue=[2]; 
exclude=[];

%% Run
files=cellstr(ls([param.test_dir_in, '*.tif']));
disp('Files:')
disp([num2cell([1:length(files)]'), files])

% fileQueue=[1:length(files)];
fileQueue=setdiff(fileQueue, exclude);
% tileSize has to be a multiple of 16, and apparentely
% needs to be same as processing window size

%     parpool(4);
datecode=char(datetime('now','Format','yyyy-MM-dd-HHmm'));

disp(['Started:    ', datestr(datetime)])
%% Loop
for i=fileQueue
    fprintf('File number: %d\n', i)
    name_in=files{i}; %27
    img_in=[param.test_dir_in, name_in];
    fprintf('Classifying file:\t%s\n', name_in);
    [cir, R]=geotiffread(img_in);
    cir=im2single(cir);
    imagesc(cir); axis image
    
    %% ndwi
    cir_index=(cir(:,:,g)-cir(:,:,nir))./(cir(:,:,g)+cir(:,:,nir));
    
    if size(cir, 3) ==4 % in case alpha channel shows as band
        cir(:,:,4)=[];
    end

    % Process images
end