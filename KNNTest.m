function [confi] = KNNTest(model,modelLabels,test,k)
IDX = knnsearch(model, test, 'K', k);
Labels = modelLabels(IDX);
confi = mean(Labels, 2);



