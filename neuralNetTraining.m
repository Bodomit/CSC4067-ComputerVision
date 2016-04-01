function [Model, Loss] = neuralNetTraining( TrainingFeatures, Labels )

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
    'ScaleData', true);

features = encode(auto1,TrainingFeatures);

% Train a softnet that classifies the feature vector from the 2nd
% autoencoder, to either Not Pedestrian or Pedestrian.
softnet = trainSoftmaxLayer(features, sparseLabels);

% Stack them to form a deep net, which is our model.
Model = stack(auto1, softnet);
[Model, tr] = train(Model, TrainingFeatures, sparseLabels);

view(Model);

Loss = cell2mat(tr.best_perf);

end

