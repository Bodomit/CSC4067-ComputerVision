function [ Model ] = neuralNetTraining( TrainingFeatures, Labels )

rng('default');

TrainingFeatures = TrainingFeatures.';
Labels = Labels.';

% Create a sparse label matrix.
sparseLabels = zeros(2, size(Labels, 2));
sparseLabels(1,:) = Labels ~= 1;
sparseLabels(2,:) = Labels == 1;

% Train the first autoencoder using the images.
auto1 = trainAutoencoder(TrainingFeatures,100, ...
    'MaxEpochs', 1000, ...
    'L2WeightRegularization',0.01, ...
    'EncoderTransferFunction','logsig',...
    'DecoderTransferFunction','logsig',...
    'SparsityProportion', 0.8, ...
    'ScaleData', true);

features = encode(auto1,TrainingFeatures);

% Train a softnet that classifies the feature vector from the 2nd
% autoencoder, to either Not Pedestrian or Pedestrian.
softnet = trainSoftmaxLayer(features, sparseLabels);

% Stack them to form a deep net, which is our model.
Model = stack(auto1, softnet);
view(Model);

end

