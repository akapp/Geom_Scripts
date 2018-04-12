function files = cv_choosefiles(matfiles)

%% Choose Files

str = 'Choose files';
[selection,ok] = listdlg(...
    'PromptString',str,...
    'SelectionMode','multiple',...
    'ListString',matfiles,...
    'ListSize',[300,300]);

if ok
    files = matfiles(selection);
else
    files = [];
end