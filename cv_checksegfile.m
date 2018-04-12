function ok = cv_checksegfile(filename)

cv_warning('''cv_checksegfile'' is deprecated. Will be removed. Use cv_loadsegment')

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

ok = 1;