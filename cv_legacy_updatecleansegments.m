ptdir = pwd;
data = cv_readindat(ptdir);
matfiles = cv_parsedirectory(ptdir,'.mat');

for i = 1:length(matfiles)
	segment = load(matfiles{i});
    if isfield(segment,'segment')
        load(matfiles{i})
    end
    segment = cv_updatesegment(data,segment);
    save(matfiles{i},'-struct','segment')
end