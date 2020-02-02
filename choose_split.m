function best = choose_split(set, targets)

% OUTPUT: best = [best_threshold, gain]
% INPUT : set = Nx1 array, N values for a single attribute
% INPUT : targets = Nx1 array, N labels corresponding to attribute values

% s = number of value,label pairs
s = size(set,1);

% initialise
remainder = zeros(s,0);
gain = zeros(s,0);

% number of positve results from input set
% number of negative results from input set
% info = entropy of parent node
p = sum(targets(:) == 1);
n = sum(targets(:) == 0);
info = (-(p/(p+n))*log2(p/(p+n))) - ((n/(p+n))*log2(n/(p+n)));

for i = 1:s % for every value
    % p1 = number of positive results if < value
    % n1 = number of negative results if < value
    % p2 = number of positive results if >= value
    % n2 = number if negative results if >= value
    p1 = 0;
    n1 = 0;
    p2 = 0;
    n2 = 0;

    for j = 1:s
        if set(j) < set(i)
            if targets(j) == 1
                p1 = p1 + 1;
            else
                n1 = n1 + 1;
            end
        else
            if targets(j) == 1
                p2 = p2 + 1;
            else
                n2 = n2 + 1;
            end
        end
    end
    

    % info = entropy of child nodes
    if((p1 == 0 || n1 == 0))
        info1 = 0;
    else
        info1 = -(p1/(p1+n1)) * log2(p1/(p1+n1)) - (n1/(p1+n1)) * log2(n1/(p1+n1));
    end
    if((p2 == 0 || n2 == 0))
        info2 = 0;
    else
        info2 = -(p2/(p2+n2)) * log2(p2/(p2+n2)) - (n2/(p2+n2)) * log2(n2/(p2+n2));
    end

    % remainder = remaining information after split
    % gain = entropy of parent node - remainder
    remainder(i) = (((p1+n1)/(p+n)) * info1) + (((p2+n2)/(p+n)) * info2);
    gain(i) = info - remainder(i);
end

% best = pair of best threshold and its information gain
% b = best information gain, i = index
[b, i] = max(gain);
best = [set(i), b];