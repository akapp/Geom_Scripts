function [data,varNames] = cv_readindat(varargin)

% [data,varNames] = cv_readindat(options)
% [data,varNames] = cv_readindat('ptdir')
% reads in centerline data from patient folder
% 

% Parse inputs
if isempty(varargin)
    ptdir = cd;
elseif isstruct(varargin{1})
    options = varargin{1};
    ptdir = options.ptdir;
else
    ptdir=varargin{1};
end

% Get vmtk Directory: [ptdir,'/vmtk'];
[~,f] = fileparts(ptdir);
if ~strcmp(f,'vmtk')
    directory = fullfile(ptdir,'vmtk');
else
    directory = ptdir;
end

% Check directory
dfs = {'centerlines_sm.dat';
    'centerlinegeometry.dat';
    'centerlineattributes.dat';
    'centerlinesections.dat';
    'centerlinesections.csv';
    'centerlinesections.txt';};
datfiles = strcat(fullfile(directory,dfs));
allfiles = cv_parsedirectory(directory,'.');
chkfiles = contains(datfiles,allfiles);
if any(~chkfiles)
    filespec = repmat('%s, ',[1,sum(~chkfiles)]);
    [msg] = sprintf(['Missing Files: ',filespec],dfs{~chkfiles});
    error(msg(1:end-2))
end
clear dfs datfiles allfiles chkfiles fnames
% if ~exist(,'file')
% 
% end

%% Centerlines Smooth: 'centerlines_sm.dat'
filename = fullfile(directory,'centerlines_sm.dat');
delimiter = ' ';
endRow = 1;
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
varNames.clines = [dataArray{1:end-1}];

startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
data.clines = [dataArray{1:end-1}];

fclose(fileID);
clear dataArray filename delimiter  endRow formatSpec fileID startRow ans

%% Geometry: 'centerlinegeometry.dat'
filename = fullfile(directory,'centerlinegeometry.dat');
delimiter = ' ';
endRow = 1;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
varNames.geom = [dataArray{1:end-1}];

startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
data.geom = [dataArray{1:end-1}];

fclose(fileID);
clear dataArray filename delimiter  endRow formatSpec fileID startRow ans

%% Centerline Attributes
filename = fullfile(directory,'centerlineattributes.dat');
delimiter = ' ';
endRow = 1;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
varNames.attrib = [dataArray{1:end-1}];

startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
data.attrib = [dataArray{1:end-1}];

fclose(fileID);
clear dataArray filename delimiter  endRow formatSpec fileID startRow ans

%% Centerlines Sections
% "centerlinesections.dat" is a vmtk output file
filename = fullfile(directory,'centerlinesections.dat');
delimiter = ' ';
endRow = 1;
formatSpec = '%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
varNames.sections = [dataArray{1:end-1}];

startRow = 2;
formatSpec = '%f%f%f%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
data.sections = [dataArray{1:end-1}];

fclose(fileID);
clear dataArray filename delimiter  endRow formatSpec fileID startRow ans

%
% "centerlinesections.csv" is a "Cell File" from paraview
% Load "centerlinesections.vtp" and "Save Data" -> "Field Association" -> "Cells"
if exist(fullfile(directory,'centerlinesections.csv'),'file')
    filename = fullfile(directory,'centerlinesections.csv');
    delimiter = ',';
    endRow = 1;
    formatSpec = '%s%s%s%s%s%s%[^\n\r]';
    fileID = fopen(filename,'r');

    dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
    varNames.sectionsdata = [dataArray{1:end-1}];

    startRow = 2;
    formatSpec = '%f%f%f%f%f%f%[^\n\r]';
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    data.sectionsdata = [dataArray{1:end-1}];
else
    warning('Missing centerlinesections.csv from patient directory')
end

%
% "centerlinesections.txt" is a "Cell File" from paraview
% Load "centerlinesections.vtp" and "Save Data" -> "Field Association" -> "Cells"
    filename = fullfile(directory,'centerlinesections.txt');
    delimiter = ' ';
    startRow = 12+size(data.sections,1);
    % formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
    % formatSpec = '%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
    M = 275;
    formatSpec = [repmat('%f',[1,M]),'%[^\n\r]'];
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    data.polygonsize = dataArray{1};
    
    data.polygonidx = cell(size(data.polygonsize));
    if max(data.polygonsize) > M-2; error('Index exceeds matrix dimensions'); end
    idx = cell2mat(dataArray(2:max(data.polygonsize)+2))+1;
    for i=1:size(idx,1)
        data.polygonidx{i} = idx(i,~isnan(idx(i,:)));
    end
        
    fclose(fileID);

clear M dataArray filename delimiter  endRow formatSpec fileID startRow ans i idx