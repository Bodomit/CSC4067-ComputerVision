function [ tPos, tNeg, fPos, fNeg ] = main( FEOptions, COptions)
% Call like "main({'raw'}, {'kNN'});" in the cmd window... Don't ask about
% the syntax.

%% Setup

% Get the name and dir of the results file.
resultsFolder = strrep(datestr(datetime), ' ', '_');
resultsFolder = strrep(resultsFolder, ':', '-');
resultsFolder = ['results\' resultsFolder '\'];
mkdir(resultsFolder);

% Get the matrix of correct objects from the dataset.
dataString = fileread('inputs\test.dataset');
TestAnswers = parseTestAnswers(dataString);

% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('inputs\images\');

% Preprocess the training images.
TrainingImages = preProcess(TrainingImages);

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
ProcessedTestImages = preProcess(TestImages);

% Preallocate arrays.
tPos = zeros(size(TestImages,4),1);
tNeg = zeros(size(TestImages,4),1);
fPos = zeros(size(TestImages,4),1);
fNeg = zeros(size(TestImages,4),1);

% Loop through each test image, performing a sliding window and return all
% objects with a confidence metric.
for i=1:size(TestImages,4)
    % Find objects.
    [Objects, windowCount] = slidingWindow(ProcessedTestImages(:,:,:,i), featureExtractionFunc, validationFunc);
    Objects = suppressNonMaxima(Objects, 100);
    Objects = centerOrigin(Objects);
    
    [ tPos(i), tNeg(i), fPos(i), fNeg(i) ] = calculateBaseMetrics(Objects, TestAnswers{i}, windowCount, 10);
    
    % Get the correct answers and add to the list of objects for display.
    answers = cell2mat(TestAnswers{i}.');
    answers = [answers ones(size(answers,1), 1)*-1];
    Objects = [Objects; answers];
    
    ShowDetectionResult(TestImages(:,:,:,i), Objects, ['b';'c';'m';'y';'g']);
end
end

