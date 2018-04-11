function segment = cv_updatesegmentcurvature(data,segment)

% Curvature = data.geom(:,10);

segs = cv_getsegs(data);
x=cell([size(segs,1)-1,1]);
y=cell([size(segs,1)-1,1]);
z=cell([size(segs,1)-1,1]);
area=cell([size(segs,1)-1,1]);
curvature=cell([size(segs,1)-1,1]);
torsion=cell([size(segs,1)-1,1]);
for i = 1:length(segs)-1
    x{i} = data.clines(segs(i)+1:segs(i+1),1);
    y{i} = data.clines(segs(i)+1:segs(i+1),2);
    z{i} = data.clines(segs(i)+1:segs(i+1),3);
    
    if isfield(data,'sectionsdata')
        area{i} = data.sectionsdata(segs(i)+1:segs(i+1),1);
    else
        error('Missing field ''sectionsdata''')
    end
    
    curvature{i} = data.geom(segs(i)+1:segs(i+1),10);
    torsion{i} = data.geom(segs(i)+1:segs(i+1),11);
    
end

line = segment.line;
if isfield(segment,'cleanidx')
    idx = segment.cleanidx;
else
    idx = segment.refidx(1):segment.refidx(2);
end

segment.curvature = curvature{line}(idx);
