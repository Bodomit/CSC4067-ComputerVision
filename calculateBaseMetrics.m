function [ tPos, tNeg, fPos, fNeg ] = calculateBaseMetrics(Objects, TestAnswers, windowCount, marginPercent)

TestAnswers = cell2mat(TestAnswers.');

% Set the True positive counter.
tPos = 0;

% Calculate true positives. everythign else can then be derived.
for i=1:1:size(Objects,1)
        hMargin = Objects(i,3) * marginPercent / 100;
        vMargin = Objects(i,4) * marginPercent / 100;
        
        O = repmat(Objects, size(TestAnswers, 1), 1);
        
        withinVMargin = TestAnswers(:,1)-vMargin < O & O < TestAnswers(:,1)+vMargin;
        withinHMargin = TestAnswers(:,2)-hMargin < O & O < TestAnswers(:,2)+hMargin;
        
        matchFound = withinVMargin & withinHMargin;
        tPos = tPos + sum(matchFound);
end

% Calculate the false positives.
fPos = size(Objects, 1) - tPos;

% Calculate the false negatives.
fNeg = size(TestAnswers, 1) - tPos;

% Calculate the true negatives.
tNeg = windowCount - tPos - fPos - fNeg;

end

