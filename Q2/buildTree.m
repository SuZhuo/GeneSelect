%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016
%基于GINI值下降的预剪枝树随机森林
%%

ntree = 1500;%树数目
mtry = 200;%特征子集中特征数目
maximum = 200;
[m_train,n_train] = size(train);
SNP = zeros(1,n_train);
global clsfiers;
global infos;
clsfiers = zeros(ntree,maximum);%位点信息
infos = cell(ntree,maximum);%每个节点的信息
k = 1;
count = 0;
imp = zeros(ntree,1);
pre = zeros(ntree,1);
while(k<=ntree)
    snp = zeros(1,n_train);
    %this_train = bootstrap(train);
    index = randi(m_train,1,m_train);
    index_vali = setdiff((1:m_train),index);
    [Gini,precision] = getGini(index,index_vali);
    cls_index = 0;
    str_info = '0';
    %开始生成每一棵树
    [snp,cls_index,improve] = get_tree2(train,mtry,index,Gini,snp,1,k,cls_index,str_info,maximum,index_vali,precision);
    posPre = improve+precision;
    if(posPre>0.5&&cls_index>=4)
        pre(k,1) = posPre;
        imp(k,1) = improve;
        SNP = SNP + snp;
        k = k+1;
        k
    end
    count = count+1;
end
count
[m,n] = size(infos);
for i = 1:m
    for j = 1:n
        if(isempty(infos{i,j}))
            infos{i,j} = '';
        end
    end
end

sumpre = sum(pre);
weit = pre/sumpre;
% cls_index
%  [re,indexRe] = sort(SNP,'descend');
%  plot(re);
