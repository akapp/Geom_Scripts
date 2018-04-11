%
[pind,xs,ys,zs] = selectdata3('selectionmode','lasso')
%

%%
% Check to flipud
ssel = cell2mat(cellfun(@(t) size(t,1),xs,'uni',0));
sorg = cell2mat(cellfun(@(t) size(t,1),x,'uni',0));
if isequal(flipud(ssel),sorg)
    pind = flipud(pind);
    xs = flipud(xs);
    ys = flipud(ys);
    zs = flipud(zs);
    fud = 1
else
    fud = 0
end
%
[pind,xs,ys,zs] = selectdata3('selectionmode','lasso','Flip',fud)
%

% plot selection
c=reshape([hc.Color]',[3,size(hc,1)])'; %line colors
idx=find(~cellfun(@isempty,xs))';
figure; hold on
for i=idx
    plot3(xs{i},ys{i},zs{i},'*','color',c(i,:));
end

% Define segment of interest
[segment] = cv_selectsegment(data,xs,ys,zs,o1,o2,'RACA1')
[segment] = cv_selectsegment(data,xs,ys,zs,o1,[],'RACA1')
[segment] = cv_selectsegment(data,xs,ys,zs,o1,[],'LACA1')
%

% plot selected line colors
tmpx=1:length(idx);
tmpy=1:length(idx);
figure; hold on
for i=1:length(idx)
    plot(tmpx(i),tmpy(i),'*','color',c(idx(i),:))
end

% plot selection from original data
%idx=find(~cellfun(@isempty,xs))';
figure; hold on
for i=idx
    plot3(x{i}(pind{i}),y{i}(pind{i}),z{i}(pind{i}),'*','color',c(i,:));
end

% plot Manually selected linenow
%idx=linenow;
figure; hold on
cnt=1;
for i = linenow
    plot3(xs{i}(lineref(cnt):end),ys{i}(lineref(cnt):end),zs{i}(lineref(cnt):end),'*','color',c(i,:));
    cnt=cnt+1;
end

% CHECK RESULTS: plot line from original data
figure; hold on;
l = segment.line;
a = segment.refidx(1);
b = segment.refidx(2);
plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'g-','linewidth',10)

plot3(x{l}(a:b),y{l}(a:b),z{l}(a:b),'*','linewidth',10)

% Plot Sections
poly = data.polygonidx(segs(l)+1+a:segs(l)+1+b,1);
for i = 1:length(polygons)
    X = data.sections(poly{i},:)
    plot3(X(:,1),X(:,2),X(:,3),'b-')
end

% sum(cell2mat(cellfun(@(v) size(v,1),x,'uni',0)))
%%
% Plot All Line colors
tmpx=1:length(hc);
tmpy=1:length(hc);
figure; hold on
for i=1:length(hc)
    plot(tmpx(i),tmpy(i),'*','color',c(i,:))
end
for i=idx
    %plot(x(i),y(i),'ko','markersize',12)
    plot(tmpx(i),tmpy(i),'.','color',c(i,:)) %,'linewidth',24,'markersize',24)
end

%
[kappa,tau,T,N,B,s,ds,dX,dT,dB,X] = cv_getparams(xs,ys,zs)
cv_plottangent(xs,ys,zs,B,T,N,c)
%


% get tangent vectors
%curve = [cell2mat(xs(idx)),cell2mat(ys(idx)),cell2mat(zs(idx))];
curve = [xs{7},ys{7},zs{7}];
[kappa,tau,T,N,B,s,ds,dX,dT,dB] = ifrenetserret(curve)
%%
pt = [find(data.clines(:,1)==A.Position(1,1)),...
    find(data.clines(:,2)==A.Position(1,2)),...
    find(data.clines(:,3)==A.Position(1,3))];

if isequal(pt(1),pt(2))&&isequal(pt(2),pt(3))
    segnow=find(segs<pt(1));
    i=segnow(end);
    h{i} = plot3(data.clines(segs(i)+1:segs(i+1),1),...
        data.clines(segs(i)+1:segs(i+1),2),...
        data.clines(segs(i)+1:segs(i+1),3),'*');
    
end
% Y = A/P
% Z = S/I
% X = L>R>0
[(max(data.clines(:,1))-min(data.clines(:,1)))./2,...
    max(data.clines(:,2)),...
    max(data.clines(:,3))]