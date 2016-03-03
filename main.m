function [ tPos tNeg fPos fNeg ] = main( FEOptions, COptions, trainingDir, testingDir )
%% Setup

% Get the name and dir of the log file.
logFile = strrep(datetime, ' ', '_');
logFile = ['logs\' logFile];


% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('inputs\images\');

%% Training

% Perform feature extraction.
switch FEOptions(1)
    case 'raw'
        Features = rawpixel(TrainingImages);
end

% Train the model.
switch COptions(1)
    case 'kNN'
        Model = Features;
end

%% Testing


end

