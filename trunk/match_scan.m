
function [val, cord] = match_scan(img_file, dir, background, box_file,  nbins, area_threshold, with_nbrd)

back=double(imread(background));
%width=33;
%height=45;
%width=41;
%height=81;
%nbins = 10;
filename =img_file;
directory=dir;

% read  image in rgb, used for emd later
img = sprintf('%s/%s',directory,filename);
im=imread(img);
im_gray = rgb2gray(im);
[m,n]=size(im_gray);

% subtract background from image to get differences
diff = abs(double(im_gray)-back);
thresh=max(max(diff))/5;
diff(diff<thresh)=0;
diff(diff>=thresh)=1;

% get image with background removed
%im_filt = zeros(m,n,3);
%for i=1:3
   % im_filt(:,:,i) = im(:,:,i).*diff;
%end

% get box and compare
box1=imread(box_file);
[height,width,z]=size(box1);

dist_matrix = ones(m,n)*200;

% obtain connected components
BW = logical(diff);
s1  = regionprops(BW, 'centroid');
centroids = cat(1, s1.Centroid);
s2 = regionprops(BW,'area');
areas = cat(1,s2.Area);
ind = find(areas>area_threshold);
vx = round(centroids(ind,1));
vy = round(centroids(ind,2));
  
% calculate EMD distances for box1 over foreground
% search only centroids, or also neighborhood (slower, but more accurate)
if (with_nbrd)
    for i=1:size(vx,1)
        px = vx(i); py = vy(i);
        for i=px-15:5:px+15
            for j=py-15:5:py+15
                fx=i;fy=j;
                [x1,y1,x2,y2]=getrect2([fy,fx],width,height,m,n);
                box2=im(y1:y2,x1:x2,:);
                % skip over cropped boxes (edge of screen)
                if  (size(box1) == size(box2))
                    val =  emdrgb(box1,box2);
                    %val = mean_dist(box1,box2);
                    dist_matrix(fx,fy) = val;
                end
            end
        end
    end    
else
    for i=1:size(vx,1)
        px = vx(i); py = vy(i);
        [x1,y1,x2,y2]=getrect2([py,px],width,height,m,n);
        box2=im(y1:y2,x1:x2,:);
        % skip over cropped boxes (edge of screen)
        if  (size(box1) == size(box2))
            val =  emdrgb(box1,box2);
            %val = mean_dist(box1,box2);
            dist_matrix(px,py) = val;
        end
    end
end
% strange bug workaround
dist_matrix(dist_matrix==0)=200;

[val,cord]=min2d(dist_matrix);

[x1,y1,x2,y2]=getrect([cord(2),cord(1)],width,height);
im_r = drawrect(im, uint16(x1), uint16(y1), uint16(x2),uint16(y2),255);
imshow(im_r);
title_string = sprintf('x=%d, y=%d, Min EMD value: %f',cord(2),cord(1),val);
title(title_string);
hold on;
plot(vx,vy,'w*');
hold on;
plot(cord(1),cord(2),'r*');
% reverse coordinates for tracking
%cord_ret = [cord(2) cord(1)];
