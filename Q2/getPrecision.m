%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%计算节点放入后的OOB分类准确率
%%


function [precisionA,precisionB,precisionC,ind_valiA,ind_valiB,ind_valiC,posPrecision] = getPrecision(train,index_vali,i_max,decideA,decideB,decideC)
m = size(index_vali,2);
if(m==0)
    precisionA = 0;precisionB = 0;precisionC = 0;ind_valiA = 0;ind_valiB = 0;ind_valiC = 0;
    posPrecision = 0;
    return;
end

i = index_vali(1,1);
if(i==0)
    precisionA = 0;precisionB = 0;precisionC = 0;ind_valiA = 0;ind_valiB = 0;ind_valiC = 0;
    posPrecision = 0;
    return;
end

P1 = 0;P2 = 0;P3 = 0;
N1 = 0;N2 = 0;N3 = 0;
ind_valiA = zeros(1,m);
ind_valiB = zeros(1,m);
ind_valiC = zeros(1,m);

for ii = 1:m
    i = index_vali(1,ii);
    if(i==0)
        precisionA = 0;precisionB = 0;precisionC = 0;ind_valiA = 0;ind_valiB = 0;ind_valiC = 0;
        posPrecision = 0;
        return;
    end
    if(i<=400)
        if(train(i,i_max)==0)
            P1 = P1+1;
            ind_valiA(1,P1+N1) = i;
        else
            if(train(i,i_max)==1)
                P2 = P2+1;
                ind_valiB(1,P2+N2) = i;
            else
                P3 = P3+1;
                ind_valiC(1,P3+N3) = i;
            end
        end
    else
        if(train(i,i_max)==0)
            N1 = N1+1;
            ind_valiA(1,P1+N1) = i;
        else
            if(train(i,i_max)==1)
                N2 = N2+1;
                ind_valiB(1,P2+N2) = i;
            else
                N3 = N3+1;
                ind_valiC(1,P3+N3) = i;
            end
        end
    end
end

iA = find(ind_valiA,1,'last');
ind_valiA = ind_valiA(1,1:iA);
iB = find(ind_valiB,1,'last');
ind_valiB = ind_valiB(1,1:iB);
iC = find(ind_valiC,1,'last');
ind_valiC = ind_valiC(1,1:iC);

if(P1+N1==0)
    precisionA = 0;
else
    if(decideA>0)
        precisionA = N1/(P1+N1);
    else
        if(decideA==0)
            precisionA = 0.5;
        else
            precisionA = P1/(P1+N1);
        end
    end
end
if(P2+N2==0)
    precisionB = 0;
else
    if(decideB>0)
        precisionB = N2/(P2+N2);
    else
        if(decideB==0)
            precisionB = 0.5;
        else
            precisionB = P2/(P2+N2);
        end
    end
end
if(P3+N3==0)
    precisionC = 0;
else
    if(decideC>0)
        precisionC = N3/(P3+N3);
    else
        if(decideC==0)
            precisionC = 0.5;
        else
            precisionC = P3/(P3+N3);
        end
    end
end
posPrecision = precisionA*(P1+N1)/m+precisionB*(P2+N2)/m+precisionC*(P3+N3)/m;
end
    
        