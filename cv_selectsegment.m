function [segment] = cv_selectsegment(data,xs,ys,zs,start_cursor,end_cursor,segname)

segs = cv_findsegments(data);
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

% find line manually from pt flag
if ~isempty(start_cursor) && ~isempty(end_cursor)
    % Process Start Cursor
    [~,spln,~,splr] = processcursor(start_cursor,xs,ys,zs);
    % ref original data
    % og_linesize = cell2mat(cellfun(@(t) size(t,1),x,'uni',0))';
    startpos = [xs{spln(1)}(splr(1)),ys{spln(1)}(splr(1)),zs{spln(1)}(splr(1))];
    
    % Process End Cursor
    [~,epln,~,eplr] = processcursor(end_cursor,xs,ys,zs);
    endpos = [xs{epln(1)}(eplr(1)),ys{epln(1)}(eplr(1)),zs{epln(1)}(eplr(1))];
    
elseif ~isempty(start_cursor) && isempty(end_cursor)
    % Process Start Cursor
    [~,spln,~,splr] = processcursor(start_cursor,xs,ys,zs);
    startpos = [xs{spln(1)}(splr(1)),ys{spln(1)}(splr(1)),zs{spln(1)}(splr(1))];
    
    % Use Line from Start Cursor and process to end
    epln=spln;
    endpos = [xs{epln(1)}(end),ys{epln(1)}(end),zs{epln(1)}(end)];
    
elseif  isempty(start_cursor) && ~isempty(end_cursor)
    % Process End Cursor First
    [~,epln,~,eplr] = processcursor(end_cursor,xs,ys,zs);
    endpos = [xs{epln(1)}(eplr(1)),ys{epln(1)}(eplr(1)),zs{epln(1)}(eplr(1))];
    
    % Use Line from End Cursor and process from start
    spln = epln;
    startpos = [xs{spln(1)}(1),ys{spln(1)}(1),zs{spln(1)}(1)];
    
elseif  isempty(start_cursor) && isempty(end_cursor)
    error('Please select a point along the line')
end

% Save data further
segment.name = segname;
if isequal(epln(1),spln(1))
    segment.line = spln(1);
else
    % you have selected different lines for start v. end points
    % Choose manually now. e.g. segment.line=spln(1);
    keyboard
end
segment.refidx(1) = find(x{spln(1)}==startpos(1));
segment.refidx(2) = find(x{epln(1)}==endpos(1));

line = segment.line;
a = segment.refidx(1);
b = segment.refidx(2);

if isempty(cell2mat(area))
    error('missing Area data.')
end
segment.area = area{line}(a:b);


%===============================================================
function [refidx,linenow,ptnow,lineref] = processcursor(cursor,xs,ys,zs)
idx=find(~cellfun(@isempty,xs))';
t1=find(cell2mat(xs(idx))==cursor.Position(1));
t2=find(cell2mat(ys(idx))==cursor.Position(2));
t3=find(cell2mat(zs(idx))==cursor.Position(3));
if isequal(t1,t2) && isequal(t2,t3)
    for i=1:length(idx)
        linesize(i)=size(xs{idx(i)},1);
    end
    cumlinesize=cumsum(linesize);
    refidx=[]; linenow=[]; ptnow=[]; lineref=[];
    for i=1:length(t1)
        tmp = find(t1(i)<=cumlinesize);
        refidx(i)   = tmp(1);
        linenow(i)  = idx(refidx(i));
        ptnow(i)    = t1(i);
        if refidx(i)~=1 && ~any(ptnow(i)==cumlinesize)
            lineref(i)  = t1(i)-cumlinesize(refidx(i)-1);
        elseif refidx(i)==1 && ~any(ptnow(i)==cumlinesize)
            lineref(i)  = t1(i);
        elseif any(ptnow(i)==cumlinesize)
            lineref(i)  = t1(i)-cumlinesize(refidx(i)-1);
        end
    end
end
% linenow
% ptnow
% lineref
