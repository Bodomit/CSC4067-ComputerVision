function [confidence]= SVMTesting(model,features)

[pred, score]= predict(model, features);

confidence = score(:, 2);

end