function segment = cv_selectline(handles)

% guifig = findall(0,'Tag','guifig')
guifig = handles.guifig;
options = getappdata(guifig,'options');
data = getappdata(guifig,'data');

x = getappdata(guifig,'xdata');
z = getappdata(guifig,'ydata');
y = getappdata(guifig,'zdata');

pause(0.2)
dcm_obj = datacursormode(fighandle);
set(dcm_obj,'DisplayStyle','datatip','Enable','on')

% Data Tip
pause(0.4)
set(0,'CurrentFigure',guifig)
try cv_waitforspacebar(handles); end
c1 = getCursorInfo(dcm_obj)

[~,spln,~,splr] = cv_processcursor(c1,x,y,z);
fprintf('Line selected: %f',spln)

chkFig = cv_plotline(x,y,z,spln,splr);

try cv_waitforspacebar(handles); end

close(chkFig)

end
elseif strcmp(qA,'Cancel')
    return
    else
    qstate(1)=0;
end
try delete(findall(gcf,'Type','hggroup')); end


% Plot line (see cv_plotline)
chkFig = cv_popoutwin('Selected Segment'); hold on
plot3(x{segment.line},y{segment.line},z{segment.line},'b-');