function [ confidence ] = neuralNetTest( Model, Tests )

Tests = Tests.';

confidence = Model(Tests);
confidence = confidence(2,:).';

end

