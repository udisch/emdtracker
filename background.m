function [ back ] = background( filename )
%Reads avi file and gets background

mov = read_avi(filename);
back= median(mov,3);
back=uint8(back);

end

