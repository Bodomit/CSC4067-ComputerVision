function [ Images ] = getImages( directory )

imagefiles = dir([directory '*.jpg']);      
n = length(imagefiles);

for i=1:n
   disp(imagefiles(i).name);
   img = imread([directory imagefiles(i).name]);
   
   if(size(size(img)) == 2)
       img = reshape(img, [size(img) 1]);
   end
   
   Images(:,:,:,i) = img;
end

end

