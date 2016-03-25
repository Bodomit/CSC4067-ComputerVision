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
        TrainingFeatures = rawpixel(TrainingImages);
        featureExtractionFunc = @(X) rawpixel(X);
    case 'hog'
        TrainingFeatures = hog(TrainingImages);
        featureExtractionFunc = @(X) hog(X);
end

% Train the model.
classifierMethod = COptions(1);
switch classifierMethod{:}
    
    case 'kNN'
        %Parse the k from the input if available.
        if(size(COptions, 2) > 1)
            k = COptions(2);
            k = k{:};
        else
            k = 3;
        end
        
        Model = TrainingFeatures;
        validationFunc = @(X) KNNTest(Model, TrainingLabels, X, k);
    
    case 'svm'
        Model = SVMTraining(TrainingFeatures, TrainingLabels);
        validationFunc = @(X) SVMTesting(Model, X);
end

%% Testing
% Get the test set consisting of images of a street.
TestImages = getImages('inputs\pedestrian\');

% Loop through each test image, performing a sliding window and return all
% objects with a confidence metric.
for i=1:size(TestImages,4)
    Objects = slidingWindow(TestImages(:,:,:,i), featureExtractionFunc, validationFunc);
    ShowDetectionResult(TestImages(:,:,:,i), Objects);
end
end

