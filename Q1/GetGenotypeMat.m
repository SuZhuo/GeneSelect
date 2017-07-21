%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016
%第一题，编码并提取样本
%%

m = 1000;
n = 9445;
origin = cell(m,n);
fid = fopen('genotype.dat');
title = fscanf(fid,'%s',[n,1]);
for i = 1:m
    for j = 1:n
        origin{i,j} = fscanf(fid,'%s',[1,1]);
    end
end
fclose(fid);
save('Origin','origin');

m = 1000;
n = 9445;
data = zeros(m,n);%最后得到的样本文件

for i = 1:n
    buffer = origin(:,i);
    for k = 1:m
        if(buffer{k}(1)~=buffer{k}(2))
            if(buffer{k}(1)<buffer{k}(2))
                A = buffer{k}(1);
                B = buffer{k}(2);
            else
                A = buffer{k}(2);
                B = buffer{k}(1);
            end
            break;
        end
    end
    for j = 1:m
        if(buffer{j}(1)==buffer{j}(2))
            if(buffer{j}(1)==A)
                data(j,i) = 0;
            else
                data(j,i) = 2;
            end
        else
            data(j,i) = 1;
        end
    end
end

