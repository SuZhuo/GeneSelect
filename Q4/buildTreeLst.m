%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%生成基于方差下降的随机森林
%%

ntree = 500;
%得到的SNP即为每个位点的方差下降贡献值
mtry = 90;
maximum = 350;
[m_train,n_train] = size(train);
SNP = zeros(1,n_train);
k = 1;
count = 0;
while(k<=ntree)
    snp = zeros(1,n_train);
    %不采取自主采样，而是每次选出无重复的800个样本
    index = (1:800);
    Gini = getVar(index,score);
    cls_index = 0;
    %生成每一棵树
     [snp,cls_index]= getTreeLst(train,mtry,index,cls_index,Gini,snp,1,k,maximum,score);
    SNP = SNP + snp;
    k = k+1;
    k
end
