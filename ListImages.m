function list = ListImages
% Read the file ListImages.txt


%% Read the file

fid = fopen('ListImages.txt', 'rt');
if fid == -1
    error('file cannot be opened : %s',filename)
end
content = fread(fid, '*char')'; % read the whole file as a single char
fclose(fid);


%% Parse the content

list = regexp(content,'\n','split')';

list = sort(list); %#ok<TRSRT>


end % function
