function chkFig = cv_plotline(x,y,z,line,ref,chkFig)

% plot selected line to check figure
% Called from cv_datatip

if ~exist('chkFig','var')
    chkFig = cv_popoutwin('Selected Segment');
end

set(0,'CurrentFigure',chkFig)
    
hold on
H(1) = plot3(x{line},y{line},z{line},'b-');
if exist('ref','var')
    H(2) = plot3(x{line}(ref),y{line}(ref),z{line}(ref),'r*');
end
axis equal