%% Run the main function and get back the Type 1 / 2 errors.
FEOptions = {'hog'};
COptions = {'svm'};

[ TP, TN, FP, FN ] = main( FEOptions, COptions);
N = TP + TN + FP + FN;

accuracy = (TN + TP) / N;
errorRate = (FN + FP) / N;
recall = TP / (TP +FN);
precision = TP / (TP+FP);
specificity = TN / (TN+FP);
f1 = 2*TP / (2*TP + FN + FP);
fAR = FP / (FP+TN);