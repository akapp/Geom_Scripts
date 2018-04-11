function key = cv_keypress(src,event)

% This is the main keypress function for the CenterlinesPlot. 
% Add event listeners here.

% if ismember('alt', event.Modifier)
%     setappdata(src, 'altpressed', 1);
%     %    disp('Altpressed');
% elseif ismember('shift', event.Modifier)
%     setappdata(src, 'shiftpressed', 1);
% end

if strcmp(event.Key,'space')
    
end

% If the MER Control window is open
mercontrolfig = getappdata(src, 'mercontrolfig');
if ~isempty(mercontrolfig) && isvalid(mercontrolfig)

    merstruct = getappdata(mercontrolfig, 'merstruct');

    bChecked = logical([merstruct.Toggles.keycontrol.value]);
    if ~any(bChecked)
        return
    end

    if any(strcmpi(event.Key, {'space','m','l','t','b', 's', 'n'}))
        % Reserved keys:
        % 'space' = Generic; 'm' = MER; 'l' = LFP; 't' = Top; 'b' = Bottom
        % 's' = session; 'n' = notes

        if any(strcmpi(event.Key, {'s', 'n'}))
            % Enter session or notes for the last marker.
            if strcmpi(event.Key, 's')
                merstruct.markers(end).session = char(inputdlg('Enter Session'));
            elseif strcmpi(event.Key, 'n')
                merstruct.markers(end).notes = char(inputdlg('Enter Notes'));
            end
            setappdata(src, 'mermarkers', merstruct.markers);
            return;
        end

        sess_text = '';
        switch lower(event.Key)
            case 'space'
                markertype = MERState.MarkerTypes.Generic;
            case 'm'
                markertype = MERState.MarkerTypes.MER;
                sess_text = char(inputdlg ('Enter Session'));
            case 'l'
                markertype = MERState.MarkerTypes.LFP;
                sess_text = char(inputdlg ('Enter Session'));
            case 't'
                markertype = MERState.MarkerTypes.Top;
            case 'b'
                markertype = MERState.MarkerTypes.Bottom;
        end

        % For each checked box, add a marker.
        merstruct.addMarkersAtTrajs(merstruct.Toggles.keycontrol(bChecked),...
            markertype, sess_text);
        handles = guidata(mercontrolfig);
        ea_resultfig_updatemarkers(handles);
        ea_mercontrol_updatemarkers(handles);

    elseif any(strcmpi(event.Key, {'uparrow','leftarrow','downarrow','rightarrow'}))
        d = 1;  % Default step size
        if ~isempty(event.Modifier)
            if ismember(event.Modifier, 'shift')
                d = 2;  % Large step size
            elseif ismember(event.Modifier, 'alt')
                d = 3;  % Small step size
            end
        end
        if any(strcmpi(event.Key, {'downarrow','rightarrow'}))
            d = -d;
        end
        merstruct.translateToggledTrajectories(d);

        % Update the GUI
        handles = guidata(mercontrolfig);
        ea_resultfig_updatetrajectories(handles);
        ea_mercontrol_updateimplanted(handles);

    end
% commnd=event.Character;
% switch lower(commnd)
%     case ' '
%     case {'x','a','p','y','l','r'} % view angles.
%     case {'0','3','4','7'}
%     case {'c','v','b','n'}
%     otherwise % arrow keys, plus, minus
% end
end
