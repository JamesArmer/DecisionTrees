function [accuracy,confusionMatrix] = testTree(tree,features,labels)

    % For each feature
    for i = 1:size(features,1)
        % Make a predicition using the given tree
        pred(i) = tree.predict(features(i,:));
    end
    [accuracy, confusionMatrix] = confusionTree(pred',labels);
end

