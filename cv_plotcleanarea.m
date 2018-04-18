function [options,segment,cleanFig,A] = cv_plotcleanarea(varargin)

% segment = cv_plotcleanarea(handles,'Flag','handles')
% segment = cv_plotcleanarea(segment)

if length(varargin)==1
    segment = varargin{1};
elseif length(varargin)>=2
    handles = varargin{1}; % guifig handle
end

cleanFig = cv_popoutwin('Clean Area');

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

[~,isclean,area] = cv_updatesegment(data,segment);
l = segment.line;
rIdx = segment.refidx(1):segment.refidx(2);
plot(area{l}(rIdx))
selection = cv_brushui(cleanFig);
if isempty(selection)
    fprintf('No data selected.\r')
    close(cleanFig);
    A = 'Cancel';
    return
else
    A = 'Yes';
end
cIdx = selection(:,1);
segment.cleanidx = rIdx(cIdx);
segment = cv_updatesegment(data,segment);

%     try delete(guifig,'hilightSegment'); end
%     try rmappdata(guifig,'hilightSegment'); end
%     try rmappdata(guifig,'segment'); end
end

