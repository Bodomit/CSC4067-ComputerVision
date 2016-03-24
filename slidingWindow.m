function [ Objects ] = slidingWindow(Image, validationFunc)

% The default Options
defaultoptions=struct('ScaleUpdate',1/1.2,'Resize',true,'Verbose',true);

% Process input options
if(~exist('Options','var'))
    Options=defaultoptions;
else
    tags = fieldnames(defaultoptions);
    for i=1:length(tags)
        if(~isfield(Options,tags{i})), Options.(tags{i})=defaultoptions.(tags{i}); end
    end
    if(length(tags)~=length(fieldnames(Options)))
        warning('image_registration:unknownoption','unknown options found');
    end
end

% Set the window scale (the same as the training images).
WindowRatioWidth = 96;
WindowRatioHeight = 160;

% Calculate the coarsest image scale
ScaleWidth = size(Image, 2)/WindowRatioWidth;
ScaleHeight = size(Image, 1)/WindowRatioHeight;
if(ScaleHeight < ScaleWidth ), 
    StartScale =  ScaleHeight; 
else
    StartScale = ScaleWidth;
end

% Array to store [x y width height confidence] of Objects detected
Objects=zeros(100,5); n=0; 

% Calculate maximum of search scale itterations
itt=ceil(log(1/StartScale)/log(Options.ScaleUpdate));

% Do the Objection detection, looping through all image scales
for i=1:itt
    % Current scale
    Scale =StartScale*Options.ScaleUpdate^(i-1);    
    
    % Display the current scale and number of objects detected
    if(Options.Verbose)
        disp(['Scale : ' num2str(Scale) ' objects detected : ' num2str(n) ])
    end
    
    % Window size scales, with decreasing search-scale
    % (instead of cpu-intensive scaling of the image and calculation 
    % of new integral images)
    w = floor(WindowRatioWidth*Scale);
    h = floor(WindowRatioHeight*Scale);

    % Spacing between search coordinates of the image.
    stepH = w;
    stepV = h;
    
    % Make vectors with all search image coordinates used for the current scale
    [x,y]=ndgrid(1:stepH:(size(Image, 2)-w),1:stepV:(size(Image, 1)-h)); 
    x=x(:); 
    y=y(:);
    
    % If no coordinates due to large step size, continue to next scale
    if(isempty(x)), continue; end
    
    % Check each window and get a confidence value.
    [x,y, confi] = slidingWindowOneScale( x, y, Scale, Image, w,h, validationFunc);
    
    % Filter out any window less than 50% confidence (as it's a validation
    % / binary problem).
    ids = confi>0.5;
    x = x(ids);
    y = y(ids);
    confi = confi(ids);
    
    % If search coordinates still exist, they contain an Object
    for k=1:length(x)
        n=n+1; 
        Objects(n,:)=[x(k) y(k) w h confi(k)];
    end
end

% Crop the initial array with Objects detected
Objects=Objects(1:n,:);

end

