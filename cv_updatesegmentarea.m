function segment = cv_updatesegmentarea(data,segment)

segs = cv_getsegs(data);
x=cell([size(segs,1)-1,1]);
y=cell([size(segs,1)-1,1]);
z=cell([size(segs,1)-1,1]);
area=cell([size(segs,1)-1,1]);
for i = 1:length(segs)-1
    x{i} = data.clines(segs(i)+1:segs(i+1),1);
    y{i} = data.clines(segs(i)+1:segs(i+1),2);
    z{i} = data.clines(segs(i)+1:segs(i+1),3);
    
    if isfield(data,'sectionsdata')
        area{i} = data.sectionsdata(segs(i)+1:segs(i+1),1);
    else
        error('Missing field ''sectionsdata''')
    end
    
end

line = segment.line;
if isfield(segment,'cleanidx')
    idx = segment.cleanidx;
else
    idx = segment.refidx;
end

if isempty(cell2mat(area))
    error('missing Area data.')
end
segment.area = area{line}(idx);
