function varargout = cv_centerlines(varargin)
% CV_CENTERLINES MATLAB code for cv_centerlines.fig
%      CV_CENTERLINES, by itself, creates a new CV_CENTERLINES or raises the existing
%      singleton*.
%
%      H = CV_CENTERLINES returns the handle to a new CV_CENTERLINES or the handle to
%      the existing singleton*.
%
%      CV_CENTERLINES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CV_CENTERLINES.M with the given input arguments.
%
%      CV_CENTERLINES('Property','Value',...) creates a new CV_CENTERLINES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cv_centerlines_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cv_centerlines_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cv_centerlines

% Last Modified by GUIDE v2.5 16-Apr-2018 15:02:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cv_centerlines_OpeningFcn, ...
                   'gui_OutputFcn',  @cv_centerlines_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cv_centerlines is made visible.
function cv_centerlines_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cv_centerlines (see VARARGIN)

% Choose default command line output for cv_centerlines
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Turn on toolbars
set(handles.guifig,'toolbar','figure')
cameratoolbar('show')

% Position guifigure
set(handles.guifig,'Position',[10.8571   21.3333  149.2857   43.0667])

% Set Axis defaults
set(handles.cplot,'xtick',[],'ytick',[],'ztick',[])
grid(handles.cplot,'off')

% Set ListBox defaults
set(handles.fileslist,'Min',0,'Max',2)

% UIWAIT makes cv_centerlines wait for user response (see UIRESUME)
% uiwait(handles.guifig);

% --- Drag and drop callback to load patdir.
function DropFcn(~, event, handles)

switch event.DropType
    case 'file'
        patdir = event.Data;
    case 'string'
        patdir = {event.Data};
end

nonexist = cellfun(@(x) ~exist(x, 'dir'), patdir);
if any(nonexist)
    fprintf('\nExcluded non-existent/invalid folder:\n');
    cellfun(@disp, patdir(nonexist));
    fprintf('\n');
    patdir(nonexist) = [];
end


% --- Outputs from this function are returned to the command line.
function varargout = cv_centerlines_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choosepatdir.
function choosepatdir_Callback(hObject, eventdata, handles)
% hObject    handle to choosepatdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Refresh guifig handles
refreshsegmenthandles(handles)
try refreshfileslist(handles); end
try; rmappdata(handles.guifig,'stlHandle'); end

% Set appdata
setappdata(handles.guifig,'handles',handles)

% Get options
options.prefs=cv_defaultprefs;
options.uipatdirs = cv_getpatients(options,handles);
options = cv_handles2options(options,handles);

% Clear Axis
pause(0.01)
cla(handles.cplot)
cv_busyaction(handles,'on','Loading...')
pause(0.01)

% Update handles
set(handles.choosepatdir,'String',options.ptname)
set(handles.patdropdown,'String',options.uiptnames)
setappdata(handles.guifig,'options',options);
handles.options = options;


% Load data and plot centerlines from dropdown menu
patdropdown_Callback(hObject, eventdata, handles)
cv_busyaction(handles,'off','')


% --- Executes on selection change in patdropdown.
function patdropdown_Callback(hObject, eventdata, handles)
% hObject    handle to patdropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patdropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patdropdown
cla(handles.cplot)
set(handles.fileslist,'String',[])
set(handles.fileslist,'Value',1)
set(handles.stltoggle,'Value',0)
set(handles.sectionstoggle,'Value',0)
try; rmappdata(handles.guifig,'stlHandle'); end
cv_busyaction(handles,'on','Loading...')
pause(0.01);

try 
    options = getappdata(handles.guifig,'options');
catch
    return
end
try
    options.ptdir = options.uipatdirs{handles.patdropdown.Value};
catch
    options.ptdir = options.uipatdirs{1};
end
        
[data,varnames] = cv_readindat(options.ptdir);
cv_plotcenterlines(options,data,handles.guifig);
view([0 0])

setappdata(handles.guifig,'varnames',varnames)
setappdata(handles.guifig,'data',data)
setappdata(handles.guifig,'options',options)
try delete(getappdata(handles.guifig,'hilightHandles')); end
try rmappdata(handles.guifig,'hilightHandles'); end
fileslist_Callback(hObject, eventdata, handles)

cv_busyaction(handles,'off','')


% --- Executes during object creation, after setting all properties.
function patdropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patdropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in fileslist.
function fileslist_Callback(hObject, eventdata, handles)
% hObject    handle to fileslist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fileslist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileslist
try 
    handles.options = getappdata(handles.guifig,'options');
catch
    return
end

files = cv_parsedirectory(handles.options,'.mat');
files = vertcat({'Select None'},files);
set(handles.fileslist,'String',files)

