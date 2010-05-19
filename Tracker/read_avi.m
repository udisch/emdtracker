function M=read_avi(fname)
% reads movie from filename
% Return a NxMxK matrix such that M(:,:,i) is the i-th frame in the image,
% grayscale

%MOV = AVIREAD(fname);
% for i=1:size(MOV,2)
   %  M(:,:,i)=double(rgb2gray(MOV(i).cdata));
 %end
 
% on MATLAB 7 use:
MOV = mmreader(fname);
MF = read(MOV);
% get first image to pre-allocate size
M(:,:,1)=rgb2gray(MF(:,:,:,1));
[r,c, z] = size(M);
num_frames = size(MF,4);
M = zeros(r,c,num_frames);  
for i=1:num_frames
    M(:,:,i)=rgb2gray(MF(:,:,:,i));
end