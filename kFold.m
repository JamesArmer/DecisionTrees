%function to run KFold on the decision tree
function [forest, stats, confusionArray] = kFold(dataSize, class, treeDepth, folds)

[features, labels] = loadInput(dataSize,class);
disp("Loaded Input.");

foldSize = (size(features,1))/folds;
forest = [];
accuracyArray = [];
confusionArray = [];
recallArray = [];
precisionArray = [];
f1ScoreArray = [];

for i = 1:folds
    disp("Fold " + i);
    testFeatures = features(((foldSize*(i-1))+1):(foldSize*i),:);
    testLabels = labels(((foldSize*(i-1))+1):(foldSize*i));
    
    if i == 1
        trainFeatures = features(((foldSize*i)+1:foldSize*folds),:);
        trainLabels = labels((foldSize*i)+1:foldSize*folds);
    elseif i == folds
        trainFeatures = features(1:foldSize*(i-1),:);
        trainLabels = labels(1:foldSize*(i-1));
    else
        %disp(size(features((1:foldSize*(i-1)),:)));
        %disp(size(features(((foldSize*i)+1:foldSize*folds),:)));
        trainFeatures = [features((1:foldSize*(i-1)),:);features(((foldSize*i)+1:foldSize*folds),:)];
        trainLabels = cat(1, labels(1:foldSize*(i-1)), labels((foldSize*i)+1:foldSize*folds));    
    end
    
    disp("Creating Tree...");
    tree = createTreeKFold(treeDepth,trainFeatures,trainLabels);
    disp("Testing Tree...");
    [accuracy, confusionMatrix] = testTree(tree,testFeatures,testLabels);
    tp = confusionMatrix(2,2);
    fp = confusionMatrix(1,2);
    fn = confusionMatrix(2,1);
    precision = tp/(tp+fp);
    recall = tp/(tp+fn);
    f1Score = 2*((precision*recall)/(precision+recall));
    
    forest = [forest tree];
    accuracyArray = [accuracyArray accuracy];
    confusionArray = [confusionArray  confusionMatrix];
    precisionArray = [precisionArray  precision];
    recallArray = [recallArray  recall];
    f1ScoreArray = [f1ScoreArray  f1Score];
    
    disp("Accuracy: " + accuracy);
    disp("Precision: " + precision);
    disp("Recall: " + recall);
    disp("F1Score :" + f1Score);
    disp("Confusion Matrix: ");
    disp(confusionMatrix);
end

disp("Average accuracy: " + ((sum(accuracyArray)/folds)*100) + "%");
stats = [accuracyArray ; precisionArray ; recallArray ; f1ScoreArray];

end
