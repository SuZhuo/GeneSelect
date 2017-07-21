%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%统计分类正确率
%%


[m,n] = size(test);
thres = 100;
results = zeros(1,900);

for k = 1:900
    error1 = 0;error2 = 0;
    for i = 1:m
        result = classifyTwo(test,i,class_decide(k,:),class_sp(k,:));
        if(i<=thres&&result>0)
            error1 = error1+1;
        end
        if(i>thres&&result<=0)
            error2 = error2+1;
        end
    end
    er = (error1+error2)/m;
    results(1,k) = 1-er;
    k
end

%求每个基因的分类正确率
results_gene = zeros(1,300);
for i = 1:300
    results_gene(1,i) = max(results(1,3*(i-1)+1:3*(i-1)+3));
end
