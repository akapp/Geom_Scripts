function hilightHandle = cv_hilightsegment(fighandle,segment,isclean)

% hilightHandle = cv_highlightsegment(fighandle,segmentisclean)
% hilightS = cv_highlightsegment(fighandle,segment,0);

options = getappdata(fighandle,'options');
x = getappdata(fighandle,'xdata');
y = getappdata(fighandle,'ydata');
z = getappdata(fighandle,'zdata');

l = segment.line;
if ~isclean
    idx = segment.refidx(1):segment.refidx(2);
else
    idx = segment.clean;
end

pause(0.2);
hilightHandle = plot3(x{l}(idx),y{l}(idx),z{l}(idx),'-',...
    'Color',options.prefs.hilight.Color,...
    'linewidth',options.prefs.hilight.LineWidth);
hilightHandle.Color(4)=0.4;

