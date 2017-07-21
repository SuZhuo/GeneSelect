%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%分类器工作
%%


function class = classifyTwo(test,k,info,clsfier)
num = clsfier(1,1);
pos = 1;
for i = 1:num
    sn = test(k,clsfier(1,i+1));
    pos = pos+sn*power(3,num-i);
end
class = info(1,pos);