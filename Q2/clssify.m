%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%分类器工作
%%


function class = clssify(infos,clsfiers,test,k,str_info)
[bool,ind] = ismember(str_info,infos);
if(~bool)
    %搜索节点
    [bool, ~] = ismember([str_info,'P'],infos);
    if(bool)
        class = -1;
    else
        [bool,~] = ismember([str_info,'N'],infos);
        if(bool)
            class = 1;
        else
            class = 0;%give up
        end
    end
else
    str_gen = num2str(test(k,clsfiers(1,ind)));
    str_info = [str_info,str_gen];
    class = clssify(infos,clsfiers,test,k,str_info);
end
end
        