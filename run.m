% Get the name and dir of the results file.
resultsFolder = strrep(datestr(datetime), ' ', '_');
resultsFolder = strrep(resultsFolder, ':', '-');
resultsFolder = ['results\' resultsFolder '\'];
mkdir(resultsFolder);

% Configure the options.
FEOptions = {'hog'};
COptions = {'svm'};
save([resultsFolder 'Options.mat'], 'FEOptions', 'COptions');

% Run the full training / testing.
[ tPos, tNeg, fPos, fNeg ] = main( FEOptions, COptions, resultsFolder);

% Sum the resulting vectors.
TP = sum(tPos);
TN = sum(tNeg);
FP = sum(fPos);
FN = sum(fNeg);

N = TP + TN + FP + FN;

accuracy = (TN + TP) / N;
errorRate = (FN + FP) / N;
recall = TP / (TP +FN);
precision = TP / (TP+FP);
specificity = TN / (TN+FP);
f1 = 2*TP / (2*TP + FN + FP);
falseAlarmRate = FP / (FP+TN);

save([resultsFolder 'Metrics.mat'], ...
    'tPos', 'tNeg', 'fPos', 'fNeg', ...
    'TP', 'TN', 'FP', 'FN', 'N', ...
    'accuracy', 'errorRate', ...
    'recall', 'precision', ...
    'specificity', 'f1', ...
    'falseAlarmRate');