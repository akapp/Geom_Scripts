function segment = cv_datatip(varargin)


%% Parse Inputs
if size(varargin,2)==1
    handles = varargin{1};
    fighandle = handles.guifig;
    options = getappdata(fighandle,'options')
    x = getappdata(fighandle,'xdata');
    y = getappdata(fighandle,'ydata');
    z = getappdata(fighandle,'zdata');
    ingui = 1;
elseif size(varargin,2)==3
    fighandle = varargin{3};
    options.prefs = cv_defaultprefs;
end

% % % plot selection onto fighandle
% if strcmp(fighandle.Name,'CenterlinesPlot')% isfield(getappdata(fighandle),'pind')
%     x = getappdata(fighandle,'xdata');
%     y = getappdata(fighandle,'ydata');
%     z = getappdata(fighandle,'zdata');
% elseif strcmp(fighandle.Name,'SelectedPoints')% isfield(getappdata(fighandle),'pind')
%     x = getappdata(fighandle,'xselected');
%     y = getappdata(fighandle,'yselected');
%     z = getappdata(fighandle,'zselected');    
% end
%%
dcm_obj = datacursormode(fighandle);
set(dcm_obj,'DisplayStyle','datatip','Enable','on')

% Start point
pause(0.4)
qA = questdlg('Would you like to identify a start point');
if strcmp(qA,'Yes')
    set(0,'CurrentFigure',fighandle)
    qstate(1)=1;   
    try cv_waitforspacebar(handles); end
    c1 = getCursorInfo(dcm_obj);
    % if options.prefs.segment.showcheckseglinewin
    [~,spln,~,splr] = cv_processcursor(c1,x,y,z);
    fprintf('Line Selected: %0.f\rReference Point: %0.f\r',spln,splr);
    %     chkFig = cv_plotline(x,y,z,spln,splr);
    %     try cv_waitforspacebar(handles); end
    %     close(chkFig)
    % end
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
    try cv_waitforspacebar(handles);
    catch waitforspacebar(); end
    c2 = getCursorInfo(dcm_obj);
    [~,epln,~,eplr] = cv_processcursor(c1,x,y,z);
    fprintf('Line Selected: %0.f\rReference Point: %0.f\r',epln,eplr);
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
setappdata(fighandle,'segment',segment)

% Highlight Segment and show 
hilightS = cv_hilightsegment(fighandle,segment,0);
setappdata(fighandle,'hilightSegment',hilightS)
if ~ingui 
    try cv_waitforspacebar(handles);
    catch waitforspacebar(); end
end


% Name Segment
iA = inputdlg('Enter segment name');
if ~isempty(iA)
    segname = iA{1};
else
    setappdata(fighandle,'segment',segment)
    setappdata(fighandle,'hilightSegment',hilightS);
    return
end
segment.name = segname;
setappdata(fighandle,'segment',segment)

try
    options = rmfield(getappdata(fighandle,'options'),'filename');
    setappdata(fighandle,'options',options);
end

set(handles.fileslist,'Enable','off')

% delete(hilightS)
