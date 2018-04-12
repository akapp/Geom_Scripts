function [options,segment,cleanFig] = cv_plotcleanarea(varargin)

% segment = cv_plotcleanarea(handles,'Flag','handles')
% segment = cv_plotcleanarea(segment)

if length(varargin)==1
    segment = varargin{1};
elseif length(varargin)>=2
    handles = varargin{1}; % guifig handle
end

cleanFig = figure('Visible','on', ...
    'Name','Clean Area',...
    'NumberTitle',   'off', ...
    'IntegerHandle', 'off', ...
    'MenuBar',       'none', ...
    'Toolbar',       'none', ...
    'DockControls',  'on', ...
    'Units',         'pixels', ...
    'Color',         [1 1 1], ...
    'Tag',           'cleanareaplot',...
    'Position', [76   644   396   287]);

if exist('handles','var')
    guifig = handles.guifig;
    segment = getappdata(guifig,'segment');
    ok = 1;
    ingui = 1; % Not outside of main gui
else
    H = findall(0,'Type','Figure');
    try 
        guifig = H(contains({H(:).Tag},'guifig'));
        ingui = 0;
        ok = 1;
    catch
        ok = 0;
    end
end

if ok
    handles = getappdata(guifig,'handles');
    options = getappdata(guifig,'options');
    data = getappdata(guifig,'data');
else
    return
end

%% 
% Plot Segment Area
set(0,'CurrentFigure',cleanFig)

plot(segment.area)
selection = cv_brushui(cleanFig);
segment.cleanidx = selection(:,1);
segment = cv_updatesegment(data,segment);

%     try delete(guifig,'hilightSegment'); end
%     try rmappdata(guifig,'hilightSegment'); end
%     try rmappdata(guifig,'segment'); end
end

