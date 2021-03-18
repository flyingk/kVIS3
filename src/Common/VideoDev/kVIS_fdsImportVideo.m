function kVIS_fdsImportVideo(hObject, ~)

[fds, name] = kVIS_getCurrentFds(hObject);

[file, path] = uigetfile('*.mp4');

vid = VideoReader(fullfile(path, file));

f = readFrame(vid);


figure()

imshow(f)


fds.linkedVideo = vid;

kVIS_updateDataSet(hObject, fds, name);

end