%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%º∆À„Gini÷µ
%%

function [Gini,precision] = getGini(index,index_vali)
m = size(index,2);
P = 0;N = 0;
for ii = 1:m
    i = index(ii);
    if(i<=400)
        P = P+1;
    else
        N = N+1;
    end
end
Gini = 1-power(P/m,2)-power(N/m,2);
if(P>=N)
    decide = -1;
else
    decide = 1;
end

m = size(index_vali,2);
P = 0;N = 0;
for ii = 1:m
    i = index_vali(ii);
    if(i<=400)
        P = P+1;
    else
        N = N+1;
    end
end
if(decide<0)
    precision = P/m;
else
    precision = N/m;
end