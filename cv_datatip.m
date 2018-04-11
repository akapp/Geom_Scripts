function segment = cv_datatip(src,event,fighandle)
% plot selection
if strcmp(fighandle.Name,'CenterlinesPlot')% isfield(getappdata(fighandle),'pind')
    x = getappdata(fighandle,'xdata');
    y = getappdata(fighandle,'ydata');
    z = getappdata(fighandle,'zdata');
elseif strcmp(fighandle.Name,'SelectedPoints')% isfield(getappdata(fighandle),'pind')
    x = getappdata(fighandle,'xselected');
    y = getappdata(fighandle,'yselected');
    z = getappdata(fighandle,'zselected');    
end

dcm_obj = datacursormode(fighandle);
set(dcm_obj,'DisplayStyle','datatip','Enable','on')

% Start point
pause(0.4)
qA = questdlg('Would you like to identify a start point');
if strcmp(qA,'Yes')
    set(0,'CurrentFigure',fighandle)
    qstate(1)=1;
    cv_waitforspacebar
    c1 = getCursorInfo(dcm_obj)
elseif strcmp(qA,'Cancel')
    return
else
    qstate(1)=0;
end
try delete(findall(gcf,'Type','hggroup')); end

% End point
pause(0.4)
qA = questdlg('Would you like to identify an End point');
if strcmp(qA,'Yes')
    qstate(2)=1;
    cv_waitforspacebar
    c2 = getCursorInfo(dcm_obj)
elseif strcmp(qA,'Cancel')
    return
else
    qstate(2)=0;
end
try delete(findall(gcf,'Type','hggroup')); end

% reference selections back to data
data = getappdata(fighandle,'data');
x = getappdata(fighandle,'xdata');
y = getappdata(fighandle,'ydata');
z = getappdata(fighandle,'zdata');

if isfield(getappdata(fighandle),'xselected')
    xs = getappdata(fighandle,'xselected');
    ys = getappdata(fighandle,'yselected');
    zs = getappdata(fighandle,'zselected');
else
    xs = x;
    ys = y;
    zs = z;    
end

if isequal(qstate,[1 1])
    segment = cv_selectsegment(data,xs,ys,zs,c1,c2,'')
elseif isequal(qstate,[1 0])
    segment = cv_selectsegment(data,xs,ys,zs,c1,[],'')
elseif isequal(qstate,[0 1])
    segment = cv_selectsegment(data,xs,ys,zs,[],c2,'')
elseif isequal(qstate,[0 0])
    error('No datapoins selected')
end

% Highlight Segment
l = segment.line;
a = segment.refidx(1);
b = segment.refidx(2);
pause(0.2);
hilightH = plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'r-','linewidth',10);
hilightH.Color(4)=0.4;
cv_waitforspacebar
delete(hilightH)

% Name Segment
iA = inputdlg('Enter segment name');
if ~isempty(iA)
    segname = iA{1};
else
    return
end
segment.name = segname;

setappdata(fighandle,'segment',segment)

qA = questdlg('Would you like to save the segment now?');
if strcmp(qA,'Yes')
   options = getappdata(fighandle,'options');
   iA = inputdlg('Enter filename','Input Filename',1,{'seg_'});
   [~,filename] = fileparts(iA{1});
   save(fullfile(options.ptdir,[filename,'.mat']),'-struct','segment')
elseif strcmp(qA,'Cancel')
    return
end