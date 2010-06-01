function [ back ] = background( filename )
%Reads avi file and performs background subtraction

mov = read_avi(filename);
back= median(mov,3);
back=uint8(back);

end

