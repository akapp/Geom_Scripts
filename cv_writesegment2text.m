function cv_writesegment2text(options,ask2name,multiple)

% options.ptdir='/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061';
% options.ptname='BB061';
% options.filename='seg_lICAi.mat';
%
%    filename: {14×1 cell}
%    ptdir: '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061'
%    ptname: 'BB061'
%
% options.filename = cv_parsedirectory
% cv_writesegment2text(options)
%
% cv_writesegment2test(options,1)

%% Parse Inputs
if ~isfield(options,'filename')
    error('No filename')
end

% Filename must be a cell
if ~iscell(options.filename)
    options.filename = {options.filename};
end

% Option to input name for gui
if nargin==1
    ask2name = false; % default name = cv_results.txt
    multiple = false;
end

%%
for i = 1:length(options.filename)
    filename = options.filename{i};
    [segment,isclean] = cv_loadsegment([options.ptdir,filesep,filename]);
    resfilename = checkinputs(options,segment,ask2name,multiple);
    
    % Check if Segment was previously written to file
    if exist([options.ptdir,'/',resfilename,'.txt'],'file')
        fid=fopen([options.ptdir,'/',resfilename,'.txt']);
        dataArray=textscan(fid,'%s%s%s','Delimiter',' ');
        fclose(fid);
        prevsegments = dataArray{2}((contains(dataArray{1},'SegmentName')));
        if any(contains(prevsegments,segment.name))
            A = questdlg('Segment already written to file. Would you like to overwrite it?');
            if strcmp(A,'Yes')
                newData = cell(size(dataArray));
                startSeg = find(contains(dataArray{1},'PatientName'));
                lengSeg = [diff(startSeg);length(dataArray{1})-startSeg(end)+1];
                %rmIdx = (contains(prevsegments,segment.name));
                %rmlines = [startSeg(rmIdx),lengSeg(rmIdx)];
                kpIdx = ~(contains(prevsegments,segment.name));
                kplines = [startSeg(kpIdx),lengSeg(kpIdx)];
                if ~isempty(kplines)
                    for j = 1:size(kplines,1)
                        for k = 1:length(dataArray)
                            newData{k} = dataArray{k}(kplines(j,1):kplines(j,2));
                        end
                    end
                end
                
                % Write newData
                delete([options.ptdir,'/',resfilename,'.txt'])
                fid = fopen([options.ptdir,'/',resfilename,'.txt'],'a');
                for j = 1:length(newData{1})
                    fprintf(fid,'%s %s %s\r',newData{1}{j},newData{2}{j},newData{3}{j});
                    fprintf(fid,'\r\r\r');
                end
                fclose(fid);
            else
                continue
            end
        end
    end

    % Write Segment Data
    if isclean
        outIdx(i) = true;
        resfile=fopen([options.ptdir,'/',resfilename,'.txt'],'a');
        
        fprintf(resfile,['PatientName ',options.ptname,'\r']);
        fprintf(resfile,['SegmentName ',segment.name,'\r']);
        fprintf(resfile,'WasCleaned 1\r');
        fprintf(resfile,'area curvature torsion\r');
        fprintf(resfile,'%.3f %.3f %.3f\r',segment.area,segment.curvature,segment.torsion);
        fprintf(resfile,'\r\r\r');
        
        fclose(resfile);
    else
        outIdx(i) = false;
    end
end

fprintf('Files written out\r')
disp(options.filename(outIdx))


function resfilename = checkinputs(options,segment,ask2name,multiple)

if ask2name && multiple
    if ~exist([options.ptdir,'/results'])
        mkdir([options.ptdir,'/results'])
    end
    resfilename = ['results/',segment.name];
elseif ask2name && ~multiple
    A = inputdlg ('Enter a name for the results textfile','Results',1,{'cv_results_'});
    resfilename = A{1};
else
    resfilename = 'cv_results';
end

