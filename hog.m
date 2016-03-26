function [features] = hog(Images)

features = zeros(size(Images,4), 7524);

for i=1:size(Images, 4)
    features(i,:) =  extractHOGFeatures(Images(:,:,:,i));
end
     