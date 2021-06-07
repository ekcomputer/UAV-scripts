% function to plot lat/long/z from EXIF metadata of gps  camera jpgs.
% updated for PAD data, and to include IR camera field
% NOTE: need to manually create .proj file
% updated 9/23/2019 EK for camera, not uav

%% i/o
clear; close all

    % PAD 2019
% tablePath='F:\PAD2019\PAD_2019_Photos\output\csv\Pad19_photos.csv';
% shapePath='F:\PAD2019\PAD_2019_Photos\output\shp\Pad19_photos.shp';
% files=dir('F:\PAD2019\PAD_2019_Photos\*.jpg');

%     %ABoVE 2017
% tablePath='D:\AboveData\FieldPhotos\out\csv\Above17_photos.csv';
% shapePath='D:\AboveData\FieldPhotos\out\shp\Above17_photos.shp';
% files=dir('D:\AboveData\FieldPhotos\ABoVE 2017 Fieldwork\*.jpg');

    %ABoVE 2017- SC
% tablePath='D:\GoogleDrive\ABoVE top level folder\ABoVE_Field_Photos_for_Ethan\out\csv\Above17_photos_SC.csv';
% shapePath='D:\GoogleDrive\ABoVE top level folder\ABoVE_Field_Photos_for_Ethan\out\shp\Above17_photos_SC.shp';
% files=dir('D:\GoogleDrive\ABoVE top level folder\ABoVE_Field_Photos_for_Ethan\*.jpg');

    %ABoVE 2019 - Clayton E
tablePath='F:\PAD2019\ClaytonElder\Collars\ek_csv\collar_photos19.csv';
shapePath='F:\PAD2019\ClaytonElder\Collars\ek_shp\collar_photos19.shp';
files=dir('F:\PAD2019\ClaytonElder\Collars\Pictures\*\*.jpg');

%% loop

i=1;
for n= 1:length(files)
    path=[files(n).folder, '\', files(n).name];
    if files(n).bytes > 300000
        info=imfinfo(path);
        if any(find(cell2mat(strfind(fieldnames(info), 'GPSInfo')))) && numel(fieldnames(info.GPSInfo)) >= 5
%          numel(fieldnames(info)) >= 26 
            coords(i).lat=info.GPSInfo.GPSLatitude;
            coords(i).lat=coords(i).lat(1)+coords(i).lat(2)/60+coords(i).lat(3)/3600;
            coords(i).long=info.GPSInfo.GPSLongitude;
            coords(i).long=-(coords(i).long(1)+coords(i).long(2)/60+coords(i).long(3)/3600);
            try
                coords(i).z=info.GPSInfo.GPSAltitude;
            catch
                coords(i).z=-9999
            end
            coords(i).filename=info.Filename;
            try
                coords(i).datetime=info.DateTime;
            catch
                coord(i).datetime='2019:01:01 00:00:00';
            end
            try
                coords(i).cam=[info.Make, ' ', info.Model];
            catch
                coords(i).cam='';
            end
            if mod(i, 100)==0
                disp(i)
            end
            if isempty(coords(i).filename)
                pause
            end
            i =i+1; % if loop was successful.
        else fprintf('%d: No GPS info\n', n)
        end
    else
        fprintf('%d: File error\n', n)
    end
end
disp('Finished loop.')
ctable=struct2table(coords);
writetable(ctable, tablePath);

% write shp
filesStruct=rmfield(coords, {'lat','long'});
p= mappoint([coords.long], [coords.lat], filesStruct);
shapewrite(p, shapePath);

%% view
% geoshow(shapePath)