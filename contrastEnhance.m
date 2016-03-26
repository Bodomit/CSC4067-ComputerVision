function [ Image ] = contrastEnhance( Image )
% this code is a modified version of the code available at http://uk.mathworks.com/help/images/examples/contrast-enhancement-techniques.html

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

Image_lab = applycform(Image, srgb2lab); % convert to L*a*b*

L = Image_lab(:,:,1);

% replace the luminosity layer with the processed data and then convert
% the image back to the RGB colorspace
Image_enhanced = Image_lab;
Image_enhanced(:,:,1) = adapthisteq(L);
Image = applycform(Image_enhanced, lab2srgb);

end

