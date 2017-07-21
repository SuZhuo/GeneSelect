%%
%%Authour: Zhuo Su, Chongke Wu, Fengyun Li
% Date: 09/2016

%生成300个基因的文件，用于MDR分析
%%


m = size(train,1);
for k = 1:20
    strk = num2str(k);
    fid = fopen(['info300\\info_',strk,'.txt'],'w');
    n = find(gene_s(k,:),1,'last');
    for j = 1:n
        index = gene_s(k,j);
        fprintf(fid,'%u ',index);
    end
    fprintf(fid,'class');
    fprintf(fid,'\n');
    for i = 1:m
        for j = 1:n
            fprintf(fid,'%u ',train(i,gene_s(k,j)));
        end
        if(i<=400)
            fprintf(fid,'0\n');
        else
            fprintf(fid,'1\n');
        end
    end
    fclose(fid);
    k
end
