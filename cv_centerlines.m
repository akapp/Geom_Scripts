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

% Last Modified by GUIDE v2.5 12-Apr-2018 15:06:29

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
setappdata(handles.guifig,'handles',handles)
options.prefs=cv_defaultprefs;
options.uipatdirs = cv_getpatients(options,handles);
options = cv_handles2options(options,handles);

pause(0.01)
cla(handles.cplot)
cv_busyaction(handles,'on','Loading...')
pause(0.01)

set(handles.choosepatdir,'String',options.ptname)
set(handles.patdropdown,'String',options.uiptnames)
setappdata(handles.guifig,'options',options);
handles.options = options;

% data = cv_readindat(options.uipatdirs{handles.patdropdown.Value});
% cv_plotcenterlines(options,data,handles.cplot);
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
cv_busyaction(handles,'on','Loading...')
pause(0.01);

try 
    handles.options = getappdata(handles.guifig,'options');
catch
    return
end

data = cv_readindat(handles.options.uipatdirs{handles.patdropdown.Value});
cv_plotcenterlines(handles.options,data,handles.guifig);

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

% --- Executes on button press in polyselect.
function polyselect_Callback(hObject, eventdata, handles)
% hObject    handle to polyselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cv_polyselect(handles.guifig)

% --- Executes on button press in tipselect.
function tipselect_Callback(hObject, eventdata, handles)
% hObject    handle to tipselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cv_datatip(handles)

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
    delete(hilightHandles{:});
    hilightHandles = cell(size(files,1)-1,1);
    setappdata(handles.guifig,'hilightHandles',hilightHandles)
end

% Delete previous handles
for i = setdiff(1:length(hilightHandles),handles.fileslist.Value-1)
    try 
        delete(hilightHandles{i});
        hilightHandles{i}=[];
    end
end

% Highlight Selected Segments
if length(files)>1
if handles.fileslist.Value~=1
    % hilight selected segments
    for i = handles.fileslist.Value-1
        filename = [handles.options.ptdir,filesep,files{i+1}];
        segment = cv_loadsegment(filename);
        if isempty(hilightHandles{i})
            hilightHandles{i} = cv_hilightsegment(handles.guifig,segment,0);
        end
    end 
    handles.options.filename = files(handles.fileslist.Value);
    setappdata(handles.guifig,'options',handles.options)
end
end

if length(handles.fileslist.Value)==1 && handles.fileslist.Value~=1
    setappdata(handles.guifig,'segment',segment)
    setappdata(handles.guifig,'hilightSegment',hilightHandles{handles.fileslist.Value-1})
else
    try rmappdata(handles.guifig,'segment'); end
end

setappdata(handles.guifig,'hilightHandles',hilightHandles)

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
try delete(getappdata(handles.guifig,'hilightSegment')); end
try rmappdata(handles.guifig,'hilightSegment'); end
try rmappdata(handles.guifig,'segment'); end
set(handles.fileslist,'Enable','on')

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