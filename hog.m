function [features] = hog(Images)

features = zeros(size(Images,3), 7524);

for i=1:size(Images, 3)
    features(i,:) =  extractHOGFeatures(Images(:,:,i));
end
     