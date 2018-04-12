function files = cv_parsedirectory(varargin)

% files = cv_parsedirectory(options)
% files = cv_parsedirectory(options,ext)
%
% files = cv_choosefiles(files);
% default extension '.mat', see cv_defaultprefs


%% parse inputs

% parse varargin
if isempty(varargin)
    directory = pwd;
    ext = '.mat'; % default extension
elseif size(varargin,2)==1
    options = varargin{1};
    ext = options.prefs.parsedir.ext; % default extension
elseif size(varargin,2)==2
    options = varargin{1};
    ext = varargin{2};
end

% parse options
if exist('options','var')
    directory = options.ptdir;
end

%% Get Files

if ~iscell(directory)
    f = dir(directory);
    files = {f(contains({f.name},ext)).name}';    
else
    files = cell(size(directory));
    ptnames = cell(size(directory));
    for i=1:length(directory)
        f = dir(directory{i});
        files{i} = {f(contains({f.name},ext)).name}';
        [~,ptnames{i}] = fileparts(directory{i});
    end
end
