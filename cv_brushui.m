function  [sel,bH] = cv_brushui(figH)

set(0,'CurrentFigure',figH)
bH = brush(figH);
set(bH,'enable','on','ActionPostCallback',@selection)
uiwait

if isvalid(figH)
    set(bH,'enable','off');
    if ~isempty(getappdata(figH,'Xselected'))
        sel(:,1) = getappdata(figH,'Xselected');
        sel(:,2) = getappdata(figH,'Yselected');
    else
        sel = [];
    end
else
    sel = [];
    return
end

function [xs,ys] = selection(src,event)
child = get(event.Axes,'Children');
xs = child.XData(logical(get(event.Axes.Children,'BrushData')));
ys = child.YData(logical(get(event.Axes.Children,'BrushData')));
setappdata(src,'Xselected',xs)
setappdata(src,'Yselected',ys)
uiresume