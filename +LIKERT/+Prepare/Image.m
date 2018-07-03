function [ image , list ]= Image( Parameters )
global S

[ list ] = CheckImages;

image = struct;

img_dir = fullfile(fileparts(pwd),'img');

t0 = GetSecs;

fprintf('Loading images ... (it may take a while) \n')

sz = size( list , 1 );

Xmax = S.PTB.wRect(3);
Ymax = S.PTB.wRect(4);

for i = 1 : sz
    name = fullfile(img_dir,list{i,2});
    fprintf('Loading %3d/%.3d : %s \n', i, sz, name);
    obj = Image( name , [S.PTB.CenterH S.PTB.CenterV], [], S.Mask );
    obj.map = 0; % useless
    obj.alpha = 255*ones(size(obj.X,1),size(obj.X,2),'uint8'); % fully opaque
    obj.LinkToWindowPtr( S.PTB.wPtr )
    obj.MakeTexture;
    
    % Resize
    
    X = obj.baseRect(3);
    Y = obj.baseRect(4);
    
    ratioX = X/Xmax;
    ratioY = Y/Ymax;
    
    ratioMax = max(ratioX,ratioY);
    if ratioMax > 1
        ratioShrink = 1 / ratioMax;
        obj.Rescale(ratioShrink);
    end
    
    obj.AssertReady % just to check
    image.( list{i,1} ) = obj;
end

fprintf('Loading of images took : %g \n', GetSecs-t0);

end % function
