%% Define the data

stockPrice = ["Up"; "Up"; "Up"; "Stable"; "Stable"; "Down"; "Down"; "Down"];
market = ["Down"; "Up"; "Stable"; "Up"; "Stable"; "Stable"; "Down"; "Stable"];
news = ["Impartial"; "Negative"; "Positive"; "Negative"; "Negative"; "Positive"; "Positive"; "Negative"];
decision = ["Buy"; "Buy"; "Buy"; "Buy"; "Buy"; "Buy"; "Sell"; "Sell"];

%% Combining the data we defined

dataTabe = table(stockPrice, market, news, decision);
 
%% Creation of a decision tree

tree1 = fitctree(dataTabe, 'decision');

%% Display Tree 2

disp('Decision Tree1:');
view(tree1, 'Mode','graph')
view(tree1,"Mode", 'text')

%% Define the target

target = dataTabe.decision;

%% Initialize MinParentSize

MinParentSize = 1;

%% Find the maximum value for MinParentSize with 0 loss

while true

    tree2 = fitctree(dataTabe(:, 1:3), target, 'MinParentSize', MinParentSize);

    if loss(tree2, dataTabe(:, 1:3), target) == 0

        break;  

    else

        MinParentSize = MinParentSize + 1;  

    end

end

%% Display Tree 2 and maximum minparentsize with zero loss

disp(['Maximum MinParentSize for zero loss: ', num2str(MinParentSize)]);
disp('Decision Tree2:');
view(tree2, "Mode", 'text');
view(tree2, 'Mode', 'graph');

