function prefs = cv_defaultprefs()

prefs.verbose = 1; % default 1

%% Window Preferences
prefs.cplot.Name = 'Centerlines';
prefs.cplot.Tag = 'centerlinesplot';
prefs.cplot.Position = [135   228   773   628];
prefs.cplot.bwinName = 'buttonwin_cplot';
prefs.cplot.bwinPosition = [909   732   200   200];

prefs.selfig.Name = 'Selected Points';
prefs.selfig.Tag = 'polyselection';
prefs.selfig.Position = [272   407   560   420];
prefs.selfig.bwinName = 'buttonwin_selfig';
prefs.selfig.bwinPosition = [833   778   200   100];

prefs.hilight.Color = 'r';
prefs.hilight.LineWidth = 12;

%% Segment Options
prefs.segment.showcheckseglinewin = 1; % default 0
prefs.segment.asktosave = 0; % default 1
prefs.segment.asktoname = 0; % default 1

%% parsedir
prefs.parsedir.ext = '.mat';

