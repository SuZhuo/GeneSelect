%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016
%%


function Var= getVar(index,score)
train_score = score(index,:);
Var = std(train_score);
end