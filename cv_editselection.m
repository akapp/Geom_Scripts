function segment = cv_editselection(handles)

% guifig = findall(0,'Tag','guifig')
    
    guifig = handles.guifig;
    options = getappdata(guifig,'options');
    data = getappdata(guifig,'data');
    segment = getappdata(guifig,'segment');
    keyboard
    
    %
    delete(getappdata(guifig,'hilightSegment'))
    rmappdata(guifig,'hilightSegment')    
    %
    
    hilightSegment = cv_hilightsegment(guifig,segment,0);
    setappdata(guifig,'hilightSegment',hilightSegment)
    
    segment = cv_updatesegment(data,segment);
    setappdata(guifig,'segment',segment)

    return
    
%% OTHER OPTIONS FOR NEW WINDOW
segment = cv_updatesegment(data,segment)


try segment = getappdata(guifig,'segment'); catch; return; end
try hilight = getappdata(guifig,'hilightSegment'); catch; return; end

xH = get(hilight,'XData');
yH = get(hilight,'YData');
zH = get(hilight,'ZData');

% Plot line (see cv_plotline)
chkFig = cv_popoutwin('Selected Segment'); hold on
plot3(x{segment.line},y{segment.line},z{segment.line},'b-');

% Highlight segment (cv_hilightsegment)
l = segment.line;
idx = segment.refidx(1):segment.refidx(2);
plot3(x{l}(idx),y{l}(idx),z{l}(idx),'b*');
hilightHandle = plot3(x{l}(idx),y{l}(idx),z{l}(idx),'-',...
    'Color',options.prefs.hilight.Color,...
    'linewidth',options.prefs.hilight.LineWidth);
hilightHandle.Color(4)=0.4;


