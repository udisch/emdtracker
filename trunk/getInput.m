
function [cord] = getInput(img_file, dir, background, outfile, width, height, area_threshold)

back=double(imread(background));

% keep box dimensions odd
if (mod(width,2) == 0)
    width = width-1;
end
 if (mod(height,2) == 0)
    height = height-1;
 end
 
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
 imwrite(uint8(box),outfile,'png');
im_r = drawrect(im, y1, x1, y2,x2,255);
title_string = sprintf('x=%d, y=%d',mouse_y,mouse_x);
imshow(im_r);
title(title_string);
hold on;
plot(vx,vy,'w*');

cord = ([mouse_x mouse_y]);