function [feats1, feats2, labels1, labels2] = partitionData(features,labels,attribute,thresh)

    %Create an array of threshold values
    threshArray(1:size(features,1)) = thresh;

    %Data below thresh
    feats1 = features(features(:,attribute)' < threshArray);
    labels1 = labels(features(:,attribute)' < threshArray);
    
    %Data above thresh
    feats2 = features(features(:,attribute)' >= threshArray);
    labels2 = labels(features(:,attribute)' >= threshArray);

end

