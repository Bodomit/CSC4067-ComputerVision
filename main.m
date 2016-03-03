function [ tPos tNeg fPos fNeg ] = main( FEOptions, COptions, trainingDir, testingDir )

%% Training
% Get all the training images.

disp('Loading Training Images - Positive');
trainingImagesPos = getImages('inputs\images\pos\');

disp('Loading Training Images - Negative');
trainingImagesNeg = getImages('inputs\images\neg\');



end

