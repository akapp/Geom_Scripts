function selFig = cv_polyselect(src,event,figH)
% Plots selfig and selfig buttonwindow

% key=0;
% fprintf('Press any button to continue\r')
% while key==0
%     key = waitforbuttonpress;
%     pause(0.2)
% end
options.prefs = cv_defaultprefs;

set(0,'CurrentFigure',figH)
if ~isequal([0 90],get(figH.CurrentAxes,'view'))
   warning('set axis to 0 90 for proper function of selectdata3') 
   view([0 90])
end

fprintf('Select data for further processing\r')
[pind,xs,ys,zs] = selectdata3('selectionmode','lasso','Flip',1);
setappdata(figH,'pointslist',pind)
setappdata(figH,'xselected',xs)
setappdata(figH,'yselected',ys)
setappdata(figH,'zselected',zs)

disp(table(pind,xs,ys,zs,'VariableNames',{'pointslist','xselect','yselect','zselect'}))
% disp({'pointslist','xselect','yselect','zselect'})
% disp([pind,xs,ys,zs])

%% Check selected data and plot
x = getappdata(figH,'xdata');
y = getappdata(figH,'ydata');
z = getappdata(figH,'zdata');
chk = cv_checkxyzselect(x,y,z,pind,xs,ys,zs);

% Plot selected
idx=find(~cellfun(@isempty,x))';
selFig = figure(...
    'Name',options.prefs.selfig.Name,...
    'Tag',options.prefs.selfig.Tag,...
    'Position',options.prefs.selfig.Position,...
    'NumberTitle','off',... 
    'CloseRequestFcn', @closesattelites);
hold on
c = getappdata(figH,'LineColors');
for i=idx
    plot3(xs{i},ys{i},zs{i},'*','color',c(i,:));
end
cameratoolbar('Show')
axis equal

buttonwin = cv_buttonpanel(selFig);
set(buttonwin, ...
    'Name',options.prefs.selfig.bwinName, ...
    'Position',options.prefs.selfig.bwinPosition)
setappdata(selFig,'buttonwin',buttonwin)
setappdata(figH,'selFig',selFig)

% Highlight in CenterlinesPlot
% set(0,'CurrentFigure',figH)
% hold on
% l = segment.line;
% if isfield(segment,'cleanidx')
%         idx = segment.cleanidx;
% else;   idx = segment.refidx(1):segment.refidx(2); end
% highlightH = plot3(x{l}(idx),y{l}(idx),z{l}(idx),'r-','linewidth',10);

function closesattelites(src,evnt)
buttonwin = getappdata(src,'buttonwin');
try    
    close(buttonwin)
end
    
    delete(src)


