function [ PreA, PreB, PostA , PostB ] = SplitImages()
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
    
    
    GRP1 = GRP1(Shuffle(1:length(GRP1)));
    GRP2 = GRP2(Shuffle(1:length(GRP2)));
    
    GRP1_A = GRP1(1:end/2);
    GRP1_B = GRP1(end/2+1:end);
    
    GRP2_A = GRP2(1:end/2);
    GRP2_B = GRP2(end/2+1:end);
    
    PreA. (catname) = GRP1_A;
    PreB. (catname) = GRP1_B;
    PostA.(catname) = GRP2_A;
    PostB.(catname) = GRP2_B;
    
end


end % end
