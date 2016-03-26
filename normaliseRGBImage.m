function [ Image ] = normaliseRGBImage( Image )
% Modified version of http://uk.mathworks.com/matlabcentral/newsreader/view_thread/171190

 Image = double(Image);
 %figure;imshow(uint8(Image_rgb));

 Image_red = Image(:,:,1);
 Image_green = Image(:,:,2);
 Image_blue = Image(:,:,3);
 %figure;imshow(uint8(Image_red));

 [row,col] = size(Image(:,:,1));

 for y = 1:row %-->numberof rows in image
    for x = 1:col %-->number of columns in the image
       Red = Image_red(y,x);
       Green = Image_green(y,x);
       Blue = Image_blue(y,x);

     NormalizedRed = Red/sqrt(Red^2 + Green^2 + Blue^2);
     NormalizedGreen = Green/sqrt(Red^2 + Green^2 + Blue^2);
     NormalizedBlue = Blue/sqrt(Red^2 + Green^2 + Blue^2);

     Image_red(y,x) = NormalizedRed;
     Image_green(y,x) = NormalizedGreen;
     Image_blue(y,x) = NormalizedBlue;
    end
 end

 Image(:,:,1) = Image_red;
 Image(:,:,2) = Image_green;
 Image(:,:,3) = Image_blue;

 Image = Image .* Image;
 Image = Image .* Image;

end

