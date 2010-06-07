
function [cord] = getInput(img_file, dir, background, width, height,  area_threshold)

back=double(imread('back_white.png'));
%width=33;
%height=45;

filename = img_file;
directory=dir;

% read  image in rgb
img = sprintf('%s/%s',directory,filename);
im=imread(img);
im_gray = rgb2gray(im);
[m,n]=size(im_gray);

% subtract background from image to get differences
diff = abs(double(im_gray)-back);
thresh=max(max(diff))/5;
diff(diff<thresh)=0;
diff(diff>=thresh)=1;

% obtain foreground pixels
BW = logical(diff);
s1  = regionprops(BW, 'centroid');
centroids = cat(1, s1.Centroid);
s2 = regionprops(BW,'area');
areas = cat(1,s2.Area);
ind = find(areas>area_threshold);
vx = round(centroids(ind,1));
vy = round(centroids(ind,2));

imshow(im);
hold on;
plot(vx,vy,'w*');
[m_x,m_y]=ginput(1);
mouse_x = uint16(m_x);
mouse_y = uint16(m_y);

 [x1,y1,x2,y2]=getrect([mouse_x,mouse_y],height,width); 
 box=im(x1:x2,y1:y2,:);
 imwrite(uint8(box),'box.png','png');
im_r = drawrect(im, y1, x1, y2,x2,255);
imshow(im_r);
hold on;
plot(vx,vy,'w*');
pause;
close;

cord = ([mouse_x mouse_y]);