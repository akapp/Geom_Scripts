function [segment] = cv_selectsegment(varargin)

if isstruct(varargin{1})
    data = varargin{1};
    segs = cv_getsegs(data);
    x=cell([size(segs,1)-1,1]);
    y=cell([size(segs,1)-1,1]);
    z=cell([size(segs,1)-1,1]);
    for i = 1:length(segs)-1
        x{i} = data.clines(segs(i)+1:segs(i+1),1);
        y{i} = data.clines(segs(i)+1:segs(i+1),2);
        z{i} = data.clines(segs(i)+1:segs(i+1),3);
    end
    
    xs=varargin{2};
    ys=varargin{3};
    zs=varargin{4};
    start_cursor=varargin{5};
    end_cursor=varargin{6};
    segname=varargin{7};

elseif iscell(varargin{1})
    
    x=varargin{1};
    y=varargin{2};
    z=varargin{3};
    
    xs=varargin{4};
    ys=varargin{5};
    zs=varargin{6};
    start_cursor=varargin{7};
    end_cursor=varargin{8};
    segname=varargin{9};
    
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

segment = cv_updatesegment(data,segment);

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
