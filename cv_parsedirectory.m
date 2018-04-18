function files = cv_parsedirectory(varargin)

% files = cv_parsedirectory(options)
% files = cv_parsedirectory(options,ext)
% cv_parsedirectory(pwd,'.dat')
% cv_parsedirectory(pwd,'.')
%
%
% files = cv_choosefiles(files);
% default extension '.mat', see cv_defaultprefs


%% parse inputs

% get directory from varargin
if isempty(varargin)
    directory = pwd;
elseif size(varargin,2)>=1
    if isstruct(varargin{1})
        options = varargin{1};
        directory = options.ptdir;
    elseif ischar(varargin{1})
        directory = varargin{1};
    elseif iscell(varargin{1})
        keyboard
    end
end

% get ext from varargin
if isempty(varargin)
    ext = '.mat'; % default extension
elseif size(varargin,2)==1
    if exist('options','var')
        ext = options.prefs.parsedir.ext; % default extension
    else
        ext = '.mat'; % default extension
    end
elseif size(varargin,2)==2
    ext = varargin{2};
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
