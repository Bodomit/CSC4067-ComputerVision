function [ tPos, tNeg, fPos, fNeg ] = calculateBaseMetrics(Objects, TestAnswers, windowCount, marginPercent)

TestAnswers = cell2mat(TestAnswers.');

% Set the True positive counter.
tPos = 0;

% Calculate true positives. everythign else can then be derived.
for i=1:1:size(Objects,1)
        hMargin = Objects(i,3) * marginPercent / 100;
        vMargin = Objects(i,4) * marginPercent / 100;
        
        O = repmat(Objects(i,1:4), size(TestAnswers, 1), 1);
        
        withinVMargin = TestAnswers(:,2)-vMargin < O(:,2) & O(:,2) < TestAnswers(:,2)+vMargin;
        withinHMargin = TestAnswers(:,1)-hMargin < O(:,1) & O(:,1) < TestAnswers(:,1)+hMargin;
        
        matchFound = withinVMargin & withinHMargin;
        tPos = tPos + any(matchFound);
end

% Calculate the false positives.
fPos = size(Objects, 1) - tPos;

% Calculate the false negatives.
fNeg = size(TestAnswers, 1) - tPos;

% Calculate the true negatives.
tNeg = windowCount - tPos - fPos - fNeg;

end

