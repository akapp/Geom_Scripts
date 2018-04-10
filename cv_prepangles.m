% Tx = data.geom(:,12);
% Ty = data.geom(:,13);
% Tz = data.geom(:,14);
% Nx = data.geom(:,15);
% Ny = data.geom(:,16);
% Nz = data.geom(:,17);
% Bx = data.geom(:,18);
% By = data.geom(:,19);
% Bz = data.geom(:,20);

Tangent = [data.geom(:,12),data.geom(:,13),data.geom(:,14)];
Normal  = [data.geom(:,15),data.geom(:,16),data.geom(:,17)];
Binormal = [data.geom(:,18),data.geom(:,19),data.geom(:,20)];

segs = cv_getsegs(data); % nsegs = length(segs)-1;
x=cell([size(segs,1)-1,1]);
y=cell([size(segs,1)-1,1]);
z=cell([size(segs,1)-1,1]);
for i = 1:length(segs)-1
    x{i} = data.clines(segs(i)+1:segs(i+1),1);
    y{i} = data.clines(segs(i)+1:segs(i+1),2);
    z{i} = data.clines(segs(i)+1:segs(i+1),3);
    Tx{i} = Tangent(segs(i)+1:segs(i+1),1);
    Ty{i} = Tangent(segs(i)+1:segs(i+1),2);
    Tz{i} = Tangent(segs(i)+1:segs(i+1),3);
    Nx{i} = Normal(segs(i)+1:segs(i+1),1);
    Ny{i} = Normal(segs(i)+1:segs(i+1),2);
    Nz{i} = Normal(segs(i)+1:segs(i+1),3);
    Bx{i} = Binormal(segs(i)+1:segs(i+1),1);
    By{i} = Binormal(segs(i)+1:segs(i+1),2);
    Bz{i} = Binormal(segs(i)+1:segs(i+1),3);
end
% axis equal
clear h i

% l = segment.line;
% a = segment.refidx(1);
% b = segment.refidx(2);
% plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'r-','linewidth',10)

% %quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Tx{l}(a:b),Ty{l}(a:b),Tz{l}(a:b),'b'); %blue
% %quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Bx{l}(a:b),By{l}(a:b),Bz{l}(a:b),'g'); %green

%quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Nx{l}(a:b),Ny{l}(a:b),Nz{l}(a:b),'r'); %red

    % quiver3(x{l}(a),y{l}(a),z{l}(a),Nx{l}(a),Ny{l}(a),Nz{l}(a),'g'); %red
    % quiver3(x{l}(b),y{l}(b),z{l}(b),Nx{l}(b),Ny{l}(b),Nz{l}(b),'g'); %red

% Will Measure from Normal vector
