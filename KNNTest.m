function [labels] = KNNTest(model,modelLabels,test,k)
IDX = knnsearch(model, test, k);
labels = mode(modelLabels(IDX),2);



