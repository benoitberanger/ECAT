function [ Run1 , Run2 ] = SplitImages()
%


%% Randomizer

rng('default')
rng('shuffle')


%% Fech the input lists : images & category

[ Category ] = ListCategory;

% [ List ] = CheckImages;

Categ = fieldnames(Category);


%% Slice into 2 groupes each subcategory


for c = 1 : length(Categ)
    catname = Categ{c};
    
    data = Category.(catname);
    
    subCat = data(:,1);
    
    GRP1 = [];
    GRP2 = [];
    
    for sub  = 1 : length(subCat)
        
        subcatname = subCat{sub};
        
        from = data{sub,2};
        to   = data{sub,3};
        
        vect = Shuffle(from:to);
        
        nrItemsPerRun = length(vect)/2;
        
        Grp1 = cell(nrItemsPerRun,1);
        Grp2 = cell(nrItemsPerRun,1);
        
        for v = 1 : nrItemsPerRun
            Grp1{v} = sprintf('%s_%d',subcatname,vect(v));
            Grp2{v} = sprintf('%s_%d',subcatname,vect(v+nrItemsPerRun));
        end
        
        GRP1 = [GRP1;Grp1];
        GRP2 = [GRP2;Grp2];
        
    end
    
    Run1.(catname) =  GRP1(Shuffle(1:length(GRP1)));
    Run2.(catname) =  GRP2(Shuffle(1:length(GRP2)));
    
end


end % end
