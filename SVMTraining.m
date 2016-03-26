function model = SVMTraining(features, labels)

%SVM software requires labels -1 or 1 for the binary problem
labels(labels==0)=-1;

% Calculate the support vectors
model = fitcsvm(features, labels,'KernelScale', 'auto', 'KernelFunction','linear','ClassNames',[-1,1]);

% Wrap so posterior probablities are returned in score.
model = fitPosterior(model, features, labels);