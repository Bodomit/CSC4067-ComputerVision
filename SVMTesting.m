function [confidence]= SVMTesting(features,model)

pred = predict(model, features);
if pred>0
    confidence = 1;
else
    confidence = 0;
end
   
end