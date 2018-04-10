function [area,diameter,perimeter] = perimetercalc(pcontour)

% calculate the area, diameter and perimeter of pcontour:
% [GA003_ACom_pcont_area,GA003_ACom_pcont_diam,GA003_ACom_peri] = perimetercalc('GA003','ACom');

n = size(pcontour,1);
perimeter = zeros(n,1);
for i = 1:n
    a = cell2mat(pcontour(i));
    p = 0;
    for j = 1:size(a,1)-1
    p = p + norm(a(j,:)-a(j+1,:));  %norm gives the euclidean distance of 
    end
    perimeter(i) = p;
end
 
diameter = perimeter/pi;
area = pi*((diameter./2).^2);


end