% OpeningFcn
hilightHandles = getappdata(handles.guifig,'hilightHandles');
if isempty(hilightHandles)
    hilightHandles = cell(size(files,1)-1,1);
    setappdata(handles.guifig,'hilightHandles',hilightHandles)
end

% Check Size
if ~isequal(size(hilightHandles,1),size(files,1)-1)
    try delete(hilightHandles{:}); end
    hilightHandles = cell(size(files,1)-1,1);
    setappdata(handles.guifig,'hilightHandles',hilightHandles)
end

% Delete previous handles
for i = setdiff(1:length(hilightHandles),handles.fileslist.Value-1)
    try 
        delete(hilightHandles{i});
        hilightHandles{i}=[];
    end
    %try 
        % % OPTION FOR MULTISECTION PLOT
        %delete(sectionHandles{i});
        %sectionHandles{i}=[];
    %end
end

% Highlight Selected Segments
if length(files)>1
if ~any(handles.fileslist.Value==1)
    % hilight selected segments
    for i = handles.fileslist.Value-1
        filename = [handles.options.ptdir,filesep,files{i+1}];
        segment = cv_loadsegment(filename);
        segment.filename = filename;
        if isempty(hilightHandles{i})
            hilightHandles{i} = cv_hilightsegment(handles.guifig,segment,0);
        end
    end 
    handles.options.filename = files(handles.fileslist.Value);
    setappdata(handles.guifig,'options',handles.options)
end
end

% Handle Single Segment Data
if length(handles.fileslist.Value)==1 && ...
        handles.fileslist.Value~=1
    setappdata(handles.guifig,'segment',segment)
    setappdata(handles.guifig,'hilightSegment',hilightHandles{handles.fileslist.Value-1})
elseif any(handles.fileslist.Value==1)
    % Don't delete "hilightSegment": Allows ability to select other
    % segments while "Single select is on"
    refreshsegmenthandles(handles)
    refreshsectionshandles(handles)
end

% Refresh sections handles when switching between segment files
lastfile = getappdata(handles.guifig,'lastfile');
if ~isequal(files(handles.fileslist.Value),lastfile) && ...
        handles.sectionstoggle.Value
    refreshsectionshandles(handles)
    set(handles.sectionstoggle,'Value',1)
    sectionstoggle_Callback(hObject, eventdata, handles)
elseif isequal(files(handles.fileslist.Value),lastfile) && ...
        length(handles.fileslist.Value)==1 && ...
        ~any(ismember(handles.fileslist.Value,1))
    refreshsectionshandles(handles)
    set(handles.sectionstoggle,'Value',1)
    sectionstoggle_Callback(hObject, eventdata, handles)
else
    refreshsectionshandles(handles)
end

setappdata(handles.guifig,'hilightHandles',hilightHandles)
lastfile = files(handles.fileslist.Value);
setappdata(handles.guifig,'lastfile',lastfile)

% --- Executes during object creation, after setting all properties.
function fileslist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileslist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in polyselect.
function polyselect_Callback(hObject, eventdata, handles)
% hObject    handle to polyselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refreshsegmenthandles(handles)
refreshfileslist(handles)
cv_polyselect(handles.guifig)

% --- Executes on button press in tipselect.
function tipselect_Callback(hObject, eventdata, handles)
% hObject    handle to tipselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refreshsegmenthandles(handles)
refreshfileslist(handles)
cv_datatip(handles)

% --- Executes on button press in savesegbutton.
function savesegbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savesegbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cv_savesegment(handles.guifig)

% --- Executes on button press in cleansegbutton.
function cleansegbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cleansegbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cv_cleansegment(handles)

if strcmp(handles.fileslist.Enable,'off')
    refreshsegmenthandles(handles)
    refreshsectionshandles(handles)
    refreshfileslist(handles)
    set(handles.fileslist,'Enable','on')
elseif strcmp(handles.fileslist.Enable,'on') && handles.sectionstoggle.Value
    refreshsectionshandles(handles)
    refreshfileslist(handles)
    %set(handles.sectionstoggle,'Value',0)
    %sectionstoggle_Callback(hObject,eventdata,handles)
end

% --- Executes on button press in writeseg2textsingle.
function writeseg2textsingle_Callback(hObject, eventdata, handles)
% hObject    handle to writeseg2textsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options = getappdata(handles.guifig,'options');
cv_writesegment2text(options,1,0); % asktoname = on, % multiple


% --- Executes on button press in writeseg2textmultiple.
function writeseg2textmultiple_Callback(hObject, eventdata, handles)
% hObject    handle to writeseg2textmultiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options = getappdata(handles.guifig,'options');
cv_writesegment2text(options,1,1); % asktoname = on, % multiple


