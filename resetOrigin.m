function [ Objects ] = resetOrigin( Objects )

x = Objects(:,1);
y = Objects(:,2);
w = Objects(:,3);
h = Objects(:,4);
c = Objects(:,5);

Objects = [x-w/2 y-h/2 w h c];

end

