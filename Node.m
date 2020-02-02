classdef Node
    %Node class
    
    properties
        op
        kids
        class
        attribute
        threshold
        layer
    end
    
    methods
        
        %Constructor
        function obj = Node(id,layers,attr,thresh)
           obj.op = id;
           obj.class = -1;
           obj.attribute = attr;
           obj.threshold = thresh;
           obj.layer = layers;
           
           %Recursively create child nodes
           if layers > 0
               obj.kids = [Node(2*id,layers-1,attr,thresh), Node(2*id+1,layers-1,attr,thresh)];
           else
               obj.kids = [];
           end
           
        end
        
        function obj = pruneTree(obj)
            
            %If left is not a leaf
            if ~obj.kids(1).isLeaf()
                %Prune Left Branch
                obj.kids(1) = obj.kids(1).pruneTree();
            end
            
            %If right is not a leaf
            if ~obj.kids(2).isLeaf()
                %Prune Right Branch
                obj.kids(2) = obj.kids(2).pruneTree();
            end
            
            %If both are now leaves
            if obj.kids(1).isLeaf() && obj.kids(2).isLeaf()
                
                %If one of the child nodes has -1, remove the branch and
                %assume the other branch
                if obj.kids(1).class == -1
                    %Remove child 1 and this node
                    obj = obj.kids(2);
                elseif obj.kids(2).class == -1
                    %Remove child 2 and this node
                    obj = obj.kids(1);

                %If both have the same class
                elseif obj.kids(1).class == obj.kids(2).class
                    
                    %Debugging
                    %disp("Class ");
                    %disp(obj.class);
                    %disp("->");
                    %disp(obj.kids(1).class);
                    
                    %Make this to a classifying node
                    obj.class = obj.kids(1).class;
                    
                    %Prune child nodes
                    obj.kids = [];
                end
            end
        end
        
        function isleaf = isLeaf(obj)
            if size(obj.kids) == 0
                isleaf = true;
            else
                isleaf = false;
            end
        end
        
        function drawTree(obj, x,y)
            hold on;
            set(gca,'Color','w');
            
           %Draw node at x,y
           
           if size(obj.kids) > 0
               string = "  attr" + obj.attribute + " >= " + obj.threshold;
           else
               string = "  " + obj.class;
           end
           text(x,y,string,'Color','b');
           

           
           if size(obj.kids) > 0
               %Calculate child node positions
               child_L = [x-((2^obj.layer)/100),y-obj.layer/100];
               child_R = [x+((2^obj.layer)/100),y-obj.layer/100];

               %Draw lines to child nodes
               l = line([x,child_L(1)],[y,child_L(2)]);
               l.Color = 'red';
               l = line([x,child_R(1)],[y,child_R(2)]);
               l.Color = 'green';
               
               %Draw child nodes (recursive)
               obj.kids(1).drawTree(child_L(1),child_L(2));
               obj.kids(2).drawTree(child_R(1),child_R(2));
           else
               if obj.class == true
                   plot(x,y,'m.','MarkerSize',20);
               else
                   plot (x,y,'c.','MarkerSize',20);
               end
           end
           
        end
        
        function obj = trainNode(obj, features, labels)
            % If not a leaf node, split the data
            if size(obj.kids) > 0
                % Find attribute to test and threshold to split at
                best = choose_attribute(features,labels);
                obj.attribute = best(1);
                obj.threshold = best(2);
                % Split the features and labels at given threshold of given attribute
                [f1,f2,l1,l2] = divideData(features,labels,obj.attribute,obj.threshold);
                % Recursive train the child nodes with a different split each
                if (size(f1) == 0) | (size(f2) == 0)
                    obj.kids = [];
                else
                    obj.kids(1) = obj.kids(1).trainNode(f1,l1);
                    obj.kids(2) = obj.kids(2).trainNode(f2,l2);
                end
                
            else
                % If a leaf node, assign a class by majority vote
                if size(labels(labels == 1),1) > size(labels(labels == 0),1)
                    obj.class = 1;
                else
                    obj.class = 0;
                end
            end
        end
       
        function class = predict(obj, feature)
            if size(obj.kids) > 0
                if feature(obj.attribute) >= obj.threshold
                    class = obj.kids(2).predict(feature);
                else
                    class = obj.kids(1).predict(feature);
                end
            else
                class = obj.class;
            end
            
        end
        
       
    end
end

