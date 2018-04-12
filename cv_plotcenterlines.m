function [x,y,z,segs,figH,clineH] = cv_plotcenterlines(varargin)

% [x,y,z,segs,figH,clineH] = cv_plotcenterlines(options,data)
% [x,y,z,segs,figH,clineH] = cv_plotcenterlines(options,data,figH)

if isfield(varargin{1},'ptdir')
    options=varargin{1};
    data = varargin{2};
    [~,ptname] = fileparts(options.ptdir);
    figTitle = [options.prefs.cplot.Name,': ',ptname];
else
    options.prefs = cv_defaultprefs;
    data = varargin{1};
    figTitle = options.prefs.cplot.Name;
end
if length(varargin)<=2
    openNewFigure = 1;
    figH = figure; 
    set(figH,'Name',figTitle, ...
        'Tag',options.prefs.cplot.Tag, ...
        'Position',options.prefs.cplot.Position, ...
        'NumberTitle','off', ...
        'CloseRequestFcn', @closesattelites);
    cameratoolbar('Show')
else
    % figH is cplot axis
    openNewFigure = 0;
    figH = varargin{3};
    cla(figH)
end

%%
hold all
segs = cv_getsegs(data);
% nsegs = length(segs)-1;
clineH=cell([size(segs,1)-1,1]);
x=cell([size(segs,1)-1,1]);
y=cell([size(segs,1)-1,1]);
z=cell([size(segs,1)-1,1]);
for i = 1:length(segs)-1
    clineH{i} = plot3(data.clines(segs(i)+1:segs(i+1),1),...
        data.clines(segs(i)+1:segs(i+1),2),...
        data.clines(segs(i)+1:segs(i+1),3),'*');
    x{i} = data.clines(segs(i)+1:segs(i+1),1);
    y{i} = data.clines(segs(i)+1:segs(i+1),2);
    z{i} = data.clines(segs(i)+1:segs(i+1),3);
    %pause
end
clineH=[clineH{:}]';
axis equal
c=reshape([clineH.Color]',[3,size(clineH,1)])'; %line colors
setappdata(figH,'options',options)
setappdata(figH,'data',data)
setappdata(figH,'LineColors',c)
setappdata(figH,'segs',segs)
setappdata(figH,'xdata',x)
setappdata(figH,'ydata',y)
setappdata(figH,'zdata',z)

%%
if openNewFigure
buttonwin = cv_buttonpanel(figH);
set(buttonwin, ...
    'Name',options.prefs.cplot.bwinName, ...
    'Position',options.prefs.cplot.bwinPosition)
setappdata(figH,'buttonwin',buttonwin)

else
    
end

function closesattelites(src,evnt)
buttonwin = getappdata(src,'buttonwin');
try
    close(buttonwin)
end

if isfield(getappdata(src),'selFig')
    selFig = getappdata(src,'selFig');
    try
        close(selFig)
    end
end

    delete(src)


        