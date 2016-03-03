function [ Images,Labels ] = getTrainingSet( dir )

%Get the images and labels.
trainingImagesPos = getImages([dir 'pos\']);
trainingImageLabelsPos = ones(size(trainingImagesPos,4),1);

trainingImagesNeg = getImages([dir 'neg\']);
trainingImageLabelsNeg = zeros(size(trainingImagesPos,4),1);

% Concatenate both positive and negative examples.
Images = cat(4, trainingImagesPos, trainingImagesNeg);
Labels = cat(1, trainingImageLabelsPos, trainingImageLabelsNeg);

% Randomise the order.
permutation = randperm(size(Images,4));
Images = Images(:,:,:,permutation);
Labels = Labels(permutation);

end

