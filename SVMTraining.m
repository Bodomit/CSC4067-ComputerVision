function model = SVMTraining(features, labels)

%SVM software requires labels -1 or 1 for the binary problem
labels(labels==0)=-1;

%Initilaise and setup SVM parameters
C = Inf;
sigmaKernel=10;
kernel='rbf';

% Calculate the support vectors
model = fitcsvm(features, labels, 'KernelFunction', kernel, 'KernelScale', sigmaKernel, 'BoxConstraint', C);

% create a structure encapsulating all teh variables composing the model
model.xsup = model.SupportVectors;

model.param.sigmakernel=sigmakernel;
model.param.kernel=kernel;