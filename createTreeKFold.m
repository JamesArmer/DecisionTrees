function tree = createTreeKFold(treeDepth,features,labels)
%function to be used in the kFold script
%   Takes the features and labels for a certain fold
    tree = Node(1, treeDepth, -1, -1);
    tree = tree.trainNode(features,labels);
    tree.drawTree(0,0);
end