function A = cv_savecleansegment(options,segment,cleanFig)

% A = cv_savecleansegment(options,segment,cleanFig)

if isfield(segment,'filename')
    segment = rmfield(segment,'filename');
end

if isfield(options,'filename')
    [~,filename] = fileparts(options.filename{1});
else % Input FileName
    A = inputdlg(['Enter filename for: ',segment.name,],'Input Filename',1,{'seg_'});
    if isempty(A)
        A = 'Cancel';
        close(cleanFig)
        return
    else
        [~,filename] = fileparts(A{1});
    end
end

% Save
if exist(fullfile(options.ptdir,[filename,'.mat']),'file')
    A = questdlg('Would you like to save the the cleaned segment now?',filename);
    if strcmp(A,'Yes')
        save(fullfile(options.ptdir,[filename,'.mat']),'-struct','segment')
    else
        close(cleanFig);
        return
    end
else
    A = 'Yes';
    save(fullfile(options.ptdir,[filename,'.mat']),'-struct','segment')
end

if exist('cleanFig','var') & isvalid(cleanFig)
    
    % Save Clean Area figure
    if ~exist([options.ptdir,'/figures'],'dir')
        mkdir([options.ptdir,'/figures'])
    end
    try cv_busyaction(handles,'on','Saving Figure...'); end
    savefig(cleanFig,[options.ptdir,'/figures/',segment.name,'_cleanArea.fig'])
    close(cleanFig)
    try cv_busyaction(handles,'off'); end
    
end
