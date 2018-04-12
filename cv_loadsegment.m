function [segment,isclean] = cv_loadsegment(filename)

% segment = cv_loadseg([options.ptdir,filesep,options.filename])
% See cv_writesegment2text

segment = load(filename);
if isfield(segment,'segment')
    load(filename,'segment')
    save(filename,'-struct','segment')
end

if ~isfield(segment,'area') || ...
        ~isfield(segment,'curvature') || ...
        ~isfield(segment,'torsion')
    
    H = findall(0,'Type','Figure');
    H = H(contains({H(:).Tag},'guifig'));
    data = getappdata(H,'data');
    segment = cv_updatesegment(data,segment);
    save(filename,'-struct','segment')
    
end

if isfield(segment,'cleanidx') && ~isempty(segment.cleanidx) 
    isclean = 1;
else
    isclean = 0;
end
