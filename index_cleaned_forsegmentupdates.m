root = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data';
clean = load(fullfile(root,'Results','data_ACA_Area_cleaned'));
ptdir = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061/vmtk';
%
[~,ptname] = fileparts(ptdir);
if strcmp(ptname,'vmtk')
    [~,ptname] = fileparts(fileparts(ptdir));
end
%
index_cleaned_ACA_Area

ptidx = find(contains(clean.ptNames,ptname));

files = dir(ptdir);
files={files(contains({files.name},'seg_')).name}';
files=files(~contains(files,'cleaned'));

f.ACA = files(contains(files,'A1'));
f.PCA = files(contains(files,'P1'));
f.ACom = files(contains(files,'acom'));

data = cv_readindat(ptdir);
for i = 1:length(f.ACA)
    segment = load(fullfile(ptdir,f.ACA{i}));
    if strcmp(f.ACA{i}(5),'r')
        cleandat = clean.RACA{ptidx};
    else
        cleandat = clean.LACA{ptidx};
    end
    if isfield(segment,'segment')
        load(fullfile(ptdir,f.ACA{i}))
        save(fullfile(ptdir,f.ACA{i},'-struct','segment'))
    end
    if size(segment.refidx,2)==2
        segment.refidx = segment.refidx(1)+cleandat(:,2)-1;
    end
        segment = cv_updatesegment(data,segment);
        [~,filename]=fileparts(f.ACA{i});
        save(fullfile(ptdir,[filename,'_cleaned.mat']),'-struct','segment')
end