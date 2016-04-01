function model = SVMTraining(features, labels, resultsFolder)

%SVM software requires labels -1 or 1 for the binary problem
labels(labels==0)=-1;

% Calculate the support vectors
model = fitcsvm(features, labels,'KernelFunction','rbf','ClassNames',{-1,1}, 'Standardize', true,'BoxConstraint', Inf);

% Wrap so posterior probablities are returned in score.
model = fitSVMPosterior(model);

% Cross validate the model.
cvModel = crossval(model);
[cvLabels, cvScore, cvCost] = kfoldPredict(cvModel);

save([resultsFolder 'SVM.mat'], 'cvLabels', 'cvScore', 'cvCost');