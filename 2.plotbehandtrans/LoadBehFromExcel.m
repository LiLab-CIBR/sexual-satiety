function [form_label,events,datelist] = LoadBehFromExcel(xls)

result_folder = xls.excel_folder;
clusterlist = xls.clusterlist;
gender = xls.gender;

for i = 1:length(clusterlist)
    [xls_path{i},datelist{i}] = read2excel(result_folder,clusterlist{i});
end

% if xls.dorefine
%     for i = 1:size(xls_path,2)
%         for j = 1:size(xls_path{i},2) 
%             [num2,content,~]=xlsread(xls_path{i}{j},1,'A:I');
%             for k = 17:size(content,1)
%                 if isempty(content{k,1})
%                     content{k,1} = num2str(num2(k-10,1));
%                 end
%             end
%             if contains(gender,'fe')
%                 for k = 1:size(content,1)
%                     if contains(content{k,6},'sniff')&&~contains(content{k,6},'ive')
%                         content{k,6} = 'passive(sniff)';
%                     elseif contains(content{k,6},'mount')&&~contains(content{k,6},'ing')&&~contains(content{k,6},'ed')
%                         content{k,6} = 'mounted';
%                     elseif contains(content{k,6},'intro')&&~contains(content{k,6},'ssion')&&~contains(content{k,6},'ed')
%                         content{k,6} = 'intromitted';
%                     elseif contains(content{k,6},'ejacu')&&~contains(content{k,6},'tion')&&~contains(content{k,6},'ed')
%                         content{k,6} = 'ejaculated';
%                     elseif contains(content{k,6},'sit')&&~contains(content{k,6},'ive')
%                         content{k,6} = 'sitting';
%                     elseif contains(content{k,6},'shallow')
%                         content{k,6} = 'lordosis';
%                     end
%                 end
%             else
%                 for k = 1:size(content,1)
%                     if contains(content{k,6},'sniff')&&~contains(content{k,6},'ive')
%                         content{k,6} = 'positive(sniff)';
%                     elseif contains(content{k,6},'mount')&&~contains(content{k,6},'ing')&&~contains(content{k,6},'ed')
%                         content{k,6} = 'mounting';
%                     elseif contains(content{k,6},'intro')&&~contains(content{k,6},'ssion')&&~contains(content{k,6},'ed')
%                         content{k,6} = 'intromission';
%                     elseif contains(content{k,6},'ejacu')&&~contains(content{k,6},'tion')&&~contains(content{k,6},'ed')
%                         content{k,6} = 'ejaculation';
%                     end
%                 end                
%             end
%             xlswrite(xls_path{i}{j},content,1)
%         end
%     end
% end

for i = 1:size(xls_path,2)
    for j = 1:size(xls_path{i},2) 
        [form_label{i}{j},events{i}{j}] = behxlsreadnointruder(xls_path{i}{j});
    end
end

end

