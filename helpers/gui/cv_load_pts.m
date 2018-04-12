function cv_load_pts(handles,uipatdir,patsub)

if ~exist('patsub','var')
    patsub='patients';
end

if ~iscell(uipatdir)
    uipatdirc{1}=uipatdir;
    uipatdir=uipatdirc;
end

if length(uipatdir)>1
    set(handles.patdir_choosebox,'String',['Multiple (',num2str(length(uipatdir)),')']);
    set(handles.patdir_choosebox,'TooltipString',cv_strjoin(uipatdir,', '));
else
    set(handles.patdir_choosebox,'String',uipatdir{1});
    set(handles.patdir_choosebox,'TooltipString',uipatdir{1});
end

% store patient directories in figure
setappdata(handles.leadfigure,'uipatdir',uipatdir);

if length(uipatdir) > 1 % if multiple patients are chosen, enable CT coregistration setting by default
    try
        % set(handles.MRCT,'Enable', 'off');
        set(handles.MRCT, 'TooltipString', '<html>Multiple patients are selected.<br>Enable CT to MRI coregistration setting by default.<br>The actual modality will be automatically detected.');
    end
else
    try
        % set(handles.MRCT,'Enable', 'on');
        set(handles.MRCT, 'TooltipString', '<html>Post-operative image modality (MR/CT) will be automatically detected.<br>In case both MR and CT images are present, MR will be chosen by default.<br>You can change this in your preference file by setting ''prefs.preferMRCT'' (1 for MR and 2 for CT).');
    end
end

% ea_getui(handles); % update ui from patient
% ea_storeui(handles); % save in pt folder
% ea_addrecentpatient(handles,uipatdir,[patsub],patsub);


% check if reconstruction is present and assign side-toggles accordingly:
try
if exist([uipatdir{1},filesep,'ea_reconstruction.mat'],'file')
   load([uipatdir{1},filesep,'ea_reconstruction.mat']);
   for el=1:10
      try set(handles.(['side',num2str(el)]),'Value',0); end
   end
   for el=1:length(reco.native.coords_mm)
      if ~isempty(reco.native.coords_mm(el))
         try set(handles.(['side',num2str(el)]),'Value',1); end
      end
   end
   try 
       [~,locb] = ismember({reco.props(1).elmodel},handles.electrode_model_popup.String);
       set(handles.electrode_model_popup,'Value',locb);
       clear locb
   end
end
end
% add VATs to seeds for connectome mapper or predict case
if isfield(handles,'seeddefpopup')
    for pt=1:length(uipatdir)
    direc=[uipatdir{pt},filesep];
    stims=ea_dir2cell(dir([direc,'stimulations']));
    if ~exist('remstims','var')
        remstims=stims;
    else
        todel=[];
        for d=1:length(remstims)
            if ~ismember(remstims{d},stims)
               todel(end+1)=d;
            end
        end
        remstims(todel)=[];
    end
    end
    % for now only check first subject for pt. specific fibers..
    % find out whether mapper or predict were calling
    switch handles.leadfigure.Name(1:20)
        case 'Lead Connectome Mapp'
            remstims=ea_prependvat(remstims);
            set(handles.seeddefpopup,'String',[{'Manually choose seeds'},remstims]);
        otherwise
            set(handles.seeddefpopup,'String',[remstims]);
    end
    ea_resetpopup(handles.seeddefpopup);

    % update cons
    if ~strcmp(get(handles.patdir_choosebox,'String'),'Choose Patient Directory')
        directory=uipatdir{1};
        [~,ptname]=fileparts(directory);
        selectedparc='nan';
        options=ea_handles2options(handles);
        options.prefs=ea_prefs;
        [mdl,sf]=ea_genmodlist([directory,filesep],selectedparc,options);
        ea_updatemodpopups(mdl,sf,handles);
    end
end


function remstims=ea_prependvat(remstims)
for rs=1:length(remstims)
    remstims{rs}=['Use VATs: ',remstims{rs}];
end
