%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%���ɻ��ڷ����½������ɭ��
%%

ntree = 500;
%�õ���SNP��Ϊÿ��λ��ķ����½�����ֵ
mtry = 90;
maximum = 350;
[m_train,n_train] = size(train);
SNP = zeros(1,n_train);
k = 1;
count = 0;
while(k<=ntree)
    snp = zeros(1,n_train);
    %����ȡ��������������ÿ��ѡ�����ظ���800������
    index = (1:800);
    Gini = getVar(index,score);
    cls_index = 0;
    %����ÿһ����
     [snp,cls_index]= getTreeLst(train,mtry,index,cls_index,Gini,snp,1,k,maximum,score);
    SNP = SNP + snp;
    k = k+1;
    k
end
