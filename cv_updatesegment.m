function [segment,isclean,area,datainfo] = cv_updatesegment(data,segment)

% [segment,isclean] = cv_updatesegment(data,segment)
% Updates area curvature and torsion
% Uses cleanidx when available

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

% If cleaned use as index
l = segment.line;
idx = segment.refidx(1):segment.refidx(2);
if isfield(segment,'cleanidx')
    isclean = 1;
    idx = segment.cleanidx;
    % Legacy
    if size(segment.cleanidx,1)~=1
        keyboard
        idx = segment.refidx(1):segment.refidx(2);
        idx = idx(segment.cleanidx);
        segment.cleanidx = idx;
    else
        idx = segment.cleanidx;
    end
else
    isclean = 0;
end

if isempty(cell2mat(area))
    error('missing Area data.')
end

segment.area = area{l}(idx);
segment.curvature = curvature{l}(idx);
segment.torsion = torsion{l}(idx);

datainfo.segs = segs;
datainfo.x = x;
datainfo.y = y;
datainfo.z = z;

