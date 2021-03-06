function [segment] = cv_selectsegment(varargin)

%% Parse Inputs

if isstruct(varargin{1})
    data = varargin{1};
    segs = cv_getsegs(data);
    x=cell([size(segs,1)-1,1]);
    for i = 1:length(segs)-1
        x{i} = data.clines(segs(i)+1:segs(i+1),1);
    end
    
    xs=varargin{2};     ys=varargin{3};     zs=varargin{4};
    start_cursor=varargin{5};
    end_cursor=varargin{6};
    segname=varargin{7};

elseif iscell(varargin{1})    
    
    x=varargin{1};      y=varargin{2};      z=varargin{3};
    xs=varargin{4};     ys=varargin{5};     zs=varargin{6};
    start_cursor=varargin{7};
    end_cursor=varargin{8};
    segname=varargin{9};
    
end

%% Parse Cursor inputs
% find line manually from pt flag
if ~isempty(start_cursor)
    % Process Start Cursor
    [~,spln,~,splr] = cv_processcursor(start_cursor,xs,ys,zs);
    startpos = [xs{spln(1)}(splr(1)),ys{spln(1)}(splr(1)),zs{spln(1)}(splr(1))];
end

if ~isempty(end_cursor)    
    % Process End Cursor
    [~,epln,~,eplr] = cv_processcursor(end_cursor,xs,ys,zs);
    endpos = [xs{epln(1)}(eplr(1)),ys{epln(1)}(eplr(1)),zs{epln(1)}(eplr(1))];
end

if  isempty(start_cursor) && isempty(end_cursor)
    error('Please select a point along the line')
end

if  isempty(start_cursor)    
    % Use Line from End Cursor and process from start
    spln = epln;
    startpos = [xs{spln(1)}(1),ys{spln(1)}(1),zs{spln(1)}(1)];
end

if isempty(end_cursor)
    % Use Line from Start Cursor and process to end
    epln=spln;
    endpos = [xs{epln(1)}(end),ys{epln(1)}(end),zs{epln(1)}(end)];
end

%% Save data further
segment.name = segname;
if isequal(epln(1),spln(1))
    segment.line = spln(1);
    man = false;
else
    % you have selected different lines for start v. end points
    % Choose manually now. e.g. segment.line=spln(1);
    spln
    epln
    keyboard
    % segment.line = spln
    % segment.line = epln
    man = true;
    %     chkFig = cv_plotline(xs,ys,zs,spln,splr);
    %     chkFig = cv_plotline(xs,ys,zs,epln,eplr);
end
segment.refidx(1) = find(x{spln(1)}==startpos(1));
segment.refidx(2) = find(x{epln(1)}==endpos(1));
prefs = cv_defaultprefs;
if prefs.verbose
    disp(segment)
end

if segment.refidx(1)>segment.refidx(2)
    fprintf('Segment was backwards (end to start).\r Flipping markers now.\r')
    segment.refidx = fliplr(segment.refidx);
    disp(segment)
end

% if man
%     segment
%     keyboard
% end

segment = cv_updatesegment(data,segment);

% linenow
% ptnow
% lineref



% %% Parse Cursor inputs
% % find line manually from pt flag
% if ~isempty(start_cursor) && ~isempty(end_cursor)
%     % Process Start Cursor
%     [~,spln,~,splr] = processcursor(start_cursor,xs,ys,zs);
%     % ref original data
%     % og_linesize = cell2mat(cellfun(@(t) size(t,1),x,'uni',0))';
%     startpos = [xs{spln(1)}(splr(1)),ys{spln(1)}(splr(1)),zs{spln(1)}(splr(1))];
%     
%     % Process End Cursor
%     [~,epln,~,eplr] = processcursor(end_cursor,xs,ys,zs);
%     endpos = [xs{epln(1)}(eplr(1)),ys{epln(1)}(eplr(1)),zs{epln(1)}(eplr(1))];
%     
% elseif ~isempty(start_cursor) && isempty(end_cursor)
%     % Process Start Cursor
%     [~,spln,~,splr] = processcursor(start_cursor,xs,ys,zs);
%     startpos = [xs{spln(1)}(splr(1)),ys{spln(1)}(splr(1)),zs{spln(1)}(splr(1))];
%     
%     % Use Line from Start Cursor and process to end
%     epln=spln;
%     endpos = [xs{epln(1)}(end),ys{epln(1)}(end),zs{epln(1)}(end)];
%     
% elseif  isempty(start_cursor) && ~isempty(end_cursor)
%     % Process End Cursor First
%     [~,epln,~,eplr] = processcursor(end_cursor,xs,ys,zs);
%     endpos = [xs{epln(1)}(eplr(1)),ys{epln(1)}(eplr(1)),zs{epln(1)}(eplr(1))];
%     
%     % Use Line from End Cursor and process from start
%     spln = epln;
%     startpos = [xs{spln(1)}(1),ys{spln(1)}(1),zs{spln(1)}(1)];
%     
% elseif  isempty(start_cursor) && isempty(end_cursor)
%     error('Please select a point along the line')
% end