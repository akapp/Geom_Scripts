function uipatdir = cv_getpatients(options,handles)

p='/'; % default use root
try
    p=pwd; % if possible use pwd instead (could not work if deployed)
end
try % finally use last patient parent dir if set.
    load([cv_getcvroot,'common',filesep,'cv_recentpatients.mat']);
    p=fileparts(fullrpts{1});
end

uipatdir=cv_uigetdir(p,'Please choose patient folder(s)...');
if isempty(uipatdir)
    return
end

% if exist('handles','var')
%     cv_load_pts(handles,uipatdir);
% end