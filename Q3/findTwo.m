%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%根据MDR分析生成分类器
%%

class_decide = zeros(900,27);
class_sp = zeros(900,4);

for k = 1:900
    k2 = mod(k,3);
    if(k2==0)
        k1 = floor(k/3);
        k2 = 3;
    else
        k1 = floor(k/3)+1;
    end
    strk1 = num2str(k1);
    strk2 = num2str(k2);
    fid = fopen(['test300\\',strk1,'_',strk2,'.txt']);
    line = fgetl(fid);
    pos = find(line==']',1,'first');
    genes = str2num(line(1:pos));
    num = size(genes,2);
    class_sp(k,1) = num;
    for i = 1:num
        class_sp(k,i+1) = genes(1,i);
    end
    count = 0;
    while(1)
        line = fgetl(fid);
        if(line == -1)
            break;
        end
        count = count+1;
        decide = str2num(line(end-2:end));
        class_decide(k,count) = decide;
    end
    fclose(fid);
    k
end