function [ Objects ] = suppressNonMaxima( Objects, threshold)

removed = zeros(size(Objects, 1), 1);

for i=1:size(Objects, 1)
   if(removed(i))
       continue;
   end
   
   intersects = (rectint(Objects(i, 1:4), Objects(:, 1:4)) > threshold).' & ~removed;
   lessConfid = Objects(i, 5) > Objects(:, 5);
   
   toRemove = intersects & lessConfid;
   
   sameConfiIntersects = intersects & Objects(i, 5) == Objects(:, 5);
   
   if(any(sameConfiIntersects))
       % Get the average position.
       avgPos = mean(Objects(sameConfiIntersects,1:2), 1);
       
       % Get the distance from all objects to the point.
       distVectors = Objects(:, 1:2) - repmat(avgPos, size(sameConfiIntersects));
       distances = sum(distVectors .^ 2, 2);
       
      [~,I] =  sort(distances);
      
      D = I(sameConfiIntersects(I));
      
      toRemove(D(2:end)) = 1;     
   end
   
   removed = removed | toRemove;
end

Objects = Objects(~removed, :);

end

