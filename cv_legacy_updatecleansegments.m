% type cv_legacy_updatecleansegments to run file
% select patient folder to update all segments
% Choose as many patients as you want.

% ptdir = pwd;

uipatdirs = cv_uigetdir;

%
for i = 1:length(uipatdirs)
    ptdir = uipatdirs{i};

    data = cv_readindat(ptdir);
    matfiles = cv_parsedirectory(ptdir,'.mat');
    fullmatfiles = strcat([ptdir,'/'],matfiles);
    for j = 1:length(fullmatfiles)
        segment = load(fullmatfiles{j});
        if isfield(segment,'segment')
            load(fullmatfiles{j})
        end
        segment = cv_updatesegment(data,segment);
        save(fullmatfiles{j},'-struct','segment')
    end
    
end