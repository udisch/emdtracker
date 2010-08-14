function  [last_img]=play_image_strip( img_name_base, directory, start_index, last_index )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for img_index=start_index:last_index    
   img_file = sprintf('%s%.4d.png',img_name_base,img_index);
  imgfile=sprintf('%s/%s',directory,img_file);
  if (~exist(imgfile))
      break;
  end
  im = imread(imgfile);  
  imshow(im);
  pause(0.0001);
end

last_img=imgfile;
%last_img=2;

