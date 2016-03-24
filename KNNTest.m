function [confi] = KNNTest(model,modelLabels,test,k)
IDX = knnsearch(model, test, 'K', k);
Labels = mode(modelLabels(IDX),2);
confi = mean(Labels);



