function [ tPos, tNeg, fPos, fNeg ] = main(FEOptions, COptions, resultsFolder)
% Call like "main({'raw'}, {'kNN'});" in the cmd window... Don't ask about
% the syntax.

%% Setup
% Get the matrix of correct objects from the dataset.
dataString = fileread('inputs\test.dataset');
TestAnswers = parseTestAnswers(dataString);
save([resultsFolder 'TestAnswers.mat'], 'TestAnswers');

% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('inputs\images\');

% Preprocess the training images.
ProcessedTrainingImages = preProcess(TrainingImages);

save([resultsFolder 'TrainingImages.mat'], 'TrainingImages', 'TrainingLabels', 'ProcessedTrainingImages');


%% Training

% Perform feature extraction.
feMethod = FEOptions(1);
switch feMethod{:}
    case 'raw'
        TrainingFeatures = rawpixel(ProcessedTrainingImages);
        featureExtractionFunc0 = @(X) rawpixel(X);
    case 'hog'
        TrainingFeatures = hog(ProcessedTrainingImages);
        featureExtractionFunc0 = @(X) hog(X);
end

if(size(FEOptions, 2) > 1)
    param = FEOptions(2);
    switch param{:}
        case '-pca'
            [TrainingFeatures, eigenVectors] = pCA(TrainingFeatures);
            featureExtractionFunc = @(X) pCAReduce(eigenVectors, featureExtractionFunc0(X));
    end
else
    featureExtractionFunc = featureExtractionFunc0;
end

save([resultsFolder 'TrainingFeatures.mat'], 'TrainingFeatures');

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
        nmsThreshold = 500;
    
    case 'svm'
        Model = SVMTraining(TrainingFeatures, TrainingLabels);
        validationFunc = @(X) SVMTesting(Model, X);
        nmsThreshold = 100;
        
    case 'neural'
        Model = neuralNetTraining(TrainingFeatures, TrainingLabels);
        validationFunc = @(X) neuralNetTest(Model, X);
        nmsThreshold = 100;
end

save([resultsFolder 'Model.mat', 'nmsThreshold'], 'Model');

%% Testing
% Get the test set consisting of images of a street.
TestImages = getImages('inputs\pedestrian\');
ProcessedTestImages = preProcess(TestImages);
save([resultsFolder 'TestImages.mat'], 'TestImages', 'ProcessedTestImages');

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
    
    Objects = centerOrigin(Objects);
    Objects = suppressNonMaxima(Objects, nmsThreshold);
    [ tPos(i), tNeg(i), fPos(i), fNeg(i) ] = calculateBaseMetrics(Objects, TestAnswers{i}, windowCount, 10);
    
    % Get the correct answers and add to the list of objects for display.
    answers = cell2mat(TestAnswers{i}.');
    answers = [answers ones(size(answers,1), 1)*-1];
    Objects = [answers; Objects];
    
    ShowDetectionResult(TestImages(:,:,:,i), Objects, ['g';'b'], num2str(i, '%05u'), resultsFolder);
end
end

