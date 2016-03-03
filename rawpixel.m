function [ Features ] = rawpixel( Images )

%Preallocate.
n = size(Images,4);
m = size(Images);
m = prod(m(1:3));
Features = zeros(n, m);

%Puts all pixels of an image into a vector
for i=1:size(Images, 4);
    Img = Images(:,:,:,i);
    Features(i,:) = Img(:);
end

