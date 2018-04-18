function cv_cleansegment(handles)


if ~isfield(getappdata(handles.guifig),'hilightSegment')
    fprintf('No active segment.\r')
    return    
end

[options,segment,cleanFig,A] = cv_plotcleanarea(handles,'Flag','handles');

% Save % Ask to confirm
if ~strcmp(A,'Cancel')
    A = cv_savecleansegment(options,segment,cleanFig);
end



%% Option to cancel mutliple times
if strcmp(A,'Cancel')
    [options,segment,cleanFig,A] = cv_plotcleanarea(handles,'Flag','handles');
    if ~strcmp(A,'Cancel')
        A = cv_savecleansegment(options,segment,cleanFig);
    end
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig,A] = cv_plotcleanarea(handles,'Flag','handles');
    if ~strcmp(A,'Cancel')
        A = cv_savecleansegment(options,segment,cleanFig);
    end
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig,A] = cv_plotcleanarea(handles,'Flag','handles');
    if ~strcmp(A,'Cancel')
        A = cv_savecleansegment(options,segment,cleanFig);
    end
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig,A] = cv_plotcleanarea(handles,'Flag','handles');
    if ~strcmp(A,'Cancel')
        A = cv_savecleansegment(options,segment,cleanFig);
    end
end

if strcmp(A,'Cancel')
    [options,segment,cleanFig,A] = cv_plotcleanarea(handles,'Flag','handles');
    if ~strcmp(A,'Cancel')
        A = cv_savecleansegment(options,segment,cleanFig);
    end
end

if strcmp(A,'Cancel')
    return
end

