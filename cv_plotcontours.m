function [sections,polyH] = cv_plotcontours(data,segment)

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


% Get indices
l = segment.line;
rIdx = segment.refidx(1):segment.refidx(2);
try
    cIdx = segment.cleanidx;
    isclean = true;
catch
    isclean = false;
end

% And index the indices
if isclean
    dIdx = setdiff(rIdx,cIdx);
    Rloop=zeros(size(dIdx));
    for i = 1:length(dIdx)
        Rloop(i) = find(rIdx==dIdx(i));
    end
    Cloop = setdiff(1:length(rIdx),Rloop);    % Cloop=zeros(size(cIdx));
else
    Rloop = 1:length(rIdx);
end

% Get All Polygons from Reference
sections = data.polygonidx(segs(l)+rIdx-2,1); % REALLY MINUS 2?? see GA003 @LP1


% Plot polygons
polyH = cell(size(sections));
for i = Rloop
    X = data.sections(sections{i},:);
    polyH{i} = plot3(X(:,1),X(:,2),X(:,3),'r-');
    set(polyH{i},'Tag','reference')
end

if isclean
    for i = Cloop
        X = data.sections(sections{i},:);
        polyH{i} = plot3(X(:,1),X(:,2),X(:,3),'b-');
        set(polyH{i},'Tag','clean')
    end
end

return
    
% figure; hold on;
% polyH = plot3(x{l}(idx),y{l}(idx),z{l}(idx),'r-','linewidth',10);
% plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'*')
% axis equal
% sum(cell2mat(cellfun(@(v) size(v,1),x,'uni',0)))


% if isclean
%     rPoly = data.polygonidx(segs(l)+setdiff(rIdx,cIdx),1);
% else
%     rPoly = data.polygonidx(segs(l)+rIdx,1);
% end
