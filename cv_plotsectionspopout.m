function popoutHandle = cv_plotsectionspopout(data,segment)

popoutHandle = cv_popoutwin('Figure');

[~,~,area] = cv_updatesegment(data,segment);

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
dIdx = setdiff(rIdx,cIdx);
Rloop=zeros(size(dIdx));
if isclean
    Cloop=[];
    for i = 1:length(dIdx)
        Rloop(i) = find(rIdx==dIdx(i));
    end
    Cloop = setdiff(1:length(rIdx),Rloop);
else
    Rloop = 1:length(rIdx);
end


% Plot Area
plot(area{l}(rIdx),'b--'); hold on
plot(area{l}(rIdx),'r*')
if isclean
    plot(Cloop,area{l}(cIdx),'b*')
end
