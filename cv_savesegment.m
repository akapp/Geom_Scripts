function [options,A] = cv_savecleansegment(options,segment,cleanFig)

% Save Segment
if options.prefs.segment.asktosave
    A = questdlg('Would you like to save the segment now?');
else
    A='Yes';
end
if strcmp(A,'Yes')
   
   % Input FileName
   if ~isfield(options,'filename')
       iA = inputdlg(['Enter filename for: ',segment.name,],'Input Filename',1,{'seg_'});
       if isempty(iA)
           close(cleanFig)
           return
       else
           [~,filename] = fileparts(iA{1});
       end
   else
       [~,filename] = fileparts(options.filename{1});
   end
   
  
   if exist(fullfile(options.ptdir,[filename,'.mat']),'file')
       A = questdlg('File already exists. Would you like to overwrite ',...
           filename,' Now?');
       if strcmp(A,'Yes')
           save(fullfile(options.ptdir,[filename,'.mat']),'-struct','segment')
       else
           return
       end
   else
      save(fullfile(options.ptdir,[filename,'.mat']),'-struct','segment')
   end
elseif strcmp(A,'Cancel')
    return
end

if exist('cleanFig','var')
    
    % Save Clean Area figure
    if ~exist([options.ptdir,'/figures'],'dir')
        mkdir([options.ptdir,'/figures'])
    end
    try cv_busyaction(handles,'on','Saving Figure...'); end
    savefig(cleanFig,[options.ptdir,'/figures/',segment.name,'_cleanArea.fig'])
    close(cleanFig)
    try cv_busyaction(handles,'off'); end
    
end
    