function automatedTest(trainSize, testSize, featureID, treeDepth)
    
    featureID = 1;
    
    %Load features and labels
    [features, labels] = loadInput(trainSize+testSize,featureID);
    
    %Create tree and train
    tree = createTree(features(1:trainSize,:),labels(1:trainSize),treeDepth);
    
    %Prune tree
    tree = tree.pruneTree();
    
    %Draw tree
    tree.drawTree(0,0);
    
    %Validate tree
    %testTree(tree,features(trainSize+1:end,:),labels(trainSize+1:end));
 
end
