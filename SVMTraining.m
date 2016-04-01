function [model, loss] = SVMTraining(features, labels)

%SVM software requires labels -1 or 1 for the binary problem
labels(labels==0)=-1;

% Calculate the support vectors
model = fitcsvm(features, labels,'KernelFunction','linear','ClassNames',[-1,1], 'Standardize', true,'BoxConstraint', 0.1);

% Wrap so posterior probablities are returned in score.
model = fitSVMPosterior(model);

% Cross validate the model.
disp('Cross validation.');
cvModel = crossval(model);
loss = kfoldLoss(cvModel);