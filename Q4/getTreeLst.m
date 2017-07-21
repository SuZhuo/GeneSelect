%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%树的生成过程
%%

function [snp,cls_index]= getTreeLst(train,mtry,index,cls_index,Gini,snp,wt,k,maximum,score)
if(Gini<0.2||cls_index>=maximum)%停止扩展准则
    return;
end
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
for jj = 1:mtry
    j = subf(jj);
    indexA = zeros(1,m);
    indexB = zeros(1,m);
    indexC = zeros(1,m);
    P1 = 0;P2 = 0;P3 = 0;
    rP1 = 0;rP2 = 0;rP3 = 0;
    N1 = 0;N2 = 0;N3 = 0;
    rN1 = 0;rN2 = 0;rN3 = 0;
    for ii = 1:m
        i = index(ii);
        ts = score(i,1);
        if(ts<=0)
            if(train(i,j)==0)
                P1 = P1+1;
                indexA(1,P1+N1) = i;
                rP1 = rP1+ts;
            else
                if(train(i,j)==1)
                    P2 = P2+1;
                    indexB(1,P2+N2) = i;
                    rP2 = rP2+ts;
                else
                    P3 = P3+1;
                    indexC(1,P3+N3) = i;
                    rP3 = rP3+ts;
                end
            end
        else
            if(train(i,j)==0)
                N1 = N1+1;
                indexA(1,P1+N1) = i;
                rN1 = rN1+ts;
            else
                if(train(i,j)==1)
                    N2 = N2+1;
                    indexB(1,P2+N2) = i;
                    rN2 = rN2+ts;
                else
                    N3 = N3+1;
                    indexC(1,P3+N3) = i;
                    rN3 = rN3+ts;
                end
            end
        end
    end
    sum1 = P1+N1;
    rate1 = sum1/m;
    if(sum1==0)
        posGg1 = 0;
    else
        posGg1 = getPosGg(score,indexA);
    end
    sum2 = P2+N2;
    rate2 = sum2/m;
    if(sum2==0)
        posGg2 = 0;
    else
        posGg2 = getPosGg(score,indexB);
    end
    sum3 = P3+N3;
    rate3 = sum3/m;
    if(sum3==0)
        posGg3 = 0;
    else
        posGg3 = getPosGg(score,indexC);
    end
    delta = Gini - rate1*posGg1 - rate2*posGg2 - rate3*posGg3;
    if(delta>delta_i)
        delta_i = delta;
        i_max = j;
        indexAA = indexA;
        indexBB = indexB;
        indexCC = indexC;
        posG1 = posGg1;
        posG2 = posGg2;
        posG3 = posGg3;
        R1 = rate1;
        R2 = rate2;
        R3 = rate3;
    end
end



iA = find(indexAA,1,'last');
indexAA = indexAA(1,1:iA);
iB = find(indexBB,1,'last');
indexBB = indexBB(1,1:iB);
iC = find(indexCC,1,'last');
indexCC = indexCC(1,1:iC);

snp(1,i_max) = snp(1,i_max)+delta_i*wt;
cls_index = cls_index+1;

%递归式扩展节点
if(~isempty(indexAA))
    [snp,cls_index] = getTreeLst(train,mtry,indexAA,cls_index,posG1,snp,R1*wt,k,maximum,score);
end
if(~isempty(indexBB))
    [snp,cls_index] = getTreeLst(train,mtry,indexBB,cls_index,posG2,snp,R2*wt,k,maximum,score);
end
if(~isempty(indexCC))
    [snp,cls_index] = getTreeLst(train,mtry,indexCC,cls_index,posG3,snp,R3*wt,k,maximum,score);
end
end
        