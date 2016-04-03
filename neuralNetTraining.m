function [Model] = neuralNetTraining( TrainingFeatures, Labels, verbose )

TrainingFeatures = TrainingFeatures.';
Labels = Labels.';

% Create a sparse label matrix.
sparseLabels = zeros(2, size(Labels, 2));
sparseLabels(1,:) = Labels ~= 1;
sparseLabels(2,:) = Labels == 1;

% Train the first autoencoder using the images.
auto1 = trainAutoencoder(TrainingFeatures,100, ...
    'MaxEpochs', 100, ...
    'L2WeightRegularization',0.01, ...
    'ScaleData', true, ...
    'ShowProgressWindow', verbose);

features = encode(auto1,TrainingFeatures);

% Train a softnet that classifies the feature vector from the 2nd
% autoencoder, to either Not Pedestrian or Pedestrian.
softnet = trainSoftmaxLayer(features, sparseLabels,'ShowProgressWindow', verbose, 'MaxEpochs', 100);

% Stack them to form a deep net, which is our model.
Model = stack(auto1, softnet);
[Model, tr] = train(Model, TrainingFeatures, sparseLabels);

view(Model);

end

