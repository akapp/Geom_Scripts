root = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/';

raw = load(fullfile(root,'Results','data_ACA_Area.mat'));
clean = load(fullfile(root,'Results','data_ACA_Area_cleaned.mat'));

for j = 1:length(clean.RACA)
    clean.RACA{j}(:,2)=zeros(size(clean.RACA{j}(:,1)));
    for i = 1:length(clean.RACA{j})
        if size(find(raw.RACA{j}==clean.RACA{j}(i,1)),1)==1
            clean.RACA{j}(i,2) = find(raw.RACA{j}==clean.RACA{j}(i,1));
        else
            fprintf(['j = ',num2str(j),';  i = ',num2str(i),'\r'])
            % keyboard
            % size(find(raw.RACA{j}==clean.RACA{j}(i,1)))
            tmp = find(raw.RACA{j}==clean.RACA{j}(i,1));
            dt = find(raw.RACA{j}==clean.RACA{j}(i,1))-clean.RACA{j}(i-1,2);
            dt(dt<=0)=1000;
            clean.RACA{j}(i,2) = tmp(min(dt));
        end
    end
end


for j = 1:length(clean.LACA)
    clean.LACA{j}(:,2)=zeros(size(clean.LACA{j}(:,1)));
    for i = 1:length(clean.LACA{j})
        if size(find(raw.LACA{j}==clean.LACA{j}(i,1)),1)==1
            clean.LACA{j}(i,2) = find(raw.LACA{j}==clean.LACA{j}(i,1));
        else
            fprintf(['j = ',num2str(j),';  i = ',num2str(i),'\r'])
            % keyboard
            % size(find(raw.LACA{j}==clean.LACA{j}(i,1)))
            tmp = find(raw.LACA{j}==clean.LACA{j}(i,1));
            dt = find(raw.LACA{j}==clean.LACA{j}(i,1))-clean.LACA{j}(i-1,2);
            dt(dt<=0)=1000;
            clean.LACA{j}(i,2) = tmp(min(dt));
        end
    end
end