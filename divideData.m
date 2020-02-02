function [features1,features2,labels1,labels2] = divideData(features, labels, attr, threshold)

    % make blank matricies
    features1 = [];
    features2 = [];
    labels1 = [];
    labels2 = [];

    % for each face in features
    for i = 1:size(features,1)

        % if the given attribute's value does not meet threshold
        if features(i,attr) < threshold

            % add to set 1
            features1 = [features1; features(i,:)];
            labels1 = [labels1; labels(i,:)];
        else
            
            % otherwise add to set 2
            features2 = [features2; features(i,:)];
            labels2 = [labels2; labels(i,:)];
        end
    end    
end

