function options = cv_handles2options(options,handles)

% Patient Directories
if length(options.uipatdirs)==1
    options.ptdir = options.uipatdirs{1};
    [~,options.ptname] = fileparts(options.ptdir);
    [~,options.uiptnames] = cellfun(@(x) fileparts(x),options.uipatdirs,'uni',0);
else
    options.ptdir = options.uipatdirs{handles.patdropdown.Value};
    options.ptname = [num2str(length(options.uipatdirs)),' patients selected'];
    [~,options.uiptnames] = cellfun(@(x) fileparts(x),options.uipatdirs,'uni',0);
end