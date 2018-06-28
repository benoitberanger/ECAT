function  [ list ] = CheckImages
%CHECKIMAGES will check if images name is correct

% if nargin < 2
% end

list = ListImages;

img_dir = fullfile(fileparts(pwd),'img');

img_dir_content = dir(img_dir);
img_dir_content = img_dir_content(3:end); % remove "." & ".."

filename = {img_dir_content.name}';

for l = 1 : length(list)
    
    res = regexp(filename,['^' list{l} '\..*']);
    idx = find(~cellfun(@isempty,res));
    
    if isempty(idx)
        name = '???';
        fprintf('%s ---> %s \n',list{l},name)
    else
        for n = 1:numel(idx)
            name = filename{idx(n)};
            fprintf('%s ---> %s',list{l},name)
            if n > 1
                fprintf(' !!!!! doublon !!!!!')
            end
            fprintf('\n')
        end
    end
end


end % function
