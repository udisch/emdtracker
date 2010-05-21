clear;
%mov = read_avi('org2b.avi');

%back= median(mov,3);
back=double(imread('back_target.png'));
width=33;
height=45;
nbins = 10;
filename = 'img0100.png';
directory='frames2b';

clear mov;

% read first image in rgb, used for emd later
img = sprintf('%s/%s',directory,filename);
im=imread(img);
im_gray = rgb2gray(im);
[m,n]=size(im_gray);

% subtract background from image to get differences
diff = abs(double(im_gray)-back);
thresh=max(max(diff))/5;
diff(diff<thresh)=0;
diff(diff>=thresh)=1;
% convert difference mask to int in order to multiply with image
%diff = uint8(diff); 

% get image with background removed
%im_filt = zeros(m,n,3);
%for i=1:3
   % im_filt(:,:,i) = im(:,:,i).*diff;
%end

% get box and compare
%[x1,y1,x2,y2]=getrect([119,133],31,25);
%box2=im(x1:x2,y1:y2,:);
box1=imread('box.png');

[f1,w1]=imhistrgb(im,nbins);
dist = ones(m,n)*200;

% obtain foreground pixels
%[vx, vy] = find(diff);
BW = logical(diff);
s1  = regionprops(BW, 'centroid');
centroids = cat(1, s1.Centroid);
s2 = regionprops(BW,'area');
areas = cat(1,s2.Area);
ind = find(areas>500);
vx = round(centroids(ind,1));
vy = round(centroids(ind,2));
  
% calculate EMD distances for box1 over foreground
 for i=1:size(vx,1)         
     px = vx(i); py = vy(i);     
     [x1,y1,x2,y2]=getrect2([py,px],height,width,m,n);     
     box2=im(x1:x2,y1:y2,:);
     [f2,w2]=imhistrgb(box2);
     [f, fval] = emd(f1, f2, w1, w2, @gdf);
     dist(px,py)=fval;
     
 end

[val,cord]=min2d(dist);

[x1,y1,x2,y2]=getrect([cord(2),cord(1)],width,height);
im_r = drawrect(im, x1, y1, x2,y2,255);
imshow(im_r);
hold on;
plot(vx,vy,'w*');
hold on;
plot(cord(1),cord(2),'r*');


