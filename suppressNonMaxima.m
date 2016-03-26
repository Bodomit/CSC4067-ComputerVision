function [ Objects ] = suppressNonMaxima( Objects, threshold)

removed = zeros(size(Objects, 1), 1);

for i=1:size(Objects, 1)
   if(removed(i))
       continue;
   end
   
   intersects = (rectint(Objects(i, 1:4), Objects(:, 1:4)) > threshold).';
   lessConfid = Objects(i, 5) > Objects(:, 5);
   
   toRemove = intersects & lessConfid;
   toRemove(i) = 0;
   
   removed = removed | toRemove;
end

Objects = Objects(~removed, :);

end

