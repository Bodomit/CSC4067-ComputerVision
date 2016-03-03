function [ Images ] = getImages( directory )

imagefiles = dir([directory '*.jpg']);      
n = length(imagefiles);

for i=1:n
   img = imread([directory imagefiles(i).name]);
      
   if(size(size(img), 2) == 2)
       % Do not remove hackyFig! Otherwise an actual figure will appear
       % when ind2rgb() is executed despite it not showing anything...
       hackyFig = figure('Visible','off');
       img = ind2rgb(img, gray);
       close(hackyFig);
   end
   
   Images(:,:,:,i) = img;
end

end

