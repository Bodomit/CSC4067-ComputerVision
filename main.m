function [ tPos tNeg fPos fNeg ] = main( FEOptions, COptions)
% Call like "main({'raw'}, {'kNN'});" in the cmd window... Don't ask about
% the syntax.

%% Setup

% Get the name and dir of the results file.
resultsFolder = strrep(datestr(datetime), ' ', '_');
resultsFolder = strrep(resultsFolder, ':', '-');
resultsFolder = ['results\' resultsFolder '\'];
mkdir(resultsFolder);

% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('inputs\images\');

%% Training

% Perform feature extraction.
feMethod = FEOptions(1);
switch feMethod{:}
    case 'raw'
        Features = rawpixel(TrainingImages);
        featureFunc = @(X) rawpixel(X);
end

% Train the model.
classifierMethod = COptions(1);
switch classifierMethod{:}
    case 'kNN'
        Model = Features;
        validationFunc = @(X) KNNTest(Model, TrainingLabels, featureFunc(X), 3);
end

disp(validationFunc);

%% Testing
% Get the test set consisting of images of a street.
TestImages = getImages('inputs\pedestrian\');

% Loop through each test image, performing a sliding window and return all
% objects with a confidence metric.
for i=1:size(TestImages,4)
    Objects = slidingWindow(TestImages(:,:,:,i), validationFunc);
end
end

