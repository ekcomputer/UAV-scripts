% function to plot lat/long/z from EXIF metadata of jpgs.
% updated for PAD data, and to include IR camera field
% NOTE: need to manually create .proj file


% dir_in='F:\Box Sync\Gleason 2\UAV Data\';
% dir_in='F:\Sask2018\MavicPro1\';
files=[dir('F:\PAD2018\UAV_working\*\*\*\*\*.jpg');...
    dir('F:\PAD2018\UAV_working\*\*\*\*.jpg');...
    dir('F:\PAD2018\UAV_working\*\*\*.jpg')];

for i= 1:length(files)
    path=[files(i).folder, '\', files(i).name];
    info=imfinfo(path);
    coords(i).lat=info.GPSInfo.GPSLatitude;
    coords(i).lat=coords(i).lat(1)+coords(i).lat(2)/60+coords(i).lat(3)/3600;
    coords(i).long=info.GPSInfo.GPSLongitude;
    coords(i).long=-(coords(i).long(1)+coords(i).long(2)/60+coords(i).long(3)/3600);
    coords(i).z=info.GPSInfo.GPSAltitude;
    coords(i).filename=info.Filename;
    if ~isempty(strfind(coords(i).filename,'Mavic')) & ~isempty(strfind(coords(i).filename,'MAPIR'))
        coords(i).cam='MI'; %mavic ir
    elseif ~isempty(strfind(coords(i).filename,'Phantom')) & ~isempty(strfind(coords(i).filename,'MAPIR'))
        coords(i).cam='PI'; %phantom ir
    elseif ~isempty(strfind(coords(i).filename,'Mavic'))
        coords(i).cam='M'; %mavic
    elseif ~isempty(strfind(coords(i).filename,'Phantom'))
        coords(i).cam='P'; %phantom
    else
        coords(i).cam='NA'; %phantom ir
    end
    if mod(i, 100)==0
        disp(i)
    end
    if isempty(coords(i).filename)
        pause
    end
end
disp('Finished loop.')
ctable=struct2table(coords);
tablePath='F:\PAD2018\UAV_working\output\PadUAV.csv';
writetable(ctable, tablePath);

% write shp
filesStruct=rmfield(coords, {'lat','long'});
p= mappoint([coords.long], [coords.lat], filesStruct);
shapePath='F:\PAD2018\UAV_working\output\shp\PadUAV.shp';
shapewrite(p, shapePath);

%% view
% geoshow(shapePath)