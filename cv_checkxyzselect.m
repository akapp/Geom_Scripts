function chk = cv_checkxyzselect(x,y,z,pind,xs,ys,zs)

% Check to flipud
xcheck = zeros(size(pind));
ycheck = zeros(size(pind));
zcheck = zeros(size(pind));
if iscell(pind)
    for i = 1:length(pind)
        if ~isempty(pind{i})
            xcheck(i) = isequal(xs{i},x{i}(pind{i}));
            ycheck(i) = isequal(ys{i},y{i}(pind{i}));
            zcheck(i) = isequal(zs{i},z{i}(pind{i}));
        else
            xcheck(i) = 1;
            ycheck(i) = 1;
            zcheck(i) = 1;
        end
    end
end

if any(xcheck==0) || any(ycheck==0) || any(zcheck==0)
   disp([xcheck,ycheck,zcheck])
   chk = 0;
   error('Data check failed')
else
    chk = 1;
end