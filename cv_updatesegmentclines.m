function segment = cv_updatesegmentclines(data,segment)

% Curvature = data.geom(:,10);

segs = cv_getsegs(data);
x=cell([size(segs,1)-1,1]);
y=cell([size(segs,1)-1,1]);
z=cell([size(segs,1)-1,1]);
for i = 1:length(segs)-1
    x{i} = data.clines(segs(i)+1:segs(i+1),1);
    y{i} = data.clines(segs(i)+1:segs(i+1),2);
    z{i} = data.clines(segs(i)+1:segs(i+1),3);
end

line = segment.line;
if size(segment.refidx,2)==2
    idx = [segment.refidx(1):segment.refidx(2)];
else
    idx = segment.refidx;
end

segment.clines = [x{line}(idx),y{line}(idx),z{line}(idx)];
