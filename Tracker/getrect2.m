function [x1,y1,x2,y2]=getrect(center,width,height, m, n)
%GETRECT  Get coordination of a rectangle with a center, width, and height of window.
%   [X1,Y1,X2,Y2] = GETRECT(CENTER, WIDTH, HEIGHT) gets coordination 
%   of a rectangle which center is on CENTER, and which width and height are 
%   WIDTH and HEIGHT. 
x1=center(2)-(width-1)/2;
y1=center(1)-(height-1)/2;
x2=center(2)+(width-1)/2;
y2=center(1)+(height-1)/2;
v=[x1 y1 x2 y2];
v(v<1)=1;
vx=[v(1) v(3)];
vx(vx>m)=m;
vy=[v(2) v(4)];
vx(vx>n)=n;
x1=vx(1);
y1=vy(1);
x2=vx(2);
y2=vy(2);