function [stlH,figH] = cv_plotstl(v, f, name, figH)
%STLPLOT is an easy way to plot an STL object
%V is the Nx3 array of vertices
%F is the Mx3 array of faces
%NAME is the name of the object, that will be displayed as a title
%
% Example:
%   ptdir = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061/vmtk';
%   [vertices,faces,normals,name] = stlRead('surface.stl');
%   stlPlot(vertices,faces,name);

if ~exist('figH','var')
    figH = figure3d;
    % Add a camera light, and tone down the specular highlighting
    % camlight('headlight');
    material('dull');
    
    % Fix the axes scaling, and set a nice view angle
    axis('image');
    view([-135 35]);
    set(figH,'Name',name);
end

object.vertices = v;
object.faces = f;
stlH = patch(object,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'FaceAlpha',   0.5, ...
         'AmbientStrength', 0.15);

return

% %% Plot centerlines
% data = cv_readindat(ptdir);
% 
% hold on
% segs = cv_getsegs(data);
% h=cell([size(segs,1)-1,1]);
% x=cell([size(segs,1)-1,1]);
% y=cell([size(segs,1)-1,1]);
% z=cell([size(segs,1)-1,1]);
% for i = 1:length(segs)-1
%     h{i} = plot3(data.clines(segs(i)+1:segs(i+1),1),...
%         data.clines(segs(i)+1:segs(i+1),2),...
%         data.clines(segs(i)+1:segs(i+1),3),'-','Linewidth',1.5);
%     x{i} = data.clines(segs(i)+1:segs(i+1),1);
%     y{i} = data.clines(segs(i)+1:segs(i+1),2);
%     z{i} = data.clines(segs(i)+1:segs(i+1),3);
% end
% h=[h{:}]';
% % delete(h(:))
% 
% %% Plot bifurcation angles
% cv_prepangles
% segment = load(fullfile(ptdir,'seg_rA1.mat'));  % load('seg_rA2.mat') % For DB018 use seg_rA2.mat
% l = segment.line;
% a = segment.refidx(1);
% b = segment.refidx(end);
% v1 = [Nx{l}(b),Ny{l}(b),Nz{l}(b)];
% v1H = quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Nx{l}(a:b),Ny{l}(a:b),Nz{l}(a:b),'r','Linewidth',2); %red
% % v1H = quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Tx{l}(a:b),Ty{l}(a:b),Tz{l}(a:b),'b','Linewidth',2); %red
% 
% % v1H = quiver3(x{l}(b),y{l}(b),z{l}(b),Nx{l}(b),Ny{l}(b),Nz{l}(b),'r','Linewidth',2); %red
% % v1H = quiver3(x{l}(b),y{l}(b),z{l}(b),Tx{l}(b),Ty{l}(b),Tz{l}(b),'b','Linewidth',2); %red
% % Plot Sections
% poly = data.polygonidx(segs(l-1)+1+a:segs(l-1)+1+b,1);
% for i = 1:length(poly)
%     X = data.sections(poly{i},:);
%     p1H{i} = plot3(X(:,1),X(:,2),X(:,3),'b-');
% end
% 
% 
% load(fullfile(ptdir,'seg_acomm.mat'))
% l = segment.line;
% a = segment.refidx(1);
% b = segment.refidx(2);
% v2 = [Nx{l}(b),Ny{l}(b),Nz{l}(b)];
% v2H = quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Nx{l}(a:b),Ny{l}(a:b),Nz{l}(a:b),'r','Linewidth',2); %red
% % v2H = quiver3(x{l}(a:b),y{l}(a:b),z{l}(a:b),Tx{l}(a:b),Ty{l}(a:b),Tz{l}(a:b),'b','Linewidth',2); %red
% 
% % v2H = quiver3(x{l}(b),y{l}(b),z{l}(b),Nx{l}(b),Ny{l}(b),Nz{l}(b),'r','Linewidth',2); %red
% % v2H = quiver3(x{l}(b),y{l}(b),z{l}(b),Tx{l}(b),Ty{l}(b),Tz{l}(b),'b','Linewidth',2); %red
% % poly = data.polygonidx(segs(l)+1+b,1);
% return
% poly = data.polygonidx(segs(l-1)+1+a:segs(l-1)+1+b,1);
% for i = 1:length(poly)
%     X = data.sections(poly{i},:);
%     p2H{i} = plot3(X(:,1),X(:,2),X(:,3),'b-');
% end
% % angle = radtodeg(atan2(norm(cross(v1,v2)), dot(v1,v2)));
% % quiver3(x{l}(a),y{l}(a),z{l}(a),Nx{l}(a),Ny{l}(a),Nz{l}(a),'r'); %red
% 
