function [x,y, confi]=slidingWindowOneScale( x, y, Image, w, h, featureExtractionFunc, validationFunc)

% Preallocate the matrix.
Windows = uint8(zeros(160, 96, size(x,1)));

% Preform the validation function at every point.
for i=1:size(x, 1)
    % Get the window.
    Window = Image(y(i):y(i)+h - 1, x(i):x(i)+w - 1);
    
    % Resize to be the same size as the training images, and store.
    Windows(:,:,i) = imresize(Window, [160, 96]);
end

% Get the confidence from the validation function.
Features = featureExtractionFunc(Windows);
confi = validationFunc(Features);


