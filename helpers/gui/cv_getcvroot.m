function root=cv_getcvroot

% small function determining the location of the lead-dbs root directory.
if isdeployed
    root=[ctfroot,filesep];
else
    root=[fileparts(which('cv_centerlines.m')),filesep];
end