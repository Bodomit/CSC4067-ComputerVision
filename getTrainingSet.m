function [ Images,Labels ] = getTrainingSet( dir )

%Get the images and labels.
trainingImagesPos = getImages([dir 'pos\']);
trainingImageLabelsPos = ones(size(trainingImagesPos,4),1);

trainingImagesNeg = getImages([dir 'neg\']);
trainingImageLabelsNeg = zeros(size(trainingImagesNeg,4),1);

grayImagesPos = uint8(zeros(160,96,size(trainingImagesPos,4)));
for i=1:size(trainingImagesPos,4)
    grayImagesPos(:,:,i) = rgb2gray(trainingImagesPos(:,:,:,i));
end

grayImagesNeg = uint8(zeros(160,96,size(trainingImagesNeg,4)));
for i=1:size(trainingImagesNeg,4)
    grayImagesNeg(:,:,i) = rgb2gray(trainingImagesNeg(:,:,:,i));
end
    
% Concatenate both positive and negative examples.
Images = cat(3, grayImagesPos, grayImagesNeg);
Labels = cat(1, trainingImageLabelsPos, trainingImageLabelsNeg);

% Randomise the order.
permutation = randperm(size(Images,3));
Images = Images(:,:,permutation);
Labels = Labels(permutation);

end

