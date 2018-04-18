function selFig = cv_polyselect(fighandle)
% Plots selfig and selfig buttonwindow

% key=0;
% fprintf('Press any button to continue\r')
% while key==0
%     key = waitforbuttonpress;
%     pause(0.2)
% end
options.prefs = cv_defaultprefs;

set(0,'CurrentFigure',fighandle)
if ~isequal([0 90],get(fighandle.CurrentAxes,'view'))
   warning('set axis to 0 90 for proper function of cv_polyselect') 
   view([0 90])
end

fprintf('Select data for further processing\r')
[pind,xs,ys,zs] = selectdata3('selectionmode','lasso','Flip',1);
setappdata(fighandle,'pointslist',pind)
setappdata(fighandle,'xselected',xs)
setappdata(fighandle,'yselected',ys)
setappdata(fighandle,'zselected',zs)

disp(table(pind,xs,ys,zs,'VariableNames',{'pointslist','xselect','yselect','zselect'}))
% disp({'pointslist','xselect','yselect','zselect'})
% disp([pind,xs,ys,zs])

%% Check selected data and plot
x = getappdata(fighandle,'xdata');
y = getappdata(fighandle,'ydata');
z = getappdata(fighandle,'zdata');
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
c = getappdata(fighandle,'LineColors');
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
setappdata(fighandle,'selFig',selFig)

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


