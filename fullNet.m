function [ Responses ] = fullNet( Features, Labels, Test)

Responses = zeros(size(Test,1), 1);
Model = neuralNetTraining( Features, Labels, false);

for i=1:size(Test,1)
    Responses(i) = neuralNetTest(Model, Test(i,:));
end

