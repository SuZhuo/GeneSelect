%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016
%%


function [snp,cls_index,improve] = get_tree2(train,mtry,index,Gini,snp,wt,k,cls_index,str_info,maximum,index_vali,precision)
global clsfiers;
global infos;
n = size(train,2);
m = size(index,2);
subf = randperm(n,mtry);
indexAA = zeros(1,m);
indexBB = zeros(1,m);
indexCC = zeros(1,m);
posG1 = 0;posG2 = 0;posG3 = 0;
delta_i = 0;
i_max = 0;
R1 = 0; R2 = 0; R3 = 0;
decideA = 0;decideB = 0;decideC = 0;
for jj = 1:mtry
    j = subf(jj);
    indexA = zeros(1,m);
    indexB = zeros(1,m);
    indexC = zeros(1,m);
    P1 = 0;P2 = 0;P3 = 0;
    N1 = 0;N2 = 0;N3 = 0;
    for ii = 1:m
        i = index(ii);
        if(i<=400)
            if(train(i,j)==0)
                P1 = P1+1;
                indexA(1,P1+N1) = i;
            else
                if(train(i,j)==1)
                    P2 = P2+1;
                    indexB(1,P2+N2) = i;
                else
                    P3 = P3+1;
                    indexC(1,P3+N3) = i;
                end
            end
        else
            if(train(i,j)==0)
                N1 = N1+1;
                indexA(1,P1+N1) = i;
            else
                if(train(i,j)==1)
                    N2 = N2+1;
                    indexB(1,P2+N2) = i;
                else
                    N3 = N3+1;
                    indexC(1,P3+N3) = i;
                end
            end
        end
    end
    sumP = P1+P2+P3;
    sumN = N1+N2+N3;
    if(sumP==0||sumN==0)
        cls_index = cls_index+1;
        if(sumP>sumN)
            infos{k,cls_index} = [str_info,'P'];
        else 
            if(sumP<sumN)
                infos{k,cls_index} = [str_info,'N'];
            else
                infos{k,cls_index} = [str_info,'Q'];
            end
        end
%         deep = 0;
        improve = 0;
        return;
    end
    sum1 = P1+N1;
    rate1 = sum1/m;
    if(sum1==0)
        posGg1 = 0;
    else
        posGg1 = 1-power(P1/sum1,2)-power(N1/sum1,2);
    end
    sum2 = P2+N2;
    rate2 = sum2/m;
    if(sum2==0)
        posGg2 = 0;
    else
        posGg2 = 1-power(P2/sum2,2)-power(N2/sum2,2);
    end
    sum3 = P3+N3;
    rate3 = sum3/m;
    if(sum3==0)
        posGg3 = 0;
    else
        posGg3 = 1-power(P3/sum3,2)-power(N3/sum3,2);
    end
    delta = Gini - rate1*posGg1 - rate2*posGg2 - rate3*posGg3;
    if(delta>delta_i)%保证选出使Gini值下降最大的位点
        delta_i = delta;
        i_max = j;
        indexAA = indexA;%位点信息为0的样本子集
        indexBB = indexB;%位点信息为1的样本子集
        indexCC = indexC;%位点信息为2的样本子集
        posG1 = posGg1;
        posG2 = posGg2;
        posG3 = posGg3;
        R1 = rate1;
        R2 = rate2;
        R3 = rate3;
        if(N1>P1)
            decideA = 1;
        else
            if(N1==P1)
                decideA = 0;
            else
                decideA = -1;
            end
        end
        if(N2>P2)
            decideB = 1;
        else
            if(N2==P2)
                decideB = 0;
            else
                decideB = -1;
            end
        end
        if(N3>P3)
            decideC = 1;
        else
            if(N3==P3)
                decideC = 0;
            else
                decideC = -1;
            end
        end
    end
end
if(cls_index==maximum-1)
    cls_index = cls_index+1;
    if(sumP>sumN)
        infos{k,cls_index} = [str_info,'P'];
    else 
        if(sumP<sumN)
            infos{k,cls_index} = [str_info,'N'];
        else
            infos{k,cls_index} = [str_info,'Q'];
        end
    end
    improve = 0;
    return;
end


iA = find(indexAA,1,'last');
indexAA = indexAA(1,1:iA);
iB = find(indexBB,1,'last');
indexBB = indexBB(1,1:iB);
iC = find(indexCC,1,'last');
indexCC = indexCC(1,1:iC);

%计算OOB上的分类准确率，决定是否预剪枝
[precisionA,precisionB,precisionC,ind_valiA,ind_valiB,ind_valiC,posPrecision] = getPrecision(train,index_vali,i_max,decideA,decideB,decideC);
improve = posPrecision - precision;
if(improve<precision*0.03)
    cls_index = cls_index+1;
    if(sumP>sumN)
        infos{k,cls_index} = [str_info,'P'];
    else 
        if(sumP<sumN)
            infos{k,cls_index} = [str_info,'N'];
        else
            infos{k,cls_index} = [str_info,'Q'];
        end
    end
    improve = 0;
    return;
end

snp(1,i_max) = snp(1,i_max)+delta_i*wt;
cls_index = cls_index+1;

clsfiers(k,cls_index) = i_max;
infos{k,cls_index} = str_info;

%递归式扩展节点
if(~isempty(indexAA))
    [snp,cls_index,improveA] = get_tree2(train,mtry,indexAA,posG1,snp,R1*wt,k,cls_index,[str_info,'0'],maximum,ind_valiA,precisionA);
    improve = improve + R1*wt*improveA;
end
if(~isempty(indexBB))
    [snp,cls_index,improveB] = get_tree2(train,mtry,indexBB,posG2,snp,R2*wt,k,cls_index,[str_info,'1'],maximum,ind_valiB,precisionB);
    improve = improve+R2*wt*improveB;
end
if(~isempty(indexCC))
    [snp,cls_index,improveC] = get_tree2(train,mtry,indexCC,posG3,snp,R3*wt,k,cls_index,[str_info,'2'],maximum,ind_valiC,precisionC);
    improve = improve + R3*wt*improveC;
end
end
        