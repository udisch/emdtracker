%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Implementation of kernel-based tracking with adding    %
%   background-weighted histogram algorithm                %
%                                                          % 
%   Written By Kooksang Moon for ECE 561 course            % 
%   Dec. 17th 2002                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Modified by Udi Schneider, 5/2010
% Computer Vision Workshop, IDC
function [num_frames] = trackingext(img_name_base, directory, out_dir, num_images, y_0, w_t, h_t)

% write full tracking images output
write_output = 1;
% default value for number of actual frames found
num_frames = num_images;

% background region around the target window
W=w_t+6;
H=h_t;
w_bg=w_t+36;
h_bg=h_t+40;

imgfile1=sprintf('%s%.4d.png',img_name_base,0);
imgfile1=sprintf('%s%s',directory,imgfile1);

X = imread(imgfile1);
X=double(X);

[x1_t,y1_t,x2_t,y2_t]=getrect(y_0,w_t,h_t);                     % get a rectangular window for target
[x1_bg,y1_bg,x2_bg,y2_bg]=getrect(y_0,w_bg,h_bg);     % get a rectangular window for background  

%new_X=drawrect(new_X,x1_bg,y1_bg,x2_bg,y2_bg,0);

sum_bg=0;
o_u=zeros(16,16,16);

for i=y1_bg:y2_bg
    for j=x1_bg:x2_bg
        if i<=y1_t | i>=y2_t | j<=x1_t | j>=x2_t        % background region around the target
            R=floor(X(i,j,1)/16)+1;
            G=floor(X(i,j,2)/16)+1;
            B=floor(X(i,j,3)/16)+1;
            o_u(R,G,B)=o_u(R,G,B)+1;                   % histogram of the background in the feature space
            sum_bg=sum_bg+1;
        end
    end
end

o_u=o_u/sum_bg;
temp=reshape(o_u,1,[]);
T=find(temp~=0);
o_s=min(temp(T));                   % the smallest nonzero value

for i=1:16
    for j=1:16
        for k=1:16
            index=(i-1)*256+(j-1)*16+k;
            if o_u(i,j,k)~=0
                v_u(index)=o_s/o_u(i,j,k);
            else
                v_u(index)=1;
            end
                
            if v_u(index)>1
                v_u(index)=1;
            end
        end
    end
end

sum_q=0;
histo=zeros(16,16,16);

c=((w_t-1)/2)^2+((h_t-1)/2)^2;              % c value of kernel

for i=y1_t:y2_t
    for j=x1_t:x2_t
        k=c-((i-y_0(1))^2+(j-y_0(2))^2)+1;      % add 1 to prevent a denominator from being 0
        R=floor(X(i,j,1)/16)+1;
        G=floor(X(i,j,2)/16)+1;
        B=floor(X(i,j,3)/16)+1;
        histo(R,G,B)=histo(R,G,B)+k;
    end
end

for i=1:16
    for j=1:16
        for k=1:16
            index=(i-1)*256+(j-1)*16+k;
            q_u(index)=histo(i,j,k)*v_u(index);
            sum_q=sum_q+q_u(index);
        end
    end
end
q_u=q_u/sum_q;

f_count=1;                        % count the number of frames
iteration=zeros(1,200);       % record the number of mean shift iteratin for each frame  


h=W*H;
img_index=0;

for img_index=0:num_images    
    img_file = sprintf('%s%.4d.png',img_name_base,img_index);
    imgfile=sprintf('%s%s',directory,img_file);
	
    % if reached last frame, because img_index was bigger
    % than actual number, return correct number of frames
    if (~exist(imgfile)) 
        num_frames = img_index-1;
        break;
        
    else
        X= imread(imgfile);
        X=double(X);

        y_0r=y_0;
        
       
        while 1    
            [x1,y1,x2,y2]=getrect(y_0,W,H);
            if x1<=0
                x1=1;
            end
            if y1<=0
                y1=1;
            end
            
            sum_p=0;
            histo=zeros(16,16,16);

            for i=y1:y2
                for j=x1:x2
                    k=c-(((i-y_0(1))/h)^2+((j-y_0(2))/h)^2)+1;
                    R=floor(X(i,j,1)/16)+1;
                    G=floor(X(i,j,2)/16)+1;
                    B=floor(X(i,j,3)/16)+1;
                    histo(R,G,B)=histo(R,G,B)+k;
                end
            end

            for i=1:16
                for j=1:16
                    for k=1:16
                        index=(i-1)*256+(j-1)*16+k;
                        p_u(index)=histo(i,j,k)*v_u(index);    
                        sum_p=sum_p+p_u(index);
                    end
                end
            end
            p_u=p_u/sum_p;

            n=1;
            for i=y1:y2
                for j=x1:x2
                    R=floor(X(i,j,1)/16)+1;
                    G=floor(X(i,j,2)/16)+1;
                    B=floor(X(i,j,3)/16)+1;
                    u=(R-1)*256+(G-1)*16+B;
                    x(1,n)=i;
                    x(2,n)=j;
                    w_i(n)=sqrt(q_u(u)/p_u(u));
                    n=n+1;
                end
            end

            y_1=x*w_i'/sum(w_i);            % estimated new position of window
            
            if sqrt((y_1(1)-y_0r(1))^2+(y_1(2)-y_0r(2))^2)<0.05
                break
            end
            
            y_0r=y_1;                           % real value of y_0 that is not rounded
            y_0=round(y_1);                 
            iteration(f_count)=iteration(f_count)+1;
            iteration(f_count);
        end

        y_0=round(y_1);                       % new location of tracking window
        [x1_t,y1_t,x2_t,y2_t]=getrect(y_0,w_t,h_t);
        
        new_X=drawrect(X,x1_t,y1_t,x2_t,y2_t,255);
        new_X=uint8(new_X);
        %figure       
        %close;
        
        if (write_output)
            outpath = sprintf('%s/%s',out_dir,img_file);
            imwrite(new_X,outpath,'png');            
        end
    end
    f_count=f_count+1;    
end

cord = y_0;
%imwrite(new_X,'target.png','png');
imwrite(uint8(X(y1_t:y2_t,x1_t:x2_t,:)),'box.png','png');