% function to plot lat/long/z from EXIF metadata of jpgs.

% dir_in='F:\Box Sync\Gleason 2\UAV Data\';
dir_in='F:\Sask2018\MavicPro1\';
files=dir ('F:\Sask2018\MavicPro1\*\*\*.jpg');

for i= 1:length(files)
    path=[files(i).folder, '\', files(i).name];
    info=imfinfo(path);
    coords(i).lat=info.GPSInfo.GPSLatitude;
    coords(i).lat=coords(i).lat(1)+coords(i).lat(2)/60+coords(i).lat(3)/3600;
    coords(i).long=info.GPSInfo.GPSLongitude;
    coords(i).long=-(coords(i).long(1)+coords(i).long(2)/60+coords(i).long(3)/3600);
    coords(i).z=info.GPSInfo.GPSAltitude;
    coords(i).filename=info.Filename;
    if mod(i, 100)==0
        disp(i)
    end
end

ctable=struct2table(coords);
tablePath='F:\Sask2018\MavicPro1\output\SaskUAV.csv';
writetable(ctable, tablePath);

% write shp
filesStruct=rmfield(coords, {'lat','long'});
p= mappoint([coords.long], [coords.lat], filesStruct);
shapePath='F:\Sask2018\MavicPro1\output\shp\SaskUAV.shp';
shapewrite(p, shapePath);