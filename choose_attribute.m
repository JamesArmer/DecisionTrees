function best = choose_attribute(examples, targets)

% OUTPUT: best = [best_attribute, best_threshold], threshold = split determiner
% INPUT : examples = Nx98(-) array, 98(-) features with N values each
% INPUT : targets = Nx1 array, N resulting labels (only one AU) either 1 or 0

%number of attributes (columns) in examples
s = size(examples, 2);

% initialise
gain = zeros(s,0);
split = zeros(s,0);

for i = 1:s % for every attribute
    % column = set of values for single attribute
    column = examples(:,i);
    % best_split = the split with the best information gain
    best_split = choose_split(column,targets);
    % split = best threshold returned by choose_split
    split(i) = best_split(1);
    % gain = gain associated with threshold returned by choose_split
    gain(i) = best_split(2);
end

% best = pair of best attribute and its threshold value
% b = best gain value (unused), i = index
% split[i] = threshold value
[b, i] = max(gain);
best = [i, split(i)];

