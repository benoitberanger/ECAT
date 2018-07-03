function [ image , list ]= Image()
global S

[ list ] = CheckImages;

image = struct;

img_dir = fullfile(fileparts(pwd),'img');

t0 = GetSecs;

fprintf('Loading images ... (it may take a while) \n')

sz = size( list , 1 );

for i = 1 : sz
    name = fullfile(img_dir,list{i,2});
    fprintf('Loading %3d/%.3d : %s \n', i, sz, name);
    obj = Image( name , [S.PTB.CenterH S.PTB.CenterV], [], S.Mask );
    obj.map = 0;
    obj.alpha = 255*ones(size(obj.X,1),size(obj.X,2),'uint8');
    obj.LinkToWindowPtr( S.PTB.wPtr )
    obj.MakeTexture;
    obj.AssertReady % just to check
    image.( list{i,1} ) = obj;
end

fprintf('Loading of images took : %g \n', GetSecs-t0);

end % function
