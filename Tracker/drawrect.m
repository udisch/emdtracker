function I=drawrect(image,x1,y1,x2,y2,color)
%DRAWRECT  Draw a color rectagule on the image
%   I = DRAWRECT(IMAGE, X1, Y1, X2, Y2, COLOR) draws a rectangle where the coordination
%   of the left upper point is (X1,Y1) and the coordination of the right lower point is (X2,Y2).
%   The color of rectangle line is defined by COLOR as 0 (black) or 255 (white).
I=image;

I(y1,x1:x2,:)=color;
I(y2,x1:x2,:)=color;
I(y1:y2,x1,:)=color;
I(y1:y2,x2,:)=color;