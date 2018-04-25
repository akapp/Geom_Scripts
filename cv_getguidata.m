% run cv_getguidata to send data to workspace

guifig = findall(0,'Tag','guifig');
vars = getappdata(guifig,'varnames');
data = getappdata(guifig,'data');
segment = getappdata(guifig,'segment');