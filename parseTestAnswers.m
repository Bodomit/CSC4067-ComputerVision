function [ TestAnswers ] = parseTestAnswers( dataString )

lines = strsplit(dataString, '\n');

% get the number of test images.
n = str2num(cell2mat(lines(2)));
TestAnswers = cell(n,1);

for i=1:n
    testImageLine = lines{i+2};
    testImageRectangleString = strsplit(testImageLine, ' 0 ');
    
    % Get the first section and get the image name and how many rectangles
    % this test image has.
    testImageRectangle = strsplit(testImageRectangleString{1}, ' ');
    
    % Get the number of rectangles in this image.
    m = str2double(testImageRectangle{2});
    
    if(m == 0)
        continue;
    end
   
    v = cell(1, m);
    v(1) = {cellfun(@str2num,testImageRectangle(3:end))};
    
    for j=2:1:m
        testImageRectangle = strsplit(testImageRectangleString{j}, ' ');
        v(j) = {cellfun(@str2num, testImageRectangle(2:end))};
    end
    
    TestAnswers(i) = {v};
end

end

