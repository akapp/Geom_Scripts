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
    key=0;
    fprintf('Choose start point then Press any button to continue\r')
    while key==0
        key = waitforbuttonpress;
        pause(0.2)
    end
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
    key=0;
    fprintf('Choose start point then Press any button to continue\r')
    while key==0
        key = waitforbuttonpress;
        pause(0.2)
    end
    c2 = getCursorInfo(dcm_obj)
elseif strcmp(qA,'Cancel')
    return
else
    qstate(2)=0;
end
try delete(findall(gcf,'Type','hggroup')); end

% reference selections back to data
iA = inputdlg('Enter segment name');
segname = iA{1};

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
    segment = cv_selectsegment(data,xs,ys,zs,c1,c2,segname)
elseif isequal(qstate,[1 0])
    segment = cv_selectsegment(data,xs,ys,zs,c1,[],segname)
elseif isequal(qstate,[0 1])
    segment = cv_selectsegment(data,xs,ys,zs,[],c2,segname)
elseif isequal(qstate,[0 0])
    error('No datapoins selected')
end

setappdata(fighandle,'segment',segment)

qA = questdlg('Would you like to save the segment now?');
if strcmp(qA,'Yes')
   options = getappdata(fighandle,'options');
   iA = inputdlg('Enter filename','Input Filename',1,{'seg_'});
   [~,filename] = fileparts(iA{1});
   save(fullfile(options.ptdir,[filename,'.mat']),'-struct','segment')
end