function [ out ] = ListCategory
%

%% Nr

nrPics = 432;
nrCat  = 3;
nrPicsPerCat = nrPics/nrCat;


%% Out

in = {
    
'NEU' 1 144

'ISO_F_1'    1 36
'ISO_FFH_3'  1  8
'ISO_FFHH_4' 1  8
'ISO_FH_2'   1 84
'ISO_FHH_3'  1  8

'ERO_ANA_FH_2'   1  24
'ERO_ANA_F_1'    1  24
'ERO_MUL_FFH_3'  1   8
'ERO_MUL_FFHH_4' 1   8
'ERO_MUL_FHH_3'  1   8
'ERO_MUL_FH_2'   1  24
'ERO_PET_F_1'    1  12
'ERO_PET_FH_2'   13 24
'ERO_VAG_FH_2'   1  24

};


%% Check total

total = 0;
for i = 1 : size(in,1)
    total = total + in{i,3}-in{i,2}+1;
end
assert(total==nrPics,'total nr img is not %d', nrPics);


%% Check each category

Category = {'NEU' 'ISO' 'ERO'};

for c = 1 : length(Category)
    
    name = Category{c};
    res  = regexp(in(:,1),name);
    res  = ~cellfun(@isempty,res);
    data = in(res,:);
    
    subtotal = 0;
    for i = 1 : size(data,1)
        subtotal = subtotal + data{i,3}-data{i,2}+1;
    end
    assert(subtotal==nrPicsPerCat,'total nr img is not %d', nrPicsPerCat);
    
    out.(name) = data;
    
end


end % end
