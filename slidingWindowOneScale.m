function [x,y, confi]=slidingWindowOneScale( x, y, Scale, Image, w,h, validationFunc)

% Preallocate the matrix.
confi = zeros(size(x,1), 1);

% Preform the validation function at every point.
for i=1:size(confi)
    % Get the window.
    Window = Image(y(i):y(i)+h - 1, x(i):x(i)+w - 1, :);
    
    % Resize to be the same size as the training images.
    Window = imresize(Window, 1 / Scale);
    
    % Get the confidence from the validation function.
    confi(i) = validationFunc(Window);
end


