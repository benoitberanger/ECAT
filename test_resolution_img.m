clear
clc

p = fullfile(fileparts(pwd),'img');

f = gfile(p,'.*');
f = cellstr(f{1});

c = cell(size(f));

for i = 1 : length(f)
    
    c{i} = Image( f{i} );
    
    Size(i,1:3) = size(c{i}.X);
    Ratio(i,1) = Size(i,2)/Size(i,1);
    
%     All{i,1}
    
end

r = char(unique(cellstr(rats(Ratio))))
