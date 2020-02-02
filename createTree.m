function tree = createTree(features,labels,treeDepth)
% Creates a tree, trained on the given features and labels 
%   with a maximum depth of treeDepth, then draws it

    % Create the root node, recursively creates children
    tree = Node(1, treeDepth, -1, -1);
    
    % Recursively train the tree
    tree = tree.trainNode(features,labels);
    
    % Recursively draw the tree
    %tree.drawTree(0,0);
    
end

