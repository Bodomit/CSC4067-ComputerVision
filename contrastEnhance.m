function [ Image ] = contrastEnhance( Image )

Image = histeq(Image);

end

