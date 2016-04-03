function [ tPos, tNeg, fPos, fNeg ] = main(FEOptions, COptions, crossVal, resultsFolder)
% Call like "main({'raw'}, {'kNN'});" in the cmd window... Don't ask about
% the syntax.

%% Setup
disp('Getting training images.');

% Get the matrix of correct objects from the dataset.
dataString = fileread('inputs\test.dataset');
TestAnswers = parseTestAnswers(dataString);
save([resultsFolder 'TestAnswers.mat'], 'TestAnswers');

% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('inputs\images\');

% Preprocess the training images.
disp('Processing images.');
ProcessedTrainingImages = preProcess(TrainingImages);

save([resultsFolder 'TrainingImages.mat'], 'TrainingImages', 'TrainingLabels', 'ProcessedTrainingImages');
Loss = 'N/A';

%% Training
disp('Training.');
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
    
    case 'knn'
        %Parse the k from the input if available.
        if(size(COptions, 2) > 1)
            k = COptions(2);
            k = k{:};
        else
            k = 3;
        end
        
        Model = TrainingFeatures;
        
        if(crossVal)
            disp('Cross validation.');
            cvModel = fitcknn(TrainingFeatures, TrainingLabels, 'CrossVal', 'on', 'NumNeighbors', k); 
            Loss = kfoldLoss(cvModel);
        end
             
        validationFunc = @(X) KNNTest(Model, TrainingLabels, X, k);
    
    case 'svm'
        Model = SVMTraining(TrainingFeatures, TrainingLabels);
        validationFunc = @(X) SVMTesting(Model, X);
        
        if(crossVal)
            disp('Cross validation.');
            cvModel = crossval(Model);
            Loss = kfoldLoss(cvModel);
        end
        
    case 'neural'
        Model = neuralNetTraining(TrainingFeatures, TrainingLabels, true);
        validationFunc = @(X) neuralNetTest(Model, X);
        
        if(crossVal)
            disp('Cross validation.');
            predFunc = @(XTRAIN,ytrain,XTEST) fullNet(XTRAIN,ytrain,XTEST);
            Loss = crossval('mse',TrainingFeatures,TrainingLabels,'Predfun', predFunc);
        end
end
disp(['Loss: ' num2str(Loss)]);

save([resultsFolder 'Model.mat'], 'Model', 'Loss');

%% Testing
% Get the test set consisting of images of a street.
TestImages = getImages('inputs\pedestrian\');
GreyTestImages = uint8(zeros(480, 640, size(TestImages, 4)));

for i=1:size(GreyTestImages, 3)
    GreyTestImages(:,:,i) = rgb2gray(TestImages(:,:,:,i));
end

ProcessedTestImages = preProcess(GreyTestImages);

save([resultsFolder 'TestImages.mat'], 'TestImages', 'ProcessedTestImages');

% Preallocate arrays.
tPos = zeros(size(ProcessedTestImages,3),1);
tNeg = zeros(size(ProcessedTestImages,3),1);
fPos = zeros(size(ProcessedTestImages,3),1);
fNeg = zeros(size(ProcessedTestImages,3),1);

% Loop through each test image, performing a sliding window and return all
% objects with a confidence metric.
for i=1:size(ProcessedTestImages,3)
    % Find objects.
    [Objects, windowCount] = slidingWindow(ProcessedTestImages(:,:,i), featureExtractionFunc, validationFunc);
    
    Objects = centerOrigin(Objects);
    Objects = suppressNonMaxima(Objects, 100);
    [ tPos(i), tNeg(i), fPos(i), fNeg(i) ] = calculateBaseMetrics(Objects, TestAnswers{i}, windowCount, 10);
    
    % Get the correct answers and add to the list of objects for display.
    answers = cell2mat(TestAnswers{i}.');
    answers = [answers ones(size(answers,1), 1)*-1];
    Objects = [answers; Objects];
    
    ShowDetectionResult(TestImages(:,:,:,i), Objects, ['g';'b'], num2str(i, '%05u'), resultsFolder);
end
end

