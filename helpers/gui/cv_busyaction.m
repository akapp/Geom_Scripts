function cv_busyaction(varargin)

% cv_busyaction(handles,'on')
pause(0.1)
handles = varargin{1};
onoff=varargin{2};
try str = varargin{3}; end

switch onoff
    case 'on'
        if ~exist('str','var')
            str = 'busy...';
        end
        set(handles.textbar,'Visible','on','String',str)
    case 'off'
        str = '';
        set(handles.textbar,'Visible','off','String',str)
end
