function [hstar,hline] = cv_plotpolyselection(varargin)

xs = varargin{1};
ys = varargin{2};
zs = varargin{3};

    idx=find(~cellfun(@isempty,xs))';
    fighandle = figure; 
    axes = get(fighandle,'currentAxes');
    hold all
    for i=idx
        hstar{i} = plot3(xs{i},ys{i},zs{i},'*');
        hline{i} = plot3(xs{i},ys{i},zs{i},'-','color',hstar{i}.Color);
    end
    axis equal

     % Button Motion and Button Up
      %set(fighandle,'WindowButtonMotionFcn',@linehighlighter);
      %set(fighandle,'WindowButtonUpFcn',@selectdone);

      % wait until the selection is done
      %uiwait

% =====================================================
function linehighlighter(src,evnt)

 % get the new mouse position
  Axes = get(gca,fighandle);
  mousenew = get(Axes,'CurrentPoint');
  mousenew = mousenew(1,:)
  
    % make sure the axes are fixed
    axis(axissize)