% --- Executes on button press in openptdir.
function openptdir_Callback(hObject, eventdata, handles)
% hObject    handle to openptdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if contains(get(handles.patdropdown,'String'),'Choose')
    fprintf('No patient directory selected\r')
    return
end

options = getappdata(handles.guifig,'options');    
cd(options.ptdir)
system(['open ',options.ptdir])


% --- Executes on button press in editsegbutton.
function editsegbutton_Callback(hObject, eventdata, handles)
% hObject    handle to editsegbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cv_editselection(handles)


% --- Executes on button press in selectsegbutton.
function selectsegbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectsegbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('button not currently active')
return 
% cv_selectline(handles)
% cv_selectsegment(handles)

% --- Executes on button press in stltoggle.
function stltoggle_Callback(hObject, eventdata, handles)
% hObject    handle to stltoggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stltoggle
% Get options
options = getappdata(handles.guifig,'options');
if isempty(options)
    fprintf('No patient selected.\r')
    set(handles.stltoggle,'Value',0)
    return
end

% Plot Stl
if handles.stltoggle.Value
    stlHandle = getappdata(handles.guifig,'stlHandle');
    if isempty(stlHandle)
        cv_busyaction(handles,'on','Loading...')
        pause(0.1)
        if ~exist([options.ptdir,'/vmtk/surface.stl'],'file')
            cv_busyaction(handles,'off')
            error(['Cannot find ' options.ptdir,'/vmtk/surface.stl'])
        end
        [vertices,faces] = stlRead([options.ptdir,'/vmtk/surface.stl']);
        stlHandle = cv_plotstl(vertices,faces,options.ptname,handles.guifig);
        setappdata(handles.guifig,'stlHandle',stlHandle)
    else
        set(stlHandle,'Visible','on')
        setappdata(handles.guifig,'stlHandle',stlHandle)
    end
% Turn Stl off
else
    stlHandle = getappdata(handles.guifig,'stlHandle');
    set(stlHandle,'Visible','off')
    setappdata(handles.guifig,'stlHandle',stlHandle)
    %     try delete(getappdata(handles.guifig,'stlHandle')); end
    %     try rmappdata(handles.guifig,'stlHandle'); end
end
cv_busyaction(handles,'off')

% --- Executes on button press in sectionstoggle.
function sectionstoggle_Callback(hObject, eventdata, handles)
% hObject    handle to sectionstoggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sectionstoggle
segment = getappdata(handles.guifig,'segment');
options = getappdata(handles.guifig,'options');
if isempty(segment)
    fprintf('No active segment.\r')
    set(handles.sectionstoggle,'Value',0)
    return
end

if handles.sectionstoggle.Value
    data = getappdata(handles.guifig,'data');
    [sectionsdata,sectionHandles] = cv_plotcontours(data,segment);
    if options.prefs.sectionstoggle.PlotPopOut
        popoutHandle = cv_plotsectionspopout(data,segment);
        setappdata(handles.guifig,'popoutHandle',popoutHandle)
    end
    setappdata(handles.guifig,'sectionsdata',sectionsdata)
    setappdata(handles.guifig,'sectionHandles',sectionHandles)
else
    sectionHandles = getappdata(handles.guifig,'sectionHandles');
    if ~isempty(sectionHandles)
        for i = 1:length(sectionHandles)
            try delete(sectionHandles{i}); end
        end
        rmappdata(handles.guifig,'sectionHandles');
        rmappdata(handles.guifig,'sectionsdata');
    popoutHandle = getappdata(handles.guifig,'popoutHandle');
    end
    if ~isempty(popoutHandle)
        try delete(popoutHandle); end
        rmappdata(handles.guifig,'popoutHandle')
    end
end


% --- Executes on button press in selectsectionbutton.
function selectsectionbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectsectionbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.sectionstoggle.Value
    fprintf('Toggle sections on before choosing sections.')
    return
end
cv_selectsection(handles)

% ================================================
%                  subfunction
% ================================================
function refreshsegmenthandles(handles)

% Segment data 
try delete(getappdata(handles.guifig,'hilightSegment')); end
try rmappdata(handles.guifig,'hilightSegment'); end
try rmappdata(handles.guifig,'segment'); end

function refreshsectionshandles(handles)
% Sections data
sectionHandles = getappdata(handles.guifig,'sectionHandles');
if ~isempty(sectionHandles)
    for i = 1:length(sectionHandles)
        try delete(sectionHandles{i}); end
    end
    try rmappdata(handles.guifig,'sectionHandles'); end
    try rmappdata(handles.guifig,'sectionsdata'); end
    set(handles.sectionstoggle,'Value',0)
end

function refreshfileslist(handles)
set(handles.fileslist,'Value',1)
fileslist_Callback([],[],handles)
