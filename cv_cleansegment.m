function cv_cleansegment(handles)


if ~isfield(getappdata(handles.guifig),'hilightSegment')
    fprintf('No active segment.\r')
    return    
end

[options,segment,cleanFig] = cv_plotcleanarea(handles,'Flag','handles');

% Save % Ask to overwrite
A = cv_savecleansegment(options,segment,cleanFig);



%% Option to cancel mutliple times
if strcmp(A,'Cancel')
    [options,segment,cleanFig] = cv_plotcleanarea(handles,'Flag','handles');
    A = cv_savecleansegment(options,segment,cleanFig);
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig] = cv_plotcleanarea(handles,'Flag','handles');     
    A = cv_savecleansegment(options,segment,cleanFig);
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig] = cv_plotcleanarea(handles,'Flag','handles');     
    A = cv_savecleansegment(options,segment,cleanFig);
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig] = cv_plotcleanarea(handles,'Flag','handles');     
    A = cv_savecleansegment(options,segment,cleanFig);
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig] = cv_plotcleanarea(handles,'Flag','handles');     
    A = cv_savecleansegment(options,segment,cleanFig);
end

if strcmp(A,'Cancel')
    return
end

