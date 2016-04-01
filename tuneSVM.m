%SVM software requires labels -1 or 1 for the binary problem
TrainingLabels(TrainingLabels==0)=-1;

% Calculate the support vectors
Model = fitcsvm(TrainingFeatures, TrainingLabels,'KernelFunction','rbf','ClassNames',[-1,1], 'Standardize', true,'BoxConstraint', Inf);

% Wrap so posterior probablities are returned in score.
Model = fitSVMPosterior(Model);

% Cross validate the model.
cvModel = crossval(Model);
[cvLabels, cvScore, cvCost] = kfoldPredict(cvModel);
cvLoss = kfoldLoss(cvModel);