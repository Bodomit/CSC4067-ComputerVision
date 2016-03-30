function model = SVMTraining(features, labels)

rng('default');

%SVM software requires labels -1 or 1 for the binary problem
labels(labels==0)=-1;

% Calculate the support vectors
model = fitcsvm(features, labels,'KernelScale', 'auto', 'KernelFunction','rbf','ClassNames',[-1,1], 'CrossVal', 'on', 'Standardize', true,'BoxConstraint', Inf);

% Wrap so posterior probablities are returned in score.
model = fitSVMPosterior(model);
