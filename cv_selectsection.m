function segment = cv_selectsection(handles)

% guifig = findall(0,'Tag','guifig')
guifig = handles.guifig;
options = getappdata(guifig,'options');
data = getappdata(guifig,'data');
segment = getappdata(guifig,'segment');
sections = getappdata(guifig,'sectionsdata');
sectionHandles = getappdata(guifig,'sectionHandles');

pause(0.2)
dcm_obj = datacursormode(guifig);
set(dcm_obj,'DisplayStyle','datatip','Enable','on')

% Data Tip
pause(0.4)
set(0,'CurrentFigure',guifig)
msg =  ['Press ''r'',''d'' for Reference. ',...
        'Press ''k'', ''c'', ''b'' for Clean. ',...
        'Press . to display reference index.',...
        'Press ''q'' to exit. ',...
        'Press Space to continue.'];
cv_busyaction(handles,'on',msg)
key = cv_waitforkeypress(handles,{' ','q','d','r','k','b','c','.'});
cv_busyaction(handles,'off',msg)

% idx = processcursorsections(c1,data,sections);
c1 = getCursorInfo(dcm_obj);
sectionIdx=[];
for i = 1:length(sections)
    
    X = data.sections(sections{i},:);
    a = find(X(:,1)==c1.Position(:,1));
    b = find(X(:,1)==c1.Position(:,2));
    c = find(X(:,1)==c1.Position(:,3));
    if isempty([a,b,c])
        continue
    else
        sectionIdx(end+1) = i;
    end
    if length(sectionIdx)>1
        keyboard
    end
    
end

% Get indices from tags
tags = get([sectionHandles{:}],'Tag');
rIdx = find(contains(tags,'reference'));
cIdx = find(contains(tags,'clean'));
saveon = false;
% Now determine what to do
while ~strcmp(key,' ')
    
    switch key
        case {'.'}
            keyboard
            fprintf('Reference Index: %0.f\r',sectionIdx)
        case {'r','d'} % red, delete
            if ~ismember(sectionIdx,rIdx) % then change to reference)
                rIdx = sort([rIdx;sectionIdx]); % add to reference
                cIdx = setdiff(cIdx,sectionIdx); % remove from clean
                set(sectionHandles{sectionIdx},'Tag','reference')
                set(sectionHandles{sectionIdx},'Color','r')
                idx = segment.refidx(1):segment.refidx(2);
                segment.cleanidx = idx(cIdx);
                saveon = true;
                keyboard
                % return
            end
            
        case {'k','c','b'} % keep, clean, blue
            if ~ismember(sectionIdx,cIdx)
                cIdx = sort([cIdx;sectionIdx]); % add to clean
                set(sectionHandles{sectionIdx},'Tag','clean')
                set(sectionHandles{sectionIdx},'Color','b')
                idx = segment.refidx(1):segment.refidx(2);
                segment.cleanidx = idx(cIdx);
                saveon = true;
                keyboard
                % return
            end
            
        case {'q'} % quit
            
            return
    end
    if saveon
        % Save clean segment
        filename = segment.filename;
        segment = rmfield(segment,'filename');
        save(fullfile(options.ptdir,filename),'-struct','segment')
    end
end

keyboard
% cursorMode = datacursormode(guifig);
cursorMode.CurrentCursor

