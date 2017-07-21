%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016
%在测试集test上进行分类验证
%%


[m,n] = size(test);
thres = 100;
ntree = size(clsfiers,1);
error1 = 0;error2 = 0;spe = 0;
label = zeros(m,1);
sumP = 0;
sumN = 0;
for i = 1:m
    result = 0;
    for k = 1:ntree
        str_info = '0';
        %调用分类器，整个随机森林由(infos,clsfiers)表示
        class = clssify(infos(k,:),clsfiers(k,:),test,i,str_info);
        result = result + class;
    end
    label(i,1) = result;
    if(result>0)
        sumP = sumP+result;
    else
        sumN = sumN+result;
    end
    if(i<=thres&&result>0)
        error1 = error1+1;
    end
    if(i>thres&&result<=0)
        error2 = error2+1;
    end
    i
end
er = (error1+error2)/m;
error1
error2
er

