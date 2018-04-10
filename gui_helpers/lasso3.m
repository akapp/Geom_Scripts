function [selx,sely,selz,indexnr]=lasso3(x,y,z)

% lasso -  enables the selection/encircling of (clusters of) events in a scatter plot by hand 
%          using the mouse
% 
% Input:    x,y                 - a set of points in 2 column vectors.
% Output:   selx,sely,indexnr   - a set of selected points in 3 column vectors 
% 
% Note:   After the scatter plot is given, selection by mouse is started after any key press. 
%         This is done to be able to ZOOM or CHANGE AXES etc. in the representation before selection 
%         by mouse.
%         Encircling is done by pressing subsequently the LEFT button mouse at the requested positions 
%         in a scatter plot.
%         Closing the loop is done by a RIGHT button press.
%         
% T.Rutten V2.0/9/2003

plot3(x,y,z,'.')

las_x=[];
las_y=[];
las_z=[];

c=1;

key=0;

disp('press a KEY to start selection by mouse, LEFT mouse button for selection, RIGHT button closes loop')
while key==0
key=waitforbuttonpress;
pause(0.2)
end

while c==1 

[a,b,c]=ginput3(1);
las_x=[las_x;a];
las_y=[las_y;b];
las_z=[las_z;c];
line(las_x,las_y,las_z)
end

las_x(length(las_x)+1)=las_x(1);
las_y(length(las_y)+1)=las_y(1);
las_z(length(las_z)+1)=las_z(1);

line(las_x,las_y,las_z)
pause(.2)

% in=inpolygon(x,y,las_x,las_y);
in = inhull([x,y,z],[las_x,las_y,las_z]);

ev_in=find(in>0);

selx=x(ev_in);
sely=y(ev_in);
selz=z(ev_in);

figure,plot(x,y,'b.',selx,sely,'g.');
legend(num2str([length(x)-length(selx);length(selx)]));

indexnr=ev_in;