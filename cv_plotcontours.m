function [] = cv_plotcontours(data,segment)

% reference numbers for polygon point sizes

% j = 1;
% idx = cell(size(polygons));
% pcontour = cell(size(polygons));
% for i = 1:length(polygons)-1
%     idx{i} = j:j+polygons(i)-1;
%     pcontour{i} = sections(idx{i},:);
%     j = j + polygons(i);
% end
%     idx{end} = j:j+polygons(end);


%% CHECK RESULTS: plot line from original data

segs = [0;find(abs(diff(data.clines(:,1)))>1);length(data.clines)];

x=cell([size(segs,1)-1,1]);
y=cell([size(segs,1)-1,1]);
z=cell([size(segs,1)-1,1]);
for i = 1:length(segs)-1
    x{i} = data.clines(segs(i)+1:segs(i+1),1);
    y{i} = data.clines(segs(i)+1:segs(i+1),2);
    z{i} = data.clines(segs(i)+1:segs(i+1),3);
    %pause
end


l = segment.line;
a = segment.refidx(1);
b = segment.refidx(2);

% figure; hold on;
plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'r-','linewidth',10)
% plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'*')

% Plot Sections
poly = data.polygonidx(segs(l)+1+a:segs(l)+1+b,1);
for i = 1:length(poly)
    X = data.sections(poly{i},:);
    plot3(X(:,1),X(:,2),X(:,3),'b-')
end
% axis equal
% sum(cell2mat(cellfun(@(v) size(v,1),x,'uni',0